import 'package:get/get.dart';
import 'package:presensi_mobile_apps/model/exit_model.dart';
import 'package:presensi_mobile_apps/services/exit_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExitController extends GetxController {
  final ExitService _exitService = ExitService();

  var isLoading = false.obs;

  @override
  void onInit() async {
    print('Initializing EXITController');
    final String bearerToken = await getBearerToken();
    print('Bearer Token before fetching EXIT: $bearerToken');
    // fetchProfile(bearerToken);
    super.onInit();
  }

  Future<void> postExit(Exit exit) async {
    try {
      isLoading.value = true;
      final String bearerToken = await getBearerToken();
      await _exitService.postExit(exit, bearerToken);
      print('EXIT posted successfully');
    } catch (e) {
      print('Failed to post EXIT CONTROLLER: $e');
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
