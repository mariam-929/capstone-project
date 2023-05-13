import "dart:math";

import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth101/screens/forgot_password.dart";
import "package:firebase_auth101/screens/home_screen.dart";
import "package:firebase_auth101/screens/signup_screen.dart";
import "package:firebase_auth101/screens/verify_email_page.dart";
import "package:firebase_auth101/widgets/customized_textfield.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:get/get.dart";
import "package:google_sign_in/google_sign_in.dart";

import "../main.dart";
import "../services/firebase_auth_services.dart";
import "../services/showsnack.dart";
import "../widgets/customized_button.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  // Future<void> signInWithGoogle() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   final GoogleSignIn googleSignIn = GoogleSignIn();

  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;

  //   final AuthCredential myCredential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   final UserCredential userCredential =
  //       await auth.signInWithCredential(myCredential);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 50,
              width: 50,
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.black, width: 1),
              //     borderRadius: BorderRadius.circular(10)),
              // child: IconButton(
              //   icon: const Icon(Icons.arrow_back_ios_sharp),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Welcome back! Glad \nto see you, Again!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // CustomizedTextField(
          //   mycontroller: _emailController,
          //   hindtext: "Enter your Email",
          //   isPassword: false,
          // ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: true,
              autocorrect: true,
              obscureText: false,
              controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) {
                if (email != null && !EmailValidator.validate(email)) {
                  // _emailController.clear();
                  // _passwordController.clear();
                  return "Enter a valid Email";
                } else {
                  return null;
                }
              },
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: const Color(0xffE8ECF4),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  // hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          // CustomizedTextField(
          //   mycontroller: _passwordController,
          //   hindtext: "Enter your Password",
          //   isPassword: true,
          // ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: _isObscure,
              controller: _passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  //_emailController.clear();
                  //_passwordController.clear();
                  return "Please enter your password";
                }
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: const Color(0xffE8ECF4),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  //hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen()));
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                      color: Color.fromARGB(255, 145, 82, 157), fontSize: 15),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomizedButton(
            buttonText: "Login",
            buttonColor: Color.fromARGB(255, 255, 203, 72),
            textColor: Colors.white,
            isEmail: false,
            onPressed: () async {
              FormState? form = formKey.currentState;
              if (form!.validate()) {
                try {
                  await FirebaseAuthServices().login(
                      _emailController.text.trim(),
                      _passwordController.text.trim());
                  // navigatorKey.currentState!.popUntil((route) => route.isFirst);
                  if (FirebaseAuth.instance.currentUser != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyEmailPage()));
                  }
                  _emailController.clear();
                  _passwordController.clear();
                } on FirebaseException catch (e) {
                  print(e.message);
                  Utils.showSnackBar(context, e.message);
                }
                // navigatorKey.currentState!.popUntil((route) => route.isFirst);

                // Navigator.push(context,
                //     MaterialPageRoute(builder: (_) => const LoginScreen()));
              }
            },
          ),
          const SizedBox(
            height: 50,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
          //   child: Row(
          //     children: const [
          //       Expanded(
          //           child: Divider(
          //         thickness: 0.5,
          //         color: Colors.grey,
          //       )),
          //       Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 10.0),
          //         child: Text(
          //           "Or login with",
          //           style: TextStyle(color: Colors.black),
          //         ),
          //       ),
          //       Expanded(
          //           child: Divider(
          //         thickness: 0.5,
          //         color: Colors.grey,
          //       )),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Container(
          //         height: 50,
          //         width: 100,
          //         decoration: BoxDecoration(
          //             border: Border.all(color: Colors.black, width: 0.2),
          //             borderRadius: BorderRadius.circular(10)),
          //         child: IconButton(
          //           icon: const Icon(
          //             FontAwesomeIcons.facebookF,
          //             color: Colors.blue,
          //             size: 30,
          //           ),
          //           onPressed: () {},
          //         ),
          //       ),
          //       Container(
          //         height: 50,
          //         width: 100,
          //         decoration: BoxDecoration(
          //             border: Border.all(color: Colors.black, width: 0.2),
          //             borderRadius: BorderRadius.circular(10)),
          //         child: IconButton(
          //           icon: const Icon(
          //             FontAwesomeIcons.google,
          //             size: 30,
          //           ),
          //           onPressed: () async {
          //             try {
          //               FirebaseAuthServices().logininwithgoogle();
          //               //signInWithGoogle();
          //               if (FirebaseAuth.instance.currentUser != null) {
          //                 if (!mounted) return;

          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => const HomeScreen()));
          //               } else {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => const LoginScreen()));
          //               }
          //             } on FirebaseException catch (e) {
          //               debugPrint("error is ${e.message}");

          //               showDialog(
          //                   context: context,
          //                   builder: (context) => AlertDialog(
          //                           title: const Text(
          //                               " Invalid Username or password. Please register again or make sure that username and password is correct"),
          //                           actions: [
          //                             ElevatedButton(
          //                               child: const Text("Register Now"),
          //                               onPressed: () {
          //                                 Navigator.push(
          //                                     context,
          //                                     MaterialPageRoute(
          //                                         builder: (context) =>
          //                                             const SignUpScreen()));
          //                               },
          //                             )
          //                           ]));
          //             }

          //             // if (mounted) {
          //             //   Navigator.push(
          //             //       context,
          //             //       MaterialPageRoute(
          //             //           builder: (context) => const HomeScreen()));
          //             // }

          //             //await FirebaseAuthServices().logininwithgoogle();
          //           },
          //         ),
          //       ),
          //       Container(
          //         height: 50,
          //         width: 100,
          //         decoration: BoxDecoration(
          //             border: Border.all(color: Colors.black, width: 0.2),
          //             borderRadius: BorderRadius.circular(10)),
          //         child: IconButton(
          //           icon: const Icon(
          //             FontAwesomeIcons.apple,
          //             size: 30,
          //           ),
          //           onPressed: () {},
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 45,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen()));
                  },
                  child: const Text(
                    " Sign up",
                    style: TextStyle(
                        color: Color.fromARGB(255, 145, 82, 157), fontSize: 15),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    )));
  }
}
