import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipair/Controller/auth_controller.dart';
import '../../Controller/constants.dart';

class CommonUiElements {

  // Method to return a custom input field to reuse in sign in and sign up pages
  TextFormField inputField(String placeholder, TextEditingController _controller, int minChars) {
    const TextStyle inputFieldStyle = TextStyle(fontSize: 16.0);
    const EdgeInsets inputFieldMargins = EdgeInsets.fromLTRB(20.0, 0, 20.0, 0);

    return TextFormField(
      obscureText: placeholder == Constants().passwordPlaceholder,
      style: inputFieldStyle,
      controller: _controller,
      validator: (value) => AuthController().validateTextField(value, placeholder, minChars),
        inputFormatters: [
          FilteringTextInputFormatter.allow(placeholder=="First Name"||placeholder=="Last Name"?RegExp(r"[a-zA-Z]"):RegExp(r"[^\n ]")),
          LengthLimitingTextInputFormatter(32),
        ],
      decoration: InputDecoration(
          contentPadding: inputFieldMargins,
          hintText: placeholder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
    );
  }

  // Display a custom message in a dialog box on the screen
  // Ex. Error message with invalid credentials to display when logging in
  void showMessage(
      String title, String message, String buttonText, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showMessageWithAction(String title, String message, String buttonText,
      BuildContext context, Function(Future<dynamic>) action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget sectionHeader(String title) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      const SizedBox(width: 20),
      Text(title,
          style: const TextStyle(
            //color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ))
    ]);
    /*
    For putting header in a colored card container
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 200, 0),
      height: 60,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                title,
                style: const TextStyle(
                  //color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
        //color: Colors.red.withOpacity(.9),
      ),
    );

     */
  }
}
