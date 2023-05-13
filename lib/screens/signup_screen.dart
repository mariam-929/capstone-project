import "package:cloud_firestore/cloud_firestore.dart";
import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth101/constraints/password_constraints.dart";
import "package:firebase_auth101/database.dart";
import "package:firebase_auth101/screens/verify_email_page.dart";
import "package:firebase_auth101/services/firebase_auth_services.dart";
import "package:firebase_auth101/services/signup_controller.dart";
import "package:firebase_auth101/user_model.dart";
import "package:firebase_auth101/widgets/customized_textfield.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "../database.dart";
import "../main.dart";
import "../services/showsnack.dart";
import "../widgets/customized_button.dart";
import "home_screen.dart";
import "login_screen.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _firstnameController =
      TextEditingController();
  static final TextEditingController _lastnameController =
      TextEditingController();

  static final TextEditingController _passwordController =
      TextEditingController();
  static final TextEditingController _phoneController = TextEditingController();

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
              "Hello! Register to get \nstarted",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              enableSuggestions: true,
              autocorrect: true,
              obscureText: false,
              controller: SignUpScreen._firstnameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (firstname) {
                if (firstname == "") {
                  // _emailController.clear();
                  // _passwordController.clear();
                  return "Enter a first name";
                } else {
                  return null;
                }
              },
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  labelText: "First Name",
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
                  //hintText: "First Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              enableSuggestions: true,
              autocorrect: true,
              obscureText: false,
              controller: SignUpScreen._lastnameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (lastname) {
                if (lastname == "") {
                  // _emailController.clear();
                  // _passwordController.clear();
                  return "Enter your last name";
                } else {
                  return null;
                }
              },
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  labelText: "Last Name",
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
                  //hintText: "Last Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: true,
              autocorrect: true,
              obscureText: false,
              controller: SignUpScreen._emailController,
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
                  //hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          // CustomizedTextField(
          //   mycontroller: _passwordController,
          //   hindtext: "password",
          //   isPassword: true,
          // ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: _isObscure,
              controller: SignUpScreen._passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                // if (value!.isEmpty ||
                //     !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                //         .hasMatch(value)|| value.length<6) {
                //   return "Invalid! password should have:\n at least 8 characters\n at least 1 lower case\nat least 1 upper case\nat least 1 Special Character\nat least 1 number";
                // }
                if (value!.isEmpty || value.length < 6) {
                  return "Should have at least 6 characters";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
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
                  //hintText: "password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),

          // const Align(
          //   alignment: Alignment.centerRight,
          //   child: Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: Text(
          //       "Forgot password?",
          //       style: TextStyle(color: Color(0xff6A707C), fontSize: 15),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          CustomizedButton(
            buttonText: "Sign Up",
            buttonColor: Color.fromARGB(255, 255, 203, 72),
            isEmail: false,
            textColor: Colors.white,
            onPressed: () async {
              FormState? form = formKey.currentState;
              if (form!.validate()) {
                try {
                  await FirebaseAuthServices().signup(
                      SignUpScreen._emailController.text.trim(),
                      SignUpScreen._passwordController.text.trim());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerifyEmailPage()));

                  final list = await FirebaseAuth.instance
                      .fetchSignInMethodsForEmail(
                          SignUpScreen._emailController.text);
                  // ignore: unrelated_type_equality_checks
                  if (list.isNotEmpty) {
                    CreateUser(name: SignUpScreen._emailController.text);
                  }
                  SignUpScreen._emailController.clear();
                  SignUpScreen._passwordController.clear();
                  SignUpScreen._phoneController.clear();
                  SignUpScreen._firstnameController.clear();
                  SignUpScreen._lastnameController.clear();

                  // navigatorKey.currentState!.popUntil((route) => route.isFirst);
                } on FirebaseException catch (e) {
                  print(e.message);
                  Utils.showSnackBar(context, e.message);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const SignUpScreen()));
                }
              }
              //navigatorKey.currentState!.popUntil((route) => route.isFirst);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (_) => const LoginScreen()));
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
          //           "Or register with",
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
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
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
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: const Text(
                    " Sign in",
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

  Future CreateUser({required String name}) async {
    final users = FirebaseAuth.instance.currentUser;
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(users?.uid);
    final user = UserModel(
        email: SignUpScreen._emailController.text,
        firstname: SignUpScreen._firstnameController.text,
        lastname: SignUpScreen._lastnameController.text,
        // password: SignUpScreen._passwordController.text,
        // phoneNo: SignUpScreen._phoneController.text,
        id: docUser.id);
    final json = user.TOjSON();
    await docUser.set(json);
  }
}
