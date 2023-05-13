import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth101/screens/signup_screen.dart";
import "package:firebase_auth101/services/showsnack.dart";
import "package:firebase_auth101/widgets/customized_textfield.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "login_screen.dart";
import "../widgets/customized_button.dart";

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Don't worry it happens. Please enter the email address linked to your account",
                style: TextStyle(
                  color: Color(0xff8391A1),
                  fontSize: 20,
                ),
              ),
            ),
            // CustomizedTextField(
            //   mycontroller: _emailController,
            //   hindtext: "Enter your email",
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
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: const Color(0xffE8ECF4),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            CustomizedButton(
              buttonText: "Reset Password",
              buttonColor: Colors.black,
              textColor: Colors.white,
              isEmail: true,
              onPressed: () {
                verifyEmail();
              },
            ),
            const SizedBox(
              height: 270,
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Remember Password?",
                    style: TextStyle(color: Color(0xff1E232C), fontSize: 15),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()));
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(color: Color(0xff35C2C1), fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ]),
        )),
      ),
    );
  }

  Future verifyEmail() async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(
    //           child: CircularProgressIndicator(),
    //         ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));

      //  _emailController.clear();
      Utils.showSnackBar(context, "Password Reset Email sent");
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(context, e.message);
      // Utils.showSnackBar(context, "Password Reset Email sent");
    }
  }
}
