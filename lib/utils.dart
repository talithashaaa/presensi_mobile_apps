import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  // try {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    // Uint8List imageBytes = await _file.readAsBytes();
    // return imageBytes;
    return await _file.readAsBytes();
  }
  print('No Images Selected');
  // return null;
  // } catch (e) {
  //   print('Error picking image: $e');
  //   return null;
  // }
}
