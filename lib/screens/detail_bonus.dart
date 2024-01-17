import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/controller/projectslistdetail_controller.dart';
import 'package:presensi_mobile_apps/model/projectslistdetail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailBonusPage extends StatefulWidget {
  final String project_id;

  const DetailBonusPage({Key? key, required this.project_id}) : super(key: key);

  @override
  State<DetailBonusPage> createState() => _DetailBonusPageState();
}

class _DetailBonusPageState extends State<DetailBonusPage> {
  final ProjectsListDetailController projectdetailcontroller =
      Get.put(ProjectsListDetailController());
  String project_id = "";

  @override
  void initState() {
    super.initState();
    print('ID DARI BONUS: ${widget.project_id}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "Token not found";
      // checkGetProfile();
      final String uid = await getUid();

      projectdetailcontroller.fetchProjectListDetail(widget.project_id);
    });
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UID') ?? "Default UID";
  }

  @override
  Widget build(BuildContext context) {
    print('ID DARI BONUS: ${widget.project_id}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bonus Project',
          style: TextStyle(
            fontSize: 20.0, // Ukuran font
            fontWeight: FontWeight.bold,
            color: Colors.white, // Bobot font
            fontFamily: 'Inter', // Jenis font
          ),
        ),
        backgroundColor: const Color(0xFF004B93), // Warna latar belakang AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Obx(() {
          if (projectdetailcontroller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (projectdetailcontroller.projectsListDetail.isNotEmpty) {
              ProjectListDetail projectDetail =
                  projectdetailcontroller.projectsListDetail.first;
              // Lanjutkan dengan penggunaan projectDetail
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectDetail.projectName,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff004B93),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    projectDetail.id,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0x80004B93),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 20),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    color: Color(0xff004B93),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Deadline',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0x80004B93),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    projectDetail.deadline,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff004B93),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Nilai Project',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0x80004B93),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    projectDetail.value.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff004B93),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0x80004B93),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    projectDetail.description,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff004B93),
                      fontFamily: 'Inter',
                    ),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Assignee',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0x80004B93),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 5),
                  for (Assignee assignee in projectDetail.assignee)
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(assignee.profilePhoto),
                      ),
                      title: Text(
                        assignee.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff004B93),
                          fontFamily: 'Inter',
                        ),
                      ),
                      subtitle: Text(
                        assignee.position,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0x80004B93),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                ],
              );
            } else {
              // Tanggapi jika list kosong
              return const Text('Project details not available');
            }
          }
        }),
      ),
    );
  }
}
