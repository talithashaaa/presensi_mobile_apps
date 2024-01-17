import 'package:get/get.dart';
import 'package:presensi_mobile_apps/model/statistic_model.dart';
import 'package:presensi_mobile_apps/services/statistic_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticController extends GetxController {
  var isLoading = true.obs;
  var statisticList = <Statistic>[].obs;

  @override
  void onInit() async {
    // print('Initializing StatisticController');
    final String bearerToken = await getBearerToken();
    // print('Bearer Token before fetching STATISTIC: $bearerToken');
    fetchStatistic(bearerToken);
    super.onInit();
  }

  void fetchStatistic(String bearerToken) async {
    try {
      isLoading(true);
      final String bearerToken = await getBearerToken();
      var staticData = await StatisticServices.fetchStatistic(bearerToken);
      if (staticData != null) {
        statisticList.assignAll(staticData);
      } else {
        // print('Error during STATISTIC fetch CONTROLLER: staticData is null');
      }
    } catch (e) {
      // print('Error fetching STATISTIC: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<String> getBearerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "Default Bearer Token";
    // print('Original Bearer Token from SharedPreferences: $token');
    return token;
  }
}
