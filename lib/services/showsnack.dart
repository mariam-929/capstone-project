import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(BuildContext context, String? message) {
    final snackBar = SnackBar(
      content: Text(message!),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
// class Utils {
//   final messengerKey = GlobalKey<ScaffoldMessengerState>();

//   static showSnackBar(String? text) {
//     if (text == null) return;
//     final snackBar = SnackBar(
//       content: Text(text),
//       backgroundColor: Colors.red,
//     );
//     messengerKey.currentState!
//       ..removeCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }
// }
