import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';

class PhotoService {
  static var client = http.Client();

  static Future<String?> getProfilePhoto(
    String bearerToken,
  ) async {
    try {
      String url =
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.getphoto}';
      print('Fetching GET PHOTO from: $url');

      var response = await client.get(
        Uri.parse(url),
        headers: {
          'Authorization': bearerToken,
        },
      );

      if (response.statusCode == 200) {
        // print('${response.body}');
        return response.body; // Directly return the URL
      } else {
        print(
            'Failed to fetch profile photo. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error while fetching profile photo: $error');
      return null;
    }
  }
}
