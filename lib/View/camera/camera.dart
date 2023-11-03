import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:modul_cam_qr_1095/utils/logging_utils.dart';
import 'package:news_pbp/View/camera/display_picture.dart';
import 'package:news_pbp/View/profile.dart';
import 'package:news_pbp/pages/profileNew.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Future<void>? _initializeCameraFuture;
  late CameraController _cameraController;
  var count = 0;

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
        title: const Text("Take a Picture"),
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
      await _initializeCameraFuture;
      final image = await _cameraController.takePicture();
      if (!mounted) return null;
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
}
