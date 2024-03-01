import 'package:flutter/material.dart';
// import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presensi_mobile_apps/controller/history_controller.dart';
import 'package:presensi_mobile_apps/maps_exit.dart';
import 'package:presensi_mobile_apps/screens/header_drawer.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/model/history_model.dart';
import 'package:presensi_mobile_apps/screens/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile_apps/screens/bonus.dart';
import 'package:presensi_mobile_apps/landing.dart';
import 'package:presensi_mobile_apps/maps.dart';
import 'package:presensi_mobile_apps/controller/login_controller.dart';

Future<void> main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: RealtimeClock(),
    );
  }
}

class RealtimeClock extends StatefulWidget {
  RealtimeClock({super.key});

  @override
  State<RealtimeClock> createState() => _RealtimeClockState();
}

class _RealtimeClockState extends State<RealtimeClock> {
  LoginController loginController = Get.put(LoginController());
  final HistoryController historyController = Get.put(HistoryController());

  GlobalKey<ScaffoldState> _scaffoldKEy = GlobalKey<ScaffoldState>();
  String realtimeClock = '00:00:00';
  String realtimeDate = 'Hari, Tanggal Bulan Tahun';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          realtimeClock = parseTime(
            rawDateTime: DateTime.now(),
          );
          realtimeDate = parseDate(
            rawDateTime: DateTime.now(),
          );
        });
      }
    });
    // Move the checkLoginStatus call here
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "Token not found";
      checkGetHistory();

      await checkLoginStatus();
      final String uid = await getUid();

      // historyController.fetchHistory(uid);

      historyController.fetchHistory();

      Future.delayed(Duration(seconds: 1), () {
        historyController.historyList.forEach((history) {
          history.historyList.sort((a, b) => DateFormat('dd MMMM yyyy')
              .parse(b.dayDate.split(', ')[1])
              .compareTo(
                  DateFormat('dd MMMM yyyy').parse(a.dayDate.split(', ')[1])));
        });
      });
    });
  }

  Future<void> _handleReload() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "Token not found";
      String UID = prefs.getString('UID') ?? "UID not found";

      // Use the fetchHistory method with the callback to update the UI after fetching
      await historyController.fetchHistory(showLoadingIndicator: true);

      // Sort historyList based on date in descending order
      if (mounted && historyController.historyList.isNotEmpty) {
        historyController.historyList.forEach((history) {
          history.historyList.sort((a, b) => DateFormat('dd MMMM yyyy')
              .parse(b.dayDate.split(', ')[1])
              .compareTo(
                  DateFormat('dd MMMM yyyy').parse(a.dayDate.split(', ')[1])));
        });
      }
    } catch (error) {
      print('Error during reload: $error');
    }
  }

  String parseTime({required DateTime rawDateTime}) {
    String hour = rawDateTime.hour.toString().padLeft(2, '0');
    String minute = rawDateTime.minute.toString().padLeft(2, '0');
    String second = rawDateTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String parseDate({required DateTime rawDateTime}) {
    String locale = "id_ID";
    // print("Raw DateTime: $rawDateTime");

    return DateFormat("EEE, dd MMMM yyyy", locale).format(rawDateTime);
  }

  // late Timer _timer;

  Future<void> _handleLogout() async {
    try {
      final result = await loginController.logout();

      if (result.startsWith('Logout failed')) {
        print('Logout failed: $result');
      } else {
        print('Logout successful: $result');

        await clearUserData();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      }
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "Token not found";
    String UID = prefs.getString('UID') ?? "UID not found";
    print("Token before removal: $token");
    print("Token before removal: $UID");

    prefs.remove('isLoggedIn');
    await prefs.remove('token');
    await prefs.remove('UID');
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UID') ?? "Default UID";
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String token = prefs.getString('token') ?? "Token not found";
    String UID = prefs.getString('UID') ?? "UID not found";

    print("IsLoggedIn: $isLoggedIn");
    print("Token during checkLoginStatus: $token");
    print("UID during checkLoginStatus: $UID");

    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future<void> checkGetHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String token = prefs.getString('token') ?? "Token not found";
    String UID = prefs.getString('UID') ?? "UID not found";

    print("IsLoggedIn: $isLoggedIn");
    print("Token during HISTORY: $token");
    print("UID during HISTORY: $UID");
    // historyController.fetchHistory(token);

    // Sort historyList based on date in descending order
  }

  @override
  void dispose() {
    // _timer.cancel(); // Batalkan timer saat widget di-"dispose"
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var historyController = Get.find<HistoryController>();
    double circleWidth = 1288;
    double circleHeight = 1288;
    double circleTop = -1033;
    double circleLeft = -748;

    double circle2Width = 2729;
    double circle2Height = 2729;
    double circle2Top = -2283;
    double circle2Left = -1169;

    double rectangleWidth = 360;
    double rectangleHeight = 380;
    //322
    double rectangleTop = 70;
    double rectangleLeft =
        (MediaQuery.of(context).size.width - rectangleWidth) / 2;

    double drawerTop = 23;

    double rectangle2Width = 360;
    double rectangle2Top = 460; //400
    // double rectangle2Height = 322;
    double rectangle2Height =
        MediaQuery.of(context).size.height - rectangle2Top;

    double rectangle2Left =
        (MediaQuery.of(context).size.width - rectangle2Width) / 2;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      key: _scaffoldKEy,
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF004B93), // Set the background color
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyHeaderDrawer(isLoggedIn: true),
                ListTile(
                  leading: const Icon(Icons.wallet_giftcard,
                      color: Colors.white), // Set icon color
                  title: Text(
                    'Bonus Project',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold), // Set text color
                  ),
                  onTap: () {
                    // Navigasi ke halaman bonus.dart
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BonusPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout,
                      color: Colors.white), // Set icon color
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold), // Set text color
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Logout?",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Divider(
                                height: 5,
                                thickness: 1,
                                color: Color(0xff004B93),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Profil anda akan disimpan. Kami akan menunggu Anda kembali ke SiKaWan!',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                ),
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff004B93),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                await _handleLogout();
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LandingPage(),
                                  ),
                                );
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff004B93),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                'No',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          Container(
            color: const Color(0xFFd9d9d9),
          ),
          Positioned(
            top: circle2Top,
            left: circle2Left,
            child: Container(
              width: circle2Width,
              height: circle2Height,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffC9002B),
              ),
            ),
          ),
          Positioned(
            top: circleTop,
            left: circleLeft,
            child: Container(
              width: circleWidth,
              height: circleHeight,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff004B93),
              ),
            ),
          ),
          Positioned(
            top: drawerTop,
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKEy.currentState!.openDrawer(),
            ),
          ),
          Positioned(
            top: rectangleTop,
            left: rectangleLeft,
            child: Container(
              width: rectangleWidth,
              height: rectangleHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          realtimeClock,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xff004B93),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          realtimeDate,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xff5D5D65),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30), // Jarak antara teks dan garis
                        Divider(
                          height: 3,
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Jam Kerja',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xff5D5D65),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          '10:00 AM - 06:00 PM',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // LOGIN Button
                  SizedBox(
                    width: 320,
                    height: 47,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MapsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff004B93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Absensi Masuk',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // LOGIN Button
                  SizedBox(
                    width: 320,
                    height: 47,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapsPageExit()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffC9002B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Absensi Keluar',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: rectangle2Top,
            left: rectangle2Left,
            child: Container(
              width: rectangle2Width,
              height: rectangle2Height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons
                                  .userClock, // Ganti dengan ikon yang diinginkan
                              color: Colors.black,
                              size: 16,
                            ),
                            SizedBox(width: 10), // Jarak antara ikon dan teks
                            Text(
                              'Riwayat Kehadiran',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: isLoading ? null : () => _handleReload(),
                              child: Icon(
                                Icons.refresh,
                                color:
                                    isLoading ? Colors.grey : Color(0xff004B93),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text('Tanggal'),
                          ),
                          DataColumn(
                            label: Text('Status'),
                          ),
                        ],
                        rows: historyController.historyList
                            .expand((history) => history.historyList)
                            .map((historyList) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  // height: 10,
                                  // alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          historyList.dayDate,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${historyList.entryTime} - ${historyList.exitTime}',
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    historyList.status,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
