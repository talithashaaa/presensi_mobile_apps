import 'package:flutter/material.dart';
import 'package:presensi_mobile_apps/landing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double vectorWidth = 357.88;
    // double vectorHeight = 414.37;
    // double vectorTop = -84;
    // double vectorLeft = 211;

    // double vector2Width = 2729;
    // double vector2Height = 2729;
    // double vector2Top = -2283;
    // double vector2Left = -1169;
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    });
    return Scaffold(
      backgroundColor: const Color(0xffd9d9d9),
      body: Stack(
        children: [
          Positioned(
            top: 422,
            left: -162.06,
            child: Image.asset(
              'assets/images/sb.png',
              width: 383.7,
              height: 457.16,
            ),
          ),
          Positioned(
            top: -84,
            left: 211,
            child: Image.asset(
              'assets/images/sa.png',
              width: 357.88,
              height: 414.37,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(height: 16),
                const Text(
                  'from',
                  style: TextStyle(
                    fontFamily: 'PaytoneOne',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Image.asset(
                  'assets/images/Group 414.png',
                  height: 36,
                  width: 107,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
