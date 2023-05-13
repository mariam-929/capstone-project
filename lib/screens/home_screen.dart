import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth101/screens/PostItemPage.dart";
import "package:firebase_auth101/screens/addItem.dart";
import "package:firebase_auth101/screens/signup_screen.dart";
import "package:firebase_auth101/screens/welcome_screen.dart";
import "package:flutter/material.dart";
import 'package:getwidget/getwidget.dart';
import "package:google_sign_in/google_sign_in.dart";

import "../widgets/HomeBottomBar.dart";
import "chatbot.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final String email = user.email!;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      // ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Signed In as $email",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            // Text(
            //   user!.email!,
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),

            SizedBox(
              height: 40,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.arrow_back, size: 32),
                label: Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatScreen()));
                }),
            // ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       minimumSize: Size.fromHeight(50),
            //     ),
            //     icon: Icon(Icons.arrow_back, size: 32),
            //     label: Text(
            //       "Add Item",
            //       style: TextStyle(fontSize: 24),
            //     ),
            //     onPressed: () {
            //       FirebaseAuth.instance.signOut();
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => PostItemPage()));
            //     })
          ],
        ),
      ),

      bottomNavigationBar: HomeBottomBar(),
    );
  }
}
