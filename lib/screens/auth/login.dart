import 'package:flutter/material.dart';
import 'package:presensi_mobile_apps/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:presensi_mobile_apps/screens/home.dart';
import 'package:presensi_mobile_apps/screens/auth/forgot_password.dart';
import 'package:presensi_mobile_apps/landing.dart';
import 'package:presensi_mobile_apps/screens/auth/signup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = Get.put(LoginController());
  var isLogin = false.obs;

  bool _obscureText = true;

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
    double rectangleHeight = 437;
    double rectangleTop = 407;
    double rectangleLeft =
        (MediaQuery.of(context).size.width - rectangleWidth) / 2;

    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside the text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    FontAwesomeIcons.arrowAltCircleLeft,
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
                      'Welcome',
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
                      'Login to your account',
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
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height, // Set height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: rectangleWidth,
                        height: rectangleHeight,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
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
                                children: [
                                  const SizedBox(height: 40),
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
                                      controller:
                                          loginController.emailController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xffd9d9d9),
                                        hintStyle: const TextStyle(
                                            color: Colors.blueGrey),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Password Field
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password',
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
                                      controller:
                                          loginController.passwordController,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xffd9d9d9),
                                        hintStyle: const TextStyle(
                                            color: Colors.blueGrey),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          icon: Icon(
                                            _obscureText
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      // Checkbox(
                                      //   value: false,
                                      //   onChanged: (value) {},
                                      // ),
                                      // const Text(
                                      //   'Remember me?',
                                      //   style: TextStyle(
                                      //     fontFamily: 'Inter',
                                      //     fontSize: 14,
                                      //     color: Color(0xff5D5D65),
                                      //   ),
                                      // ),
                                      // const SizedBox(width: 190),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPage()),
                                          );
                                        },
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            color: Color(0xff5D5D65),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // LOGIN Button
                            SizedBox(
                              width: 320,
                              height: 47,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await loginController.login();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RealtimeClock()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff004B93),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Color(0xff5D5D65),
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Dont have account? ',
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff5D5D65),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpPage()),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
