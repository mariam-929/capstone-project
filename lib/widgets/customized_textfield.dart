import "package:flutter/material.dart";

import "../constraints/password_constraints.dart";

class CustomizedTextField extends StatefulWidget {
  final TextEditingController mycontroller;
  final String? hindtext;
  final bool? isPassword;

  const CustomizedTextField({
    super.key,
    required this.mycontroller,
    this.hindtext,
    this.isPassword,
  });

  @override
  State<CustomizedTextField> createState() => _CustomizedTextFieldState();
}

class _CustomizedTextFieldState extends State<CustomizedTextField> {
  bool _isObscure = true;
  bool _isemail = true;
  // String passwordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  // RegExp regExp = RegExp(passwordPattern);

  // String validatePassword(String value) {
  //   if (value.isEmpty) {
  //     return 'Please enter your password.';
  //   } else if (!regExp.hasMatch(value)) {
  //     return 'Your password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
  //   }
  //   return "";
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        keyboardType: widget.isPassword!
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        enableSuggestions: widget.isPassword! ? false : true,
        autocorrect: widget.isPassword! ? false : true,
        obscureText: widget.isPassword! ? _isObscure : false,
        controller: widget.mycontroller,
        //autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            suffixIcon: widget.isPassword!
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xffE8ECF4), width: 1),
                borderRadius: BorderRadius.circular(10)),
            fillColor: const Color(0xffE8ECF4),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xffE8ECF4), width: 1),
                borderRadius: BorderRadius.circular(10)),
            filled: true,
            hintText: widget.hindtext,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
