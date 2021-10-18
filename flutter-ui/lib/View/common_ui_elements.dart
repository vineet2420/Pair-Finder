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

  // Display a custom message in a dialog box on the screen
  // Ex. Error message with invalid credentials to display when logging in
  void showMessage(String title, String message, String buttonText, BuildContext context) {
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

  showMessageWithAction(String title, String message, String buttonText, BuildContext context, Function(Future<dynamic>) action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () { Navigator.of(context).pop();
              Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }
}