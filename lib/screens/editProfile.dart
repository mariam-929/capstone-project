import 'dart:io';
import 'package:firebase_auth101/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../widgets/HomeBottomBar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final picker = ImagePicker();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _readUserInfo();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _readUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _fullNameController.text = data['fullname'];
        _phoneNumberController.text = data['phoneNumber'];

        // Check if 'dateOfBirth' is not null before parsing
        if (data['dateOfBirth'] != null) {
          // Parse ISO 8601 string to DateTime object
          _dateOfBirth = DateTime.parse(data['dateOfBirth']);

          // Format DateTime object to "dd/MM/yyyy"
          _dateOfBirthController.text =
              DateFormat('dd/MM/yyyy').format(_dateOfBirth!);
        } else {
          // Handle the case when 'dateOfBirth' is null
          _dateOfBirth = null; // or set a default value
        }

        // Set user photoURL to local state if it exists in Firestore
        if (data['imageUrl'] != null) {
          // ignore: deprecated_member_use
          user.updateProfile(photoURL: data['imageUrl']);
        }
      }
    }
  }

  Future<void> _updateUserInfo() async {
    if (_fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Full name cannot be empty.'),
        ),
      );
      return;
    }

    if (_phoneNumberController.text.isEmpty ||
        !RegExp(r'^\+961[0-9]{8}$').hasMatch(_phoneNumberController.text)) {
      // +961 followed by 8 digits
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Phone number must start with +961 and followed by 8 digits.'),
        ),
      );
      return;
    }

    // if (_dateOfBirth == null ||
    //     DateTime.now().difference(_dateOfBirth!).inDays ~/ 365 < 18) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('You must be at least 18 years old.'),
    //     ),
    //   );
    //   return;
    // }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'fullname': _fullNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'dateOfBirth': _dateOfBirth?.toIso8601String(),
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });

    _uploadImage();
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_pics')
        .child('${user!.uid}.jpg');

    await ref.putFile(_imageFile!);

    final imageUrl = await ref.getDownloadURL();
    // Update photoURL in Firebase Auth user profile
    await user.updateProfile(photoURL: imageUrl);

    // Update photoURL in Firestore database
    await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
      'imageUrl': imageUrl,
    });

    setState(() {});
  }

  void _deleteImage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user?.photoURL != null) {
      Reference photoRef = FirebaseStorage.instance.refFromURL(user!.photoURL!);

      // Deletes the file from Firebase Storage
      await photoRef.delete();

      // Update photoURL in Firebase Auth user profile
      await user.updateProfile(photoURL: null);

      // Update photoURL in Firestore database
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'imageUrl':
            'https://cdn.discordapp.com/attachments/843669076051755111/1107995852691230800/avatar.jpg',
      });

      setState(() {
        _imageFile = null;
      });
    }
  }

  void _showOptions(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Pick From Gallery"),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Take A Picture"),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                if (user!.photoURL !=
                    'https://cdn.discordapp.com/attachments/843669076051755111/1107995852691230800/avatar.jpg')
                  Padding(padding: EdgeInsets.all(8.0)),
                if (user.photoURL !=
                    'https://cdn.discordapp.com/attachments/843669076051755111/1107995852691230800/avatar.jpg')
                  GestureDetector(
                    child: Text("Remove Picture"),
                    onTap: () {
                      _deleteImage();
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dateOfBirth ?? DateTime.now(),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _dateOfBirth)
      setState(() {
        _dateOfBirth = picked;
        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    ImageProvider? imageProvider;

    if (_imageFile != null) {
      imageProvider = FileImage(_imageFile!);
    } else if (user?.photoURL != null) {
      imageProvider = CachedNetworkImageProvider(user!.photoURL!);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Stack(
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 130,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 2,
                                                        blurRadius: 10,
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        offset: Offset(0, 10))
                                                  ],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                    height: 129,
                                                    width: 129,
                                                    child: Stack(children: [
                                                      CircleAvatar(
                                                        radius: 100,
                                                        backgroundImage:
                                                            imageProvider,
                                                      ),
                                                      Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 49,
                                                            width: 48,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                width: 4,
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                              ),
                                                              color: purple,
                                                            ),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                _showOptions(
                                                                    context);
                                                              },
                                                              icon: Icon(
                                                                  Icons.edit),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )),
                                                    ])),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, left: 12, right: 12),
                        child: TextField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: "Full Name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, left: 12, right: 12),
                        child: TextField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: "Phone Number",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, left: 12, right: 12),
                        child: TextField(
                          controller: _dateOfBirthController,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: "Date of Birth",
                          ),
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GFButton(
                            text: "Save",
                            shape: GFButtonShape.pills,
                            onPressed: _updateUserInfo,
                            color: purple,
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            elevation: 2,
                            size: GFSize.LARGE,
                          ),
                          GFButton(
                            color: purple,
                            text: "Sign out",
                            size: GFSize.LARGE,
                            shape: GFButtonShape.pills,
                            type: GFButtonType.outline2x,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // Add a bit of space at the bottom
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
