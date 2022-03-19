import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future <File> cropSquareImage(File image) async{
  return await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    aspectRatioPresets: [CropAspectRatioPreset.square],
    compressQuality: 70,
    compressFormat: ImageCompressFormat.jpg,
    androidUiSettings: AndroidUiSettings(
      toolbarColor: Colors.teal,
      toolbarTitle: 'Crop Profile Image',
      toolbarWidgetColor: Colors.white,
      hideBottomControls: true,
    ),
  );
}