import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/model/maps_model.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';

class MapsService {
  Future<void> postEntry(Entry entry, String bearerToken) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiEndPoints.baseUrl}${ApiEndPoints.entryEndPoints.entry}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: entryToJson(entry),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      } else {
        print('Failed to post entry SERVICES: ${response.body}');
        throw Exception(
            'Failed to fetch statistic. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during statistic fetch: $e');
    }
  }
}
