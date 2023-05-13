import "package:email_validator/email_validator.dart";
import "package:flutter/material.dart";

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _CategoryController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptioncontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();

  String dropDownValue = "Found";
  final items = ["Lost", "Found"];
  bool _haspressed = false;
  bool _islost = false;
  bool _isfound = false;

  _showImage() {
    return Text("Add Image here");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: const Text("Add Item"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: formkey,
              child: Column(children: [
                _showImage(),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Create Ad",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 16,
                ),
                ButtonTheme(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.purple[700]),
                    onPressed: () => {},
                    child: const Text(
                      "Add Image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    controller: fullnamecontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (name) {
                      if (name != null) {
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
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xffE8ECF4),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    controller: _emailcontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) {
                      if (email != null && !EmailValidator.validate(email)) {
                        // _emailController.clear();
                        // _passwordController.clear();
                        return "Please Enter a valid email";
                      } else {
                        return null;
                      }
                    },
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xffE8ECF4),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    controller: _phonecontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (phone) {
                      if (phone != null) {
                        // _emailController.clear();
                        // _passwordController.clear();
                        return "Please Enter your phone number";
                      } else {
                        return null;
                      }
                    },
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        labelText: "Phone No.",
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xffE8ECF4),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    enableSuggestions: true,
                    autocorrect: true,
                    obscureText: false,
                    controller: _CategoryController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (category) {
                      if (category != null) {
                        // _emailController.clear();
                        // _passwordController.clear();
                        return "Please Enter the Category of the item";
                      } else {
                        return null;
                      }
                    },
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        labelText: "Category",
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xffE8ECF4),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    enableSuggestions: true,
                    autocorrect: true,
                    obscureText: false,
                    controller: _titleController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (title) {
                      if (title != null) {
                        // _emailController.clear();
                        // _passwordController.clear();
                        return "Please Enter title of the item";
                      }
                      if (title!.length < 50) {
                        return "Title should be at least 50 characters";
                      } else {
                        return null;
                      }
                    },
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        helperText: "A title should be at least 50 characters",
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xffE8ECF4),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    enableSuggestions: true,
                    autocorrect: true,
                    obscureText: false,
                    controller: _descriptioncontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (description) {
                      if (description != null) {
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
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        helperText:
                            "Enter important discription such as color, feature, etc...",
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xffE8ECF4),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Post Type",
                      style: TextStyle(
                          color: Color.fromARGB(255, 123, 31, 162),
                          fontSize: 17),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      // height: 45,
                      // width: 85,
                      decoration: BoxDecoration(
                          color: Color(0xffE8ECF4),
                          //border: InputBorder.none,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonFormField(
                        // hint: const Text("Hello how are you"),

                        // Step 3.

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),

                        //hint: Text("Please pick if the item is Lost or Found"),
                        //borderRadius: BorderRadius.circular(10),

                        value: dropDownValue,
                        isExpanded: true,

                        // Step 4.
                        items:
                            items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.purple[700]),
                              ),
                            ),
                          );
                        }).toList(),
                        // Step 5.
                        onChanged: (String? newValue) {
                          setState(() {
                            dropDownValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
