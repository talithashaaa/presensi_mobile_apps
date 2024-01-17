import 'package:flutter/material.dart';
import 'package:presensi_mobile_apps/screens/home.dart';
import 'package:presensi_mobile_apps/screens/auth/login.dart';
import 'package:presensi_mobile_apps/screens/auth/signup.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    double circleWidth = 1093;
    double circleHeight = 1093;
    double circleTop = -580;
    double circleLeft = -613;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xffffffff),
          ),
          Positioned(
            top: circleTop,
            left: circleLeft,
            child: Container(
              width: circleWidth,
              height: circleHeight,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffD9D9D9), // Change the color as needed
              ),
            ),
          ),
          Positioned(
            top: 205,
            left: -132,
            child: Image.asset(
              'assets/images/logo.png',
              width: 441,
              height: 358,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 60),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Si',
                              style: TextStyle(
                                color: Color(0xff004B93),
                                fontFamily: 'PaytoneOne',
                              ),
                            ),
                            TextSpan(
                              text: 'KaWan',
                              style: TextStyle(
                                color: Color(0xffC9002B),
                                fontFamily: 'PaytoneOne',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 40, top: 140),
            child: Column(
              children: [
                Expanded(
                  child: Column(children: [
                    Text(
                      'Sistem Informasi Kehadiran Karyawan',
                      style: TextStyle(
                        fontFamily: 'PaytoneOne',
                        fontSize: 20,
                        color: Color(0xff004B93),
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 600),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Button color
                    onPrimary: Colors.black, // Text color
                    fixedSize: const Size(310, 47), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      color: Colors.black, // Border color
                      width: 1,
                    ),
                  ),
                  child: const Text('LOGIN'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Button color
                    onPrimary: Colors.black, // Text color
                    fixedSize: const Size(310, 47), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      color: Colors.black, // Border color
                      width: 1,
                    ),
                  ),
                  child: const Text('SIGN UP'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
