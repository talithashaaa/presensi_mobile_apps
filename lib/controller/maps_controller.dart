import 'package:get/get.dart';
import 'package:presensi_mobile_apps/model/maps_model.dart';
import 'package:presensi_mobile_apps/services/maps_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryController extends GetxController {
  final MapsService _mapsService = MapsService();

  var isLoading = false.obs;

  @override
  void onInit() async {
    print('Initializing ENTRYController');
    final String bearerToken = await getBearerToken();
    print('Bearer Token before fetching PROFILE: $bearerToken');
    // fetchProfile(bearerToken);
    super.onInit();
  }

  Future<void> postEntry(Entry entry) async {
    try {
      isLoading.value = true;
      final String bearerToken = await getBearerToken();
      await _mapsService.postEntry(entry, bearerToken);
      print('Entry posted successfully');
    } catch (e) {
      print('Failed to post entry CONTROLLER: $e');
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
