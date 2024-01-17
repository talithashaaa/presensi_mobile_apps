import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/model/exit_model.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';

class ExitService {
  Future<void> postExit(Exit exit, String bearerToken) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.entryEndPoints.exit}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: exitToJson(exit),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      } else {
        print('Failed to post EXIT SERVICES: ${response.body}');
        throw Exception(
            'Failed to fetch EXIT. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during statistic fetch: $e');
    }
  }
}
