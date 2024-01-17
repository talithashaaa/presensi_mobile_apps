import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/controller/projectslist_controller.dart';
import 'package:presensi_mobile_apps/screens/detail_bonus.dart';
// import 'package:presensi_mobile_apps/controller/projectslist_controller.dart';
import 'package:presensi_mobile_apps/model/projectslist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BonusPage extends StatefulWidget {
  @override
  _BonusPageState createState() => _BonusPageState();
}

class _BonusPageState extends State<BonusPage> {
  final ProjectsListController projectsListController =
      Get.put(ProjectsListController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "Token not found";
      checkGetProjects();
      final String uid = await getUid();

      projectsListController.fetchProjectsList(token);
    });
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UID') ?? "Default UID";
  }

  Future<void> checkGetProjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String token = prefs.getString('token') ?? "Token not found";
    String UID = prefs.getString('UID') ?? "UID not found";

    print("IsLoggedIn: $isLoggedIn");
    print("Token during PROJECTSLIST: $token");
    print("UID during PROJECTSLIST: $UID");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bonus Project',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: const Color(0xFF004B93),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GetBuilder<ProjectsListController>(
        builder: (controller) {
          return controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : controller.projectsList.isEmpty
                  ? Center(
                      child: Text('Tidak ada proyek bonus'),
                    )
                  : ListView.builder(
                      itemCount: controller.projectsList.length,
                      itemBuilder: (context, index) {
                        return buildProjectItem(controller.projectsList[index]);
                      },
                    );
        },
      ),
    );
  }

  Widget buildProjectItem(ProjectsList project) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            projectsListController.onProjectTilePressed(project.id);
          },
          child: ListTile(
            title: Text(
              project.projectName ?? '',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff004B93),
                fontFamily: 'Inter',
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rp ${project.value ?? ''}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0x80004B93),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getStatusColor(project.status),
                      ),
                      child: Center(
                        child: Text(
                          getStatusInitial(project.status),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      getStatusText(project.status),
                      style: TextStyle(
                        color: getStatusColor(project.status),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xff004B93),
            ),
            onTap: () {
              _onItemClicked(project.id);
            },
          ),
        ),
        const Divider(
          height: 10,
          thickness: 1,
          color: Color(0xff004B93),
        ),
      ],
    );
  }

  Color getStatusColor(String status) {
    if (status == 'Done') {
      return Colors.green;
    } else if (status == 'Pending') {
      return Colors.orange;
    } else if (status == 'On Going') {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  String getStatusInitial(String status) {
    if (status == 'Done') {
      return 'D';
    } else if (status == 'Pending') {
      return 'p';
    } else if (status == 'On Going') {
      return 'O';
    } else {
      return 'N';
    }
  }

  String getStatusText(String status) {
    return status;
  }

  void _onItemClicked(String project_id) {
    print('ID DARI BONUS: $project_id');
    if (project_id.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBonusPage(project_id: project_id),
        ),
      );
    } else {
      print('Project ID is null or empty.');
    }
  }
}
