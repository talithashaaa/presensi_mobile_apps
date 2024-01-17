import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/model/statistic_model.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'dart:convert';

class StatisticServices {
  static var client = http.Client();

  static Future<List<Statistic>> fetchStatistic(
    String bearerToken,
  ) async {
    try {
      String url =
          '${ApiEndPoints.baseUrl}${ApiEndPoints.profileEndPoints.statistic}';
      // print('Fetching statistic from: $url');

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

        List<Statistic> statisticData = [Statistic.fromJson(decodedData)];

        return statisticData;
      } else {
        // print('Error response body: ${response.body}');
        throw Exception(
            'Failed to fetch statistic. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during statistic fetch: $e');
    } finally {
      client.close();
    }
  }
}
