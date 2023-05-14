import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth101/screens/ItemListing.dart';
import 'package:firebase_auth101/screens/PostItemPage.dart';
import 'package:firebase_auth101/screens/home_screen.dart';
import 'package:firebase_auth101/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../screens/lostFound.dart';

class HomeBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 80,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: Icon(
              Icons.home,
              color: Color.fromARGB(255, 155, 22, 175),
              size: 35,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostItemPage()));
            },
            child: Icon(
              Icons.add_box_rounded,
              color: Color.fromARGB(255, 155, 22, 175),
              size: 35,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ItemListing()));
            },
            child: Icon(
              Icons.shopping_cart,
              color: Color.fromARGB(255, 155, 22, 175),
              size: 35,
            ),
          ),
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()));
            },
            child: Icon(
              Icons.logout_outlined,
              color: Color.fromARGB(255, 155, 22, 175),
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
