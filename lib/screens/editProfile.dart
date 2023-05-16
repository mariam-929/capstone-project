import 'dart:io';
import 'package:firebase_auth101/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

        // Parse ISO 8601 string to DateTime object
        _dateOfBirth = DateTime.parse(data['dateOfBirth']);

        // Format DateTime object to "dd/MM/yyyy"
        _dateOfBirthController.text =
            DateFormat('dd/MM/yyyy').format(_dateOfBirth!);

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

    if (_dateOfBirth == null ||
        DateTime.now().difference(_dateOfBirth!).inDays ~/ 365 < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be at least 18 years old.'),
        ),
      );
      return;
    }

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
        'imageUrl': null,
      });

      setState(() {
        _imageFile = null;
      });
    }
  }

  void _showOptions(BuildContext context) {
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
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Remove Picture"),
                    onTap: () {
                      _deleteImage();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 0, 0),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: imageProvider,
                    child: _imageFile == null && user?.photoURL == null
                        ? Icon(Icons.camera_alt, size: 80)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Transform.translate(
                        offset: Offset(15, 15),
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showOptions(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: "Full Name",
              ),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: "Phone Number",
              ),
            ),
            TextField(
              controller: _dateOfBirthController,
              decoration: InputDecoration(
                labelText: "Date of Birth",
              ),
              onTap: () {
                _selectDate(context);
              },
            ),
            ElevatedButton(
              onPressed: _updateUserInfo,
              child: Text('Save Changes'),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
                child: Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}