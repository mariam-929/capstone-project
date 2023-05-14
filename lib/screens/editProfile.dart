// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth101/screens/welcome_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfilePage extends StatefulWidget {
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _storage = FirebaseStorage.instance;

//   final _formKey = GlobalKey<FormState>();
//   final _picker = ImagePicker();

//   String _fullName = '';
//   String _phoneNumber = '';
//   String _profileImageUrl = '';

//   Future<Map<String, dynamic>?> _loadUserData() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final userData = await _firestore.collection('Users').doc(user.uid).get();
//       return userData.data();
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>?>(
//       future: _loadUserData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           final userData = snapshot.data;
//           _fullName = userData?['fullname'] ?? '';
//           _phoneNumber = userData?['phoneNumber'] ?? '';
//           _profileImageUrl = userData?['imageUrl'] ?? '';

//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Edit Profile'),
//             ),
//             body: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundColor:
//                             Colors.grey, // Choose your desired background color
//                         child: _profileImageUrl.isEmpty
//                             ? Icon(
//                                 Icons.person,
//                                 size: 60,
//                                 color: Colors
//                                     .white, // Choose your desired icon color
//                               )
//                             : null,
//                         backgroundImage: _profileImageUrl.isNotEmpty
//                             ? NetworkImage(_profileImageUrl)
//                             : null,
//                       ),
//                     ),
//                     TextFormField(
//                       initialValue: _fullName,
//                       decoration: InputDecoration(labelText: 'Full Name'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your full name';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {
//                         _fullName = value;
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _phoneNumber,
//                       decoration: InputDecoration(labelText: 'Phone Number'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your phone number';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {
//                         _phoneNumber = value;
//                       },
//                     ),
//                     ElevatedButton(
//                       onPressed: _updateProfile,
//                       child: Text('Update Profile'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         FirebaseAuth.instance.signOut();
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => WelcomeScreen()));
//                       },
//                       child: Text('Sign Out'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Future<String> _uploadImage(File image) async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final ref = _storage.ref().child('post-images/').child(user.uid + '.jpg');
//       await ref.putFile(image);
//       return await ref.getDownloadURL();
//     }
//     return '';
//   }
//   // Future<List<String>> _uploadImages() async {
//   //   List<String> imageUrls = [];
//   //   for (int i = 0; i < _images.length; i++) {
//   //     final ref = FirebaseStorage.instance
//   //         .ref()
//   //         .child('post-images/')
//   //         .child('${DateTime.now().millisecondsSinceEpoch}$i.jpg');
//   //     final taskSnapshot = await ref.putFile(_images[i]);
//   //     final imageUrl = await taskSnapshot.ref.getDownloadURL();
//   //     imageUrls.add(imageUrl);
//   //   }
//   //   return imageUrls;
//   // }

//   // Future<void> _showChoiceDialog() async {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: Text("Make a Choice"),
//   //         content: SingleChildScrollView(
//   //           child: ListBody(
//   //             children: <Widget>[
//   //               GestureDetector(
//   //                 child: Text("Gallery"),
//   //                 onTap: () {
//   //                   _openGallery();
//   //                 },
//   //               ),
//   //               Padding(padding: EdgeInsets.all(8.0)),
//   //               GestureDetector(
//   //                 child: Text("Camera"),
//   //                 onTap: () {
//   //                   _openCamera();
//   //                 },
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   Future<void> _pickImage() async {
//     try {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Choose Image Source'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Camera'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 final pickedFile =
//                     await _picker.pickImage(source: ImageSource.camera);
//                 if (pickedFile != null) {
//                   _profileImageUrl = await _uploadImage(File(pickedFile.path));
//                   setState(() {});
//                 }
//               },
//             ),
//             TextButton(
//               child: Text('Gallery'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 final pickedFile =
//                     await _picker.pickImage(source: ImageSource.gallery);
//                 if (pickedFile != null) {
//                   _profileImageUrl = await _uploadImage(File(pickedFile.path));
//                   setState(() {});
//                 }
//               },
//             ),
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print('Error picking image: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking image: $e')),
//       );
//     }
//   }

//   Future<void> _updateProfile() async {
//     if (_formKey.currentState!.validate()) {
//       final user = _auth.currentUser;
//       if (user != null) {
//         await _firestore.collection('Users').doc(user.uid).set({
//           'fullname': _fullName,
//           'phoneNumber': _phoneNumber,
//           'imageUrl': _profileImageUrl,
//         }, SetOptions(merge: true));

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile updated')),
//         );
//       }
//     }
//   }
// }
