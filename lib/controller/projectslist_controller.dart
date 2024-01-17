import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/model/projectslist_model.dart';
import 'package:presensi_mobile_apps/services/projectslist_services.dart';
import 'package:presensi_mobile_apps/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectsListController extends GetxController {
  var isLoading = true.obs;
  var projectsList = <ProjectsList>[].obs;
  var selectedProjectId = ''.obs;

  @override
  void onInit() async {
    print('Initializing ProjectsListController');

    final String bearerToken = await getBearerToken();
    // print('Bearer Token before fetching projects list: $bearerToken');
    fetchProjectsList(bearerToken);
    super.onInit();
  }

  void setSelectedProjectId(String projectId) {
    selectedProjectId.value = projectId;
  }

  void onProjectTilePressed(String projectId) {
    setSelectedProjectId(projectId);
    // Lakukan tindakan tambahan jika diperlukan
  }

  void fetchProjectsList(String bearerToken) async {
    try {
      isLoading(true);
      final String bearerToken = await getBearerToken();
      // print('Bearer Token used for fetching projects list: $bearerToken');
      var projectsListData =
          await ProjectsListServices.fetchProjectsList(bearerToken);

      if (projectsListData != null) {
        projectsList.assignAll(projectsListData);
      } else {
        print(
            'Error during projects list fetch CONTROLLER: projectsListData is null');
        // Handle this appropriately, e.g., show an error message
      }
    } catch (e) {
      print('Error fetching projects list CONTROLLER: $e');
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
