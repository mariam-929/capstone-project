import "dart:ffi";

import "package:flutter/material.dart";

class CustomizedButton extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final bool isEmail;
  final VoidCallback? onPressed;
  const CustomizedButton({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.onPressed,
    this.textColor,
    required this.isEmail,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: buttonColor,
              border: Border.all(
                  width: 1, color: Color.fromARGB(255, 255, 203, 72)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isEmail
                    ? const Icon(
                        Icons.email,
                        size: 24,
                        color: Colors.white,
                      )
                    : Container(),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  buttonText!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}
