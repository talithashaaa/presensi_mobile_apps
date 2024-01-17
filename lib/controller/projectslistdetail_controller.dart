import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/controller/projectslist_controller.dart';
import 'package:presensi_mobile_apps/model/projectslistdetail_model.dart';
import 'package:presensi_mobile_apps/services/projectslistdetail_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectsListDetailController extends GetxController {
  var isLoading = true.obs;
  var projectsListDetail = <ProjectListDetail>[].obs;

  @override
  void onInit() async {
    print('Initializing ProjectsListDetailController');
    // final String bearerToken = await getBearerToken();
    // final String project_id = Get.parameters['project_id'] ?? '';
    // final ProjectsListController projectsListController = Get.find();
    // final String project_id = projectsListController.projectsList.first.id;
    // fetchProjectListDetail(project_id);
    super.onInit();
  }

  void fetchProjectListDetail(String project_id) async {
    try {
      if (project_id == null) {
        print('Error: project_id is null');
        return;
      }
      isLoading(true);
      final String bearerToken = await getBearerToken();
      // final String projectId = Get.parameters['project_id'] ?? '';
      print('Fetching project detail with projectId: $project_id');
      // print('Fetching project detail with projectId: $project_id');
      var projectListDetailData =
          await ProjectListDetailServices.fetchProjectListDetail(
              bearerToken, project_id);
      if (projectListDetailData != null) {
        projectsListDetail.assignAll([projectListDetailData]);
      }
    } catch (e) {
      print('Error fetching project details CCONTROLLER: $e');
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
