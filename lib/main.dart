import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile_apps/firebase_options.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_mobile_apps/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedToken = prefs.getString('token');

  runApp(MyApp(isLoggedIn: storedToken != null));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        // Remove or adjust the experimental feature based on your Flutter version
        // useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
