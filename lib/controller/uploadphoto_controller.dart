import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:presensi_mobile_apps/services/uploadphoto_services.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageController extends GetxController {
  final UploadPhotoService _uploadPhotoService =
      UploadPhotoService(ApiEndPoints.baseUrl);

  RxBool isLoading = false.obs;
  @override
  void onInit() async {
    print('Initializing ENTRYController');
    final String bearerToken = await getBearerToken();
    print('Bearer Token BEFORE UPLOAD PHOTO: $bearerToken');
    // fetchProfile(bearerToken);
    super.onInit();
  }

  Future<void> uploadPhoto(Uint8List imageBytes) async {
    try {
      isLoading.value = true;
      final String bearerToken = await getBearerToken();
      print('Bearer Token before uploading photo: $bearerToken');
      bool success =
          await _uploadPhotoService.uploadPhoto(imageBytes, bearerToken);

      if (success) {
        // Handle jika upload sukses
        print('Photo uploaded successfully');
      } else {
        // Handle jika upload gagal
        print('Failed to upload photo');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during photo upload: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getBearerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "Default Bearer Token";
    print('Original Bearer Token from SharedPreferences: $token');
    return token;
  }
}
