import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Controller/constants.dart';

// For the home page authentication UI
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {


  // Method to return a custom input field to reuse in email and password
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(),

              SizedBox(height: 180.0, child: Constants().logoAsset),
              SizedBox(height: 20),
              SizedBox(height: 70.0, child: inputField(Constants().emailPlaceholder)),
              SizedBox(height: 50.0, child: inputField(Constants().passwordPlaceholder)),

              Row(children: <Widget>[
                const Spacer(),
                TextButton(onPressed: () {}, child: Text(Constants().forgotPasswordButtonText))
              ]),

              TextButton(onPressed: () {}, child: Text(Constants().signInButtonText)),

              Spacer(),
              bottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBar(){
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Constants().createAccountText),
          TextButton(onPressed: () {}, child: Text(Constants().signUpButtonText))
        ],
      );
  }
}