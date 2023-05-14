import 'dart:io';
import 'package:firebase_auth101/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final picker = ImagePicker();

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
    // ignore: deprecated_member_use
    await user.updateProfile(photoURL: imageUrl);
    setState(() {});
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
                  )
                ],
              ),
            ),
          );
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: imageProvider,
                  child: _imageFile == null && user?.photoURL == null
                      ? Icon(Icons.camera_alt, size: 80)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showOptions(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
                height:
                    20), // Add space between the profile picture and the button
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
