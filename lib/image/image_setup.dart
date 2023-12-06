import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64.decode(base64String.replaceAll(RegExp(r'\s+'), '')),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}