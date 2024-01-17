import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/model/profile_model.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'dart:convert';

class ProfileServices {
  static var client = http.Client();

  static Future<List<Profile>> fetchProfile(
    String bearerToken,
  ) async {
    try {
      String url =
          '${ApiEndPoints.baseUrl}${ApiEndPoints.profileEndPoints.profile}';
      // print('Fetching profile from: $url');

      var response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
      );

      if (response.statusCode == 200) {
        // print('Response body: ${response.body}');
        final Map<String, dynamic> decodedData = json.decode(response.body);

        List<Profile> profileData = [Profile.fromJson(decodedData)];

        return profileData;
      } else {
        // print('Error response body: ${response.body}');
        throw Exception(
            'Failed to fetch profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during profile fetch: $e');
    } finally {
      client.close();
    }
  }
}
