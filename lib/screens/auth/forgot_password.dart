import 'package:flutter/material.dart';
import 'package:presensi_mobile_apps/controller/forgot_controller.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presensi_mobile_apps/screens/auth/login.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  ForgotController forgotController = Get.put(ForgotController());
  // var isLogin = false.obs;

  @override
  Widget build(BuildContext context) {
    double circleWidth = 788;
    double circleHeight = 788;
    double circleTop = -533;
    double circleLeft = -198;

    double circle2Width = 788;
    double circle2Height = 788;
    double circle2Top = 489;
    double circle2Left = -198;

    double rectangleWidth = 360;
    double rectangleHeight = 210;
    double rectangleTop = 407;
    double rectangleLeft =
        (MediaQuery.of(context).size.width - rectangleWidth) / 2;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF004B93),
          ),
          Positioned(
            top: circleTop,
            left: circleLeft,
            child: Container(
              width: circleWidth,
              height: circleHeight,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffD9D9D9),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 500),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 196,
                      height: 179,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 55,
            left: 15,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff004B93),
              ),
              width: 43,
              height: 43,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons
                      .arrowAltCircleLeft, // Use the Font Awesome icon
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 290,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Make a new password',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'to login to your account',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Positioned(
            top: circle2Top,
            left: circle2Left,
            child: Container(
              width: circle2Width,
              height: circle2Height,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffC9002B), // Change the color as needed
              ),
            ),
          ),
          Positioned(
            top: rectangleTop,
            left: rectangleLeft,
            child: Container(
              width: rectangleWidth,
              height: rectangleHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Email Field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5D5D65),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 45,
                          child: TextField(
                            controller: forgotController.emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffd9d9d9),
                              hintStyle:
                                  const TextStyle(color: Colors.blueGrey),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Password Field

                  const SizedBox(height: 20),

                  // LOGIN Button
                  SizedBox(
                    width: 320,
                    height: 47,
                    child: ElevatedButton(
                      onPressed: () async {
                        await forgotController.forgotpassword();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff004B93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'SEND EMAIL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
