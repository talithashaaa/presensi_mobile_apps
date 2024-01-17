import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:presensi_mobile_apps/screens/auth/login.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ForgotController extends GetxController {
  TextEditingController emailController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> forgotpassword() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.forgotpassword);
      Map body = {
        'email': emailController.text,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['code'] == 0) {
          var token = json['data']['Token'];
          print('Token: $token');

          FirebaseAuth auth = FirebaseAuth.instance;
          User? user = auth.currentUser;
          if (user != null) {
            String uid = user.uid;
            print('UID: $uid');
          }
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          String? fcmToken = await messaging.getToken();
          if (fcmToken != null) {
            print('FCM Token: $fcmToken');
          } else {
            print('Unable to get FCM token.');
          }

          final SharedPreferences? prefs = await _prefs;

          await prefs?.setString('token', token);

          emailController.clear();

          Get.off(LoginPage());
        } else {
          throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
        }
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }
}











// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SignUpController extends GetxController {
//   Future<void> forgot(
//       String name, String email, String position, String password) async {
//     final apiUrl =
//         'http://127.0.0.1:8000/api/sign_up'; // Sesuaikan dengan URL API Anda

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         body: jsonEncode({
//           'name': name,
//           'email': email,
//           'position': position,
//           'password': password,
//         }),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         // Registration successful
//         print('Registration successful');
//         print(response.body);
//       } else {
//         // Handle errors
//         print('Error: ${response.statusCode}');
//         print(response.body);
//       }
//     } catch (error) {
//       // Handle network errors
//       print('Error: $error');
//     }
//   }
// }
