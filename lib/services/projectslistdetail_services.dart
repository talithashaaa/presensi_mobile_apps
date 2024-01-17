import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/model/projectslistdetail_model.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';

class ProjectListDetailServices {
  static var client = http.Client();

  static Future<ProjectListDetail> fetchProjectListDetail(
      String bearerToken, String project_id) async {
    try {
      String url =
          '${ApiEndPoints.baseUrl}${ApiEndPoints.projectslistEndPoints.projectDetail}/$project_id';
      // print('ApiEndPoints.baseUrl: ${ApiEndPoints.baseUrl}');
      // print(
      //     'ApiEndPoints.projectslistEndPoints.projectDetail: ${ApiEndPoints.projectslistEndPoints.projectDetail}');
      // print('project_id: $project_id');

      print('Fetching project details from: $url');
      var client = http.Client();

      var response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
      );
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        final dynamic decodedData = json.decode(response.body);
        final String responseBody =
            decodedData != null ? decodedData.toString() : '';
        if (decodedData != null) {
          ProjectListDetail projectListDetailData =
              ProjectListDetail.fromJson(decodedData);
          return projectListDetailData;
        } else {
          throw Exception(
              'Failed to fetch project details. Decoded data is null.');
        }
      } else {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to fetch project details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    } finally {
      client.close();
    }
  }
}
