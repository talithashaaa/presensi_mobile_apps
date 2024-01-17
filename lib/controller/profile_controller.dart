import 'package:get/get.dart';
import 'package:presensi_mobile_apps/model/profile_model.dart';
import 'package:presensi_mobile_apps/services/profile_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profileList = <Profile>[].obs;

  @override
  void onInit() async {
    // print('Initializing ProfileController');
    final String bearerToken = await getBearerToken();
    // print('Bearer Token before fetching PROFILE: $bearerToken');
    fetchProfile(bearerToken);
    super.onInit();
  }

  void fetchProfile(String bearerToken) async {
    try {
      isLoading(true);
      final String bearerToken = await getBearerToken();
      var profileData = await ProfileServices.fetchProfile(bearerToken);
      if (profileData != null) {
        profileList.assignAll(profileData);
      } else {
        // print('Error during PROFILE fetch CONTROLLER: profileData is null');
      }
    } catch (e) {
      // print('Error fetching profile: $e');
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
