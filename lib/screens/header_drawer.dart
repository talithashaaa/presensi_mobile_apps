import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi_mobile_apps/controller/getphoto_controller.dart';
import 'package:presensi_mobile_apps/controller/profile_controller.dart';
import 'package:presensi_mobile_apps/controller/uploadphoto_controller.dart';
import 'package:presensi_mobile_apps/model/profile_model.dart';

import 'package:presensi_mobile_apps/controller/statistic_controller.dart';
import 'package:presensi_mobile_apps/model/statistic_model.dart';
import 'package:presensi_mobile_apps/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:convert/convert.dart';

import '../main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp(isLoggedIn: true));
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? storedToken = prefs.getString('token');
//   runApp(MyApp(isLoggedIn: storedToken != null));
// }

class MyHeaderDrawer extends StatefulWidget {
  final bool isLoggedIn; // Add this line

  const MyHeaderDrawer({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  final ImageController imageController = Get.put(ImageController());
  final ProfileController profileController = Get.put(ProfileController());
  final StatisticController statisticController =
      Get.put(StatisticController());
  final GetPhotoController getPhotoController = Get.put(GetPhotoController());

  // String imagePath = 'assets/images/avatar.png';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "Token not found";
      checkGetProfile();
      final String uid = await getUid();

      profileController.fetchProfile(token);
      statisticController.fetchStatistic(token);
      getPhotoController.fetchProfilePhoto(token);
      // checkAuthenticationState();
    });
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UID') ?? "Default UID";
  }

  Future<void> checkGetProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String token = prefs.getString('token') ?? "Token not found";
    String UID = prefs.getString('UID') ?? "UID not found";

    print("IsLoggedIn: $isLoggedIn");
    print("Token during checkGETPROFILE: $token");
    print("UID during checkGETPROFILE: $UID");
  }

  Uint8List? _image;

  void selectImage() async {
    try {
      Uint8List img = await pickImage(ImageSource.gallery);
      if (img != null) {
        setState(() {
          _image = img;
        });
        saveProfile();
      }
    } catch (error) {
      print('Error selecting image: $error');
    }
  }

  void saveProfile() async {
    try {
      if (_image != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token') ?? "Token not found";
        await sendImageToApi(_image!, token);
      }
    } catch (error) {
      print('Error saving profile: $error');
    }
  }

  Future<void> sendImageToApi(Uint8List image, String token) async {
    try {
      print('Sending image to API...');
      final String apiUrl =
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.uploadphoto}';

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Attach the image to the request
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          image,
          filename: 'profile_image.jpg',
        ),
      );
      request.headers['Authorization'] = 'Bearer $token';
      print('Token: $token');

      // Send the request
      var response = await request.send();

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        // You can handle the response from the server if needed
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  // Future<void> checkAuthenticationState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   String token = prefs.getString('token') ?? "Token not found";
  //   String UID = prefs.getString('UID') ?? "UID not found";
  //   print("IsLoggedIn: $isLoggedIn");
  //   print("Token IMAGE PROFILE: $token");
  //   print("UID IMAGE PROFILE: $UID");

  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     print('User: $user');
  //     fetchProfilePhoto();
  //   } else {
  //     print('User: null');
  //   }
  // }

//   Future<String?> fetchProfilePhoto() async {
//   try {
//     // Modify this part based on how you identify your users
//     String userName = "DefaultName";

//     FirebaseStorage storage = FirebaseStorage.instance;
//     Reference ref = storage.ref().child('ProfilePhoto/$userName.jpg');
//     String imageUrl = await ref.getDownloadURL();

//     // Remove unwanted escape characters from the URL
//     imageUrl = imageUrl.replaceAll(r"\/", "/");

//     print('Downloaded imageUrl: $imageUrl');
//     return imageUrl.isNotEmpty ? imageUrl : null;
//   } catch (error) {
//     print('Error while fetching profile photo: $error');
//     return null;
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildProfileWidget(),
      ],
    );
  }

  Widget buildProfileWidget() {
    return Obx(() {
      var profileList = profileController.profileList;
      var statisticList = statisticController.statisticList;

      if (profileList.isEmpty || statisticList.isEmpty) {
        // Tampilkan indikator loading atau pesan lain
        return CircularProgressIndicator();
      } else {
        try {
          Profile profile = profileList.first;
          Statistic statistic = statisticList.first;

          return buildProfileItem(profile, statistic);
        } catch (error) {
          print('Error building profile widget: $error');
          // Tangani error tanpa menampilkan ke view (misalnya, tampilkan snackbar)
          return Container(); // Atau widget lainnya sesuai kebutuhan
        }
      }
    });
  }

  Widget buildProgressBar(String label, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: 120.0, // Adjust the width of the progress bar
          child: LinearProgressIndicator(
            value: percentage / 100.0,
            backgroundColor: Colors.grey[400],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEA2F2F)),
            // Adjust the height of the progress bar
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget buildProfileItem(Profile profile, Statistic statistic) {
    return Container(
      color: Color(0xff004B93),
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0, left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        profile.position,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // SizedBox(height: 5),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  _image != null
                                      ? Container(
                                          height: 110.0,
                                          width: 110.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            image: DecorationImage(
                                              image: MemoryImage(_image!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Obx(() {
                                          String imageUrl = getPhotoController
                                                  .imageUrl.value ??
                                              "";

                                          // imageUrl = imageUrl.trim();
                                          imageUrl =
                                              imageUrl.replaceAll("\\/", "/");
                                          // imageUrl =
                                          // Uri.decodeComponent(imageUrl);

                                          if (imageUrl != null &&
                                              imageUrl.isNotEmpty) {
                                            return Container(
                                              height: 125.0,
                                              width: 125.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                image: DecorationImage(
                                                  image: Image.network(imageUrl
                                                          .replaceAll('"', ''))
                                                      .image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              height: 110.0,
                                              width: 110.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/avatar.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          }
                                        }),
                                  Positioned(
                                    child: IconButton(
                                      onPressed: selectImage,
                                      icon: Icon(Icons.add_a_photo),
                                    ),
                                    bottom: -14,
                                    left: 68,
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // buildProgressBar('Kehadiran',
                                  //     statistic.presencePercent.toDouble()),
                                  // buildProgressBar('Izin',
                                  //     statistic.absentPercent.toDouble()),
                                  buildProgressBar('Telat',
                                      statistic.latePercent.toDouble()),
                                  buildProgressBar('Tepat Waktu',
                                      statistic.onTimePercent.toDouble()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
