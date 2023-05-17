import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/customized_button.dart';
import 'location_search_screen.dart';

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
  late var counter = 0;

  String _category = "Category 1";
  String _postType = "Found";
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  String _locationText = '';
  String FULLNAME = '';
  String PHONE = ''; // State variable for the button text
  Future<String?> getUserFullName(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return userData['fullname'];
    }

    return null;
  }

  Future<String?> getUserPhone(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return userData['phoneNumber'];
    }

    return null;
  }

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_sharp,
                            color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          counter = counter + 1;
                          _showInfoModal(context);
                        },
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
                  FutureBuilder<String?>(
                    future:
                        getUserFullName(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        FULLNAME = snapshot.data!;
                        // Do any additional processing or operations with the fullName variable if needed
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return const SizedBox
                          .shrink(); // Return an empty widget or null
                    },
                  ),
                  FutureBuilder<String?>(
                    future:
                        getUserPhone(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        PHONE = snapshot.data!;
                        // Do any additional processing or operations with the fullName variable if needed
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return const SizedBox
                          .shrink(); // Return an empty widget or null
                    },
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        height: 65,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchLocationScreen()),
                            );
                            if (result != null) {
                              setState(() {
                                _locationText = result;
                              });
                            }
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      _locationText.isEmpty
                                          ? "Choose your location..."
                                          : _locationText, // Display a placeholder if _locationText is empty
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Colors.black,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: Color(0xffE8ECF4)),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xffE8ECF4)),
                            elevation: MaterialStateProperty.all<double>(0),
                          ),
                        ),
                      ),
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
                        onPressed: () {
                          if (_postType == "Found") {
                            if (counter >= 1) {
                              _submitForm();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'You need to provide more information.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            _submitForm();
                          }
                        },
                        //   onPressed: () {
                        //   if (_postType == "Found") {
                        //     if (counter >= 1) {
                        //       _submitForm;
                        //     } else {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //           content: Text(
                        //               'You need to provide more information.'),
                        //           duration: Duration(seconds: 2),
                        //         ),
                        //       );
                        //     }
                        //   } else {
                        //     _submitForm;
                        //   }
                        // },
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

  void _showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'GuideLines for Posting a Found Item',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      '1. Don\'t Snoop: Avoid looking through the item in detail, as this could violate the person\'s privacy. If it\'s necessary to examine the item to identify the owner (for example, a wallet or purse), try to do so minimally.\n\n2. Identify the Owner: If there\'s any identification on or in the item (like a name, address, or phone number), you can use this information to try and contact the owner.\n\n3. Contact Relevant Authorities: If you can\'t identify the owner, consider turning the item over to local law enforcement or lost and found departments, if available. They might be able to find the owner or they might have been contacted by someone who lost an item.\n\n4. Protecting Personal Information: If the item contains sensitive information (like credit cards, ID cards, etc.), and you can\'t find the owner, make sure to give it to the police or a similar trustworthy organization. Never use this information for personal gain, as this is illegal and unethical.\n\n5. Protecting Personal Information: If the item contains sensitive information (like credit cards, ID cards, etc.), and you can\'t find the owner, make sure to give it to the police or a similar trustworthy organization. Never use this information for personal gain, as this is illegal and unethical.',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Ok',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    if (_formKey.currentState!.validate()) {
      // final fullName = _fullNameController.text.trim();
      //final phoneNo = _phoneNoController.text.trim();
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final imageUrls = await _uploadImages();
      final collection = await FirebaseFirestore.instance.collection('Posts');

      final entryData = {
        "id": userId,
        'full_name': FULLNAME,
        'phone_no': PHONE,
        'category': _category,
        'title': title,
        'description': description,
        'post_type': _postType,
        'image_urls': imageUrls,
        'address': _locationText,
        'date': DateTime.now(),
      };
      await collection.add(entryData);

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
