import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/model/history_model.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';

class HistoryServices {
  static Future<List<History>> fetchHistory(String bearerToken) async {
    http.Client client = http.Client();

    try {
      String url =
          '${ApiEndPoints.baseUrl}${ApiEndPoints.historyEndPoints.history}';
      print('Fetching HISTORY list from: $url');
      print('Bearer Token HISTORY before making HTTP request: $bearerToken');

      var response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
      );

      print('Bearer Token HISTORY: $bearerToken');
      print('Response status code HISTORY: ${response.statusCode}');
      print('Response body HISTORY: ${response.body}');

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final Map<String, dynamic> decodedData = json.decode(response.body);

        List<History> historyData = [History.fromJson(decodedData)];

        return historyData;
      } else {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to fetch history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during history fetch SERVICE: $e');
      throw e; // Rethrow the exception to propagate it to the caller
    } finally {
      client.close();
    }
  }
}
