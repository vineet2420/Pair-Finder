import 'package:flutter/material.dart';
import '../Controller/constants.dart';

class CommonUiElements{

  // Method to return a custom input field to reuse in sign in and sign up pages
  // Arg: String - placeholder text
  TextField inputField(String placeholder, TextEditingController _controller) {
    const TextStyle inputFieldStyle = TextStyle(fontSize: 16.0);
    const EdgeInsets inputFieldMargins = EdgeInsets.fromLTRB(20.0, 0, 20.0, 0);

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