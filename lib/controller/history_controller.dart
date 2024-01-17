import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/model/history_model.dart';
import 'package:presensi_mobile_apps/services/history_services.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryController extends GetxController {
  var isLoading = true.obs;
  var historyList = <History>[].obs;

  @override
  void onInit() async {
    print('Initializing HistoryController');
    await fetchHistory(); // Fetch history when the controller is initialized
    super.onInit();
  }

  Future<void> fetchHistory({bool showLoadingIndicator = true}) async {
    try {
      if (showLoadingIndicator) isLoading(true);

      final String bearerToken = await getBearerToken();
      print('Bearer Token used for fetching HISTORY: $bearerToken');
      var historyData = await HistoryServices.fetchHistory(bearerToken);
      if (historyData != null) {
        historyList.assignAll(historyData);
      } else {
        print(
            'Error during HISTORY fetch CONTROLLER: projectsListData is null');
      }
    } catch (e) {
      print('Error fetching history CONTROLLER: $e');
    } finally {
      if (showLoadingIndicator) isLoading(false);
    }
  }

  Future<String> getBearerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "Default Bearer Token";
    print('Original Bearer Token from SharedPreferences: $token');
    return token;
  }
}
