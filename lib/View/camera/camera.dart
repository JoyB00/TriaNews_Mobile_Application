import 'dart:async';
// import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:news_pbp/View/camera/display_picture.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Future<void>? _initializeCameraFuture;
  late CameraController _cameraController;
  var count = 0;
  var id = 0;
  String nama = 'abc';

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));
    setState(() {
      id = user.id!;
      nama = user.username!;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    // LoggingUtils.logStartFunction("initialize camera".toUpperCase());
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeCameraFuture = _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializeCameraFuture == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ambil Gambar"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 150, bottom: 20),
        child: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(122, 149, 229, 1),
            onPressed: () async => await previewImageResult(),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt),
                Text(
                  "Foto",
                  style: TextStyle(fontSize: 10),
                )
              ],
            )),
      ),
    );
  }

  Future<DisplayPictureScreen?> previewImageResult() async {
    try {
      loadUserData();
      await _initializeCameraFuture;
      final image = await _cameraController.takePicture();
      if (!mounted) return null;
      String result = image.path;
      editImage(id, result);
      Navigator.of(context).pop(
        MaterialPageRoute(builder: (context) {
          _cameraController.pausePreview();
          return const HomePage();
        }),
      );
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> editImage(int id, String result) async {
    User temp = await UserClient.find(id);

    User user = temp;
    user.image = result;

    await UserClient.update(user);
  }
}
