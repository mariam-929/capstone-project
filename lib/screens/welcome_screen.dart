import "package:firebase_auth101/screens/login_screen.dart";
import "package:firebase_auth101/screens/signup_screen.dart";
import "package:firebase_auth101/widgets/customized_button.dart";
import "package:flutter/material.dart";
import "package:get/get_connect/http/src/utils/utils.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/logo.png")),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 110,
                  width: 155,
                  // child: Image(
                  //     image: AssetImage("assets/shopify.jpg"),
                  //     fit: BoxFit.cover),
                ),
                const SizedBox(height: 15),
                CustomizedButton(
                  buttonText: "Login",
                  buttonColor: Color.fromARGB(255, 255, 203, 72),
                  textColor: Colors.white,
                  isEmail: false,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                ),
                CustomizedButton(
                  buttonText: "Signup",
                  buttonColor: Color.fromARGB(255, 255, 203, 72),
                  textColor: Colors.white,
                  isEmail: false,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen()));
                  },
                ),
                const SizedBox(height: 30),
              ],
            )),
      )),
    );
  }
}
