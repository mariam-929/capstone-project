import 'package:firebase_auth101/screens/login_screen.dart';
import 'package:firebase_auth101/screens/signup_screen.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) =>
      isLogin ? LoginScreen() : SignUpScreen();
}
 // Row(
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         setState(() {
                //           _haspressed = !_haspressed;
                //           _islost = !_islost;
                //           _isfound = false;
                //         });
                //       },
                //       child: Container(
                //         height: 30,
                //         width: 70,
                //         decoration: BoxDecoration(
                //             color: _haspressed && _islost
                //                 ? Colors.purple[200]
                //                 : Colors.yellow[400],
                //             borderRadius: BorderRadius.circular(5)),
                //         child: const Align(
                //           alignment: Alignment.center,
                //           child: Text(
                //             "Lost",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     InkWell(
                //       onTap: () {
                //         setState(() {
                //           _haspressed = !_haspressed;
                //           _isfound = !_isfound;
                //           _islost = false;
                //         });
                //       },
                //       child: Container(
                //         height: 30,
                //         width: 70,
                //         decoration: BoxDecoration(
                //             color: _haspressed && _isfound
                //                 ? Colors.purple[200]
                //                 : Colors.yellow[400],
                //             borderRadius: BorderRadius.circular(5)),
                //         child: const Align(
                //           alignment: Alignment.center,
                //           child: Text(
                //             "Found",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // )