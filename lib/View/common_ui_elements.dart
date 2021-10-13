import 'package:flutter/material.dart';
import 'package:ipair/Controller/constants.dart';

class CommonUiElements{

  // Method to return a custom input field to reuse in sign in and sign up pages
  // Arg: String - placeholder text
  TextField inputField(String placeholder) {
    const TextStyle inputFieldStyle = TextStyle(fontSize: 20.0);
    const EdgeInsets inputFieldMargins = EdgeInsets.fromLTRB(20.0, 0, 20.0, 0);
    var _controller = TextEditingController();

    return TextField(
      obscureText: placeholder == Constants().passwordPlaceholder,
      style: inputFieldStyle,
      controller: _controller,
      decoration: InputDecoration(
          contentPadding: inputFieldMargins,
          hintText: placeholder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
    );
  }

}