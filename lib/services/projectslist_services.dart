import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/model/projectslist_model.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'package:get/get.dart';

class ProjectsListServices {
  static var client = http.Client();

  static Future<List<ProjectsList>?> fetchProjectsList(
    String bearerToken,
  ) async {
    http.Client client = http.Client();
    try {
      String url =
          '${ApiEndPoints.baseUrl}${ApiEndPoints.projectslistEndPoints.projectslist}';
      print('Fetching projects list from: $url');
      // print('Bearer Token before making HTTP request: $bearerToken');
      var response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
      );
      // print('Bearer Token: $bearerToken');
      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        final String responseData = response.body; // Define responseData here
        final List<dynamic> decodedData = json.decode(responseData);
        print('Decoded Data: $decodedData');

        // Parse the list of projects
        List<ProjectsList>? projectsListData = (decodedData as List<dynamic>)
            .map((projectsListJson) => ProjectsList.fromJson(projectsListJson))
            .toList();

        return projectsListData;
      } else {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to fetch projects list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    } finally {
      client.close();
    }
  }
}
