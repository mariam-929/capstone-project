// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth101/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class UserRepository extends GetxController {
//   static UserRepository get instance => Get.find();
//   final _db = FirebaseFirestore.instance;
//   Future<void> createUser(UserModel user) async {
//     _db
//         .collection("Users")
//         .add(user.TOjSON())
//         .whenComplete(
//           () => Get.snackbar("Success", "Your account has been created.",
//               snackPosition: SnackPosition.BOTTOM,
//               backgroundColor: Colors.green.withOpacity(0.1),
//               colorText: Colors.green),
//         )
//         .catchError((error, stackTrace) {
//       Get.snackbar("Error", "Something wnet wrong. Try again",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green.withOpacity(0.1),
//           colorText: Colors.red);
//       print("ERROR -$error");
//     });
//   }
// }
