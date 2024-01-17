import 'dart:typed_data';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';

class UploadPhotoService {
  final String baseUrl;

  UploadPhotoService(this.baseUrl);

  Future<bool> uploadPhoto(Uint8List imageBytes, String bearerToken) async {
    try {
      print('Sending image to API...');
      print('Original Bearer Token from SharedPreferences: $bearerToken');
      String url = '$baseUrl${ApiEndPoints.authEndPoints.uploadphoto}';
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer $bearerToken",
      };

      String base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({"image": base64Image}),
      );
      print('Sending image to API...');
      print('Original Bearer Token from SharedPreferences: $bearerToken');

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to upload photo. Server response: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error uploading photo: $e');
      return false;
    }
  }
}
