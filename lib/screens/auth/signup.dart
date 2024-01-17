import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presensi_mobile_apps/controller/signup_controller.dart';
import 'package:get/get.dart';
import 'package:presensi_mobile_apps/landing.dart';
import 'package:presensi_mobile_apps/screens/auth/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignUpController signUpController = Get.put(SignUpController());

  bool _obscureText = true;

  // final SignUpController _signUpController = SignUpController();
  // TextEditingController nameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController positionController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  // Future<void> signUp(
  //     String name, String email, String position, String password) async {
  //   final apiUrl = ApiConstants.signupEndpoint;

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       body: jsonEncode({
  //         'name': name,
  //         'email': email,
  //         'position': position,
  //         'password': password,
  //       }),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // Successful registration, handle the response as needed
  //       print('Registration successful');
  //       print(response.body);

  //       // Navigate to the home page or perform other actions
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginPage()),
  //       );
  //     } else {
  //       // Handle errors, e.g., display an error message to the user
  //       print('Error: ${response.statusCode}');
  //       print(response.body);
  //     }
  //   } catch (error) {
  //     // Handle network errors
  //     print('Error: $error');
  //   }
  // }

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
    double rectangleHeight = 590;
    double rectangleTop = 116;
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
                    MaterialPageRoute(builder: (context) => LandingPage()),
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
                                const SizedBox(height: 10),
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontFamily: 'PaytoneOne',
                                    color: Color(0xff004B93),
                                    fontSize: 35,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Nama Lengkap',
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
                                    controller: signUpController.nameController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffd9d9d9),
                                      hintStyle: const TextStyle(
                                          color: Colors.blueGrey),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                        signUpController.emailController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffd9d9d9),
                                      hintStyle: const TextStyle(
                                          color: Colors.blueGrey),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Position',
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
                                        signUpController.positionController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffd9d9d9),
                                      hintStyle: const TextStyle(
                                          color: Colors.blueGrey),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                        signUpController.passwordController,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffd9d9d9),
                                      hintStyle: const TextStyle(
                                          color: Colors.blueGrey),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
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
                                // const SizedBox(height: 20),
                                // const Text(
                                //   'Confirm Password',
                                //   style: TextStyle(
                                //     fontFamily: 'Inter',
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.bold,
                                //     color: Color(0xff5D5D65),
                                //   ),
                                // ),
                                // const SizedBox(height: 10),
                                // SizedBox(
                                //   height: 45,
                                //   child: TextField(
                                //     controller:
                                //         signUpController.passwordController,
                                //     obscureText: _obscureText,
                                //     decoration: InputDecoration(
                                //       filled: true,
                                //       fillColor: const Color(0xffd9d9d9),
                                //       hintStyle: const TextStyle(
                                //           color: Colors.blueGrey),
                                //       enabledBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(5),
                                //       ),
                                //       suffixIcon: IconButton(
                                //         onPressed: () {
                                //           setState(() {
                                //             _obscureText = !_obscureText;
                                //           });
                                //         },
                                //         icon: Icon(
                                //           _obscureText
                                //               ? Icons.visibility
                                //               : Icons.visibility_off,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // LOGIN Button
                          SizedBox(
                            width: 320,
                            height: 47,
                            child: ElevatedButton(
                              onPressed: () async {
                                await signUpController.signup();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff004B93),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'SIGN UP',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
