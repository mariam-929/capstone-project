import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth101/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../services/showsnack.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});
  static bool isEmailVerified = false;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  static bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => CheckEmailVerified(),
      );
    }
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future CheckEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => (isEmailVerified
      ? const HomeScreen()
      : Scaffold(
          appBar: AppBar(
            title: const Text("Verify Email"),
          ),
        ));
}
