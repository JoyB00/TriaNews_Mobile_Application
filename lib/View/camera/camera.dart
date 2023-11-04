import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:modul_cam_qr_1095/utils/logging_utils.dart';
import 'package:news_pbp/View/camera/display_picture.dart';
import 'package:news_pbp/View/inputanberita.dart';
//import 'package:news_pbp/View/profile.dart';
import 'package:news_pbp/pages/profileNew.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_pbp/database/sql_helper.dart';

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
    List<Map<String, dynamic>> user = await SQLHelper.getUser(prefs.getInt('userId') ?? 0);
    setState(() {
      id = user[0]['id'];
      nama = user[0]['username'];
    });
  }

  String convertImagetoString(image){
    String imgString = Utility.base64String(image.readAsBytesSync());
    return imgString;
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
      // LoggingUtils.logEndFunction("success initialize camera".toUpperCase());
    }
  }

  @override
  void dispose() {
    // LoggingUtils.logStartFunction("dispose CameraView".toUpperCase());
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
        title: Text(nama),
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await previewImageResult(),
        child: const Icon(Icons.camera_alt),
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
          // LoggingUtils.logDebugValue(
          //     "get image on previewImageResult".toUpperCase(),
          //     "image.path : ${image.path}");
          return ProfilePage(
              imagePath: image.path, cameraController: _cameraController);
        }),
      );
    } catch (e) {
      // LoggingUtils.logError(activity, e.toString());
      return null;
    }
    return null;
  }

  Future<void> editImage(int id, String result) async {
    await SQLHelper.addImage(result, id);
  }
}

