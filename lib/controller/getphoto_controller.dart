import 'package:get/get.dart';
import 'package:presensi_mobile_apps/services/getphoto_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPhotoController extends GetxController {
  var isLoading = true.obs;
  var imageUrl = ''.obs;
  @override
  void onInit() async {
    // print('Initializing ProfileController');
    final String bearerToken = await getBearerToken();
    // print('Bearer Token before fetching PROFILE: $bearerToken');
    fetchProfilePhoto(bearerToken);
    super.onInit();
  }

  Future<void> fetchProfilePhoto(String bearerToken) async {
    try {
      isLoading(true);
      final String bearerToken = await getBearerToken();

      String? photoUrl = await PhotoService.getProfilePhoto(bearerToken);

      if (photoUrl != null && photoUrl.isNotEmpty) {
        imageUrl(photoUrl);
      } else {
        print(Error);
      }
    } catch (error) {
      print('Error fetching profile photo: $error');
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
