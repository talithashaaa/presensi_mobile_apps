import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'package:presensi_mobile_apps/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> login() async {
    // String token = "nilai_token_yang_diterima_dari_server";
    // String UID = "nilai_uid_yang_diterima_dari_server";
    print('Login function called');

    // var headers = {'Content-Type': 'application/json'};
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.login);
      Map body = {
        'email': emailController.text,
        'password': passwordController.text
      };
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Server Response: ${response.body}');
        var token = jsonDecode(response.body)['token'];
        var UID =
            json['UID'].toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', 'Bearer ' + token);
        await prefs.setString('UID', UID);
        prefs.setBool('isLoggedIn', true);

        print("Login berhasil");
        print('Token yang didapat: $token');
        print("TOKEN $token");
        print('UID yang didapat: $UID');
        print("UID $UID");
        print('Login berhasil');

        if (json['code'] == 0) {
          // var token = json['token'];
          if (token != null) {
            print('Token yang didapat: $token');
            final SharedPreferences? prefs = await _prefs;
            await prefs?.setString('token', token);
            emailController.clear();
            passwordController.clear();

            print('Token Berhasil disimpan: $token');

            Get.off(RealtimeClock());
          } else {
            print('Token is null');
          }
        } else if (json['code'] == 1) {
          print('Error message: ${jsonDecode(response.body)['message']}');
          throw jsonDecode(response.body)['message'];
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
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

  Future<String> logout() async {
    try {
      // Get the stored token from SharedPreferences
      final SharedPreferences? prefs = await _prefs;
      String? token = prefs?.getString('token');

      if (token != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        var url =
            Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.logout);

        http.Response response = await http.post(url, headers: headers);

        if (response.statusCode == 200) {
          // Successful logout, clear SharedPreferences
          await prefs?.clear();
          return 'Logout successful';
        } else {
          throw jsonDecode(response.body)["Message"] ??
              "Unknown Error Occurred";
        }
      } else {
        // Return an error message if token is null
        return 'Token not found';
      }
    } catch (e) {
      print('Logout error: $e');
      // Return an error message
      return 'Logout failed: $e';
    }
  }
}
