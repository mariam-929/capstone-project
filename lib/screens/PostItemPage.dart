import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/customized_button.dart';

class PostItemPage extends StatefulWidget {
  @override
  _PostItemPageState createState() => _PostItemPageState();
}

class _PostItemPageState extends State<PostItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _category = "Category 1";
  String _postType = "Found";
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_sharp,
                            color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      // SizedBox(width: 2),
                      Text(
                        'Home',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Post Item",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: TextFormField(
                  //     controller: _fullNameController,
                  //     decoration: InputDecoration(labelText: 'Full Name'),
                  //     validator: (value) =>
                  //         value!.isEmpty ? 'Full Name is required' : null,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: false,
                      controller: _fullNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (name) {
                        if (name == "") {
                          // _emailController.clear();
                          // _passwordController.clear();
                          return "Please Enter full name";
                        } else {
                          return null;
                        }
                      },
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          fillColor: const Color(0xffE8ECF4),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      enableSuggestions: true,
                      autocorrect: true,
                      obscureText: false,
                      maxLength: 50,
                      controller: _titleController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (title) {
                        if (title == "") {
                          // _emailController.clear();
                          // _passwordController.clear();
                          return "Please Enter title of the item";
                        } else {
                          return null;
                        }
                      },
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          helperText:
                              "A title should be at least 50 characters",
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          fillColor: const Color(0xffE8ECF4),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      enableSuggestions: true,
                      autocorrect: true,
                      obscureText: false,
                      controller: _descriptionController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (description) {
                        if (description == "") {
                          // _emailController.clear();
                          // _passwordController.clear();
                          return "Please Enter description of the item";
                        } else {
                          return null;
                        }
                      },
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          helperText:
                              "Enter important discription such as color, feature, etc...",
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          fillColor: const Color(0xffE8ECF4),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      items: ['Category 1', 'Category 2', 'Category 3']
                          .map((category) => DropdownMenuItem(
                              child: Text(category), value: category))
                          .toList(),
                      onChanged: (value) => setState(() => _category = value!),
                      decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          //helperText:
                          // "A title should be at least 50 characters",
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          fillColor: const Color(0xffE8ECF4),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                      validator: (value) =>
                          value == null ? 'Category is required' : null,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButtonFormField<String>(
                      value: _postType,
                      items: ['Found', 'Lost']
                          .map((postType) => DropdownMenuItem(
                              child: Text(postType), value: postType))
                          .toList(),
                      onChanged: (value) => setState(() => _postType = value!),
                      validator: (value) =>
                          value == null ? 'Post Type is required' : null,
                      decoration: InputDecoration(
                          labelText: 'Post Type',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          // helperText:
                          //  "A title should be at least 50 characters",
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          fillColor: const Color(0xffE8ECF4),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                  ),

                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Images (up to 4)',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildImageGrid(),
                  SizedBox(height: 16),
                  Center(
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Post Item',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(MediaQuery.of(context).size.width, 60)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 255, 203,
                                  72)), // set the button's color here
                        ),
                      ),
                    ),
                    // child: CustomizedButton(
                    //   buttonText: "Post Item",
                    //   buttonColor: Color.fromARGB(255, 255, 203, 72),
                    //   textColor: Colors.white,
                    //   isEmail: false,
                    //   onPressed: () async {
                    //     _submitForm;
                    //   },
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _images.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index < _images.length) {
          return Stack(
            children: [
              Image.file(_images[index], fit: BoxFit.cover),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => _images.removeAt(index)),
                ),
              ),
            ],
          );
        } else if (_images.length < 4) {
          return GestureDetector(
            onTap: _pickImage,
            child: Container(
              color: Colors.grey[200],
              child: Icon(Icons.add_a_photo, color: Colors.black),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() => _images.add(File(pickedFile.path)));
  //   }
  // }
  // Future<void> _pickImage() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       setState(() => _images.add(File(pickedFile.path)));
  //     }
  //   } catch (e) {
  //     print('Error picking image: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error picking image: $e')),
  //     );
  //   }
  // }
  Future<void> _pickImage() async {
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Choose Image Source'),
          actions: <Widget>[
            TextButton(
              child: Text('Camera'),
              onPressed: () async {
                // await requestPermission();
                Navigator.of(context).pop();
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() => _images.add(File(pickedFile.path)));
                }
              },
            ),
            TextButton(
              child: Text('Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() => _images.add(File(pickedFile.path)));
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      final phoneNo = _phoneNoController.text.trim();
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final imageUrls = await _uploadImages();
      final collection = await FirebaseFirestore.instance.collection('Posts');
      // final userDocRef = collection.doc(userId);
      //final entrySubcollectionRef = userDocRef.collection('entries');
      final entryData = {
        "id": userId,
        'full_name': fullName,
        'phone_no': phoneNo,
        'category': _category,
        'title': title,
        'description': description,
        'post_type': _postType,
        'image_urls': imageUrls,
      };
      await collection.add(entryData);

      //  final collection = await FirebaseFirestore.instance.collection('Posts').doc(userId).set({
      //     'full_name': fullName,
      //     'phone_no': phoneNo,
      //     'category': _category,
      //     'title': title,
      //     'description': description,
      //     'post_type': _postType,
      //     'image_urls': imageUrls,
      //   });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Item Posted Successfully')));
      Navigator.pop(context);
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    for (int i = 0; i < _images.length; i++) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('post-images/')
          .child('${DateTime.now().millisecondsSinceEpoch}$i.jpg');
      final taskSnapshot = await ref.putFile(_images[i]);
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }
}
