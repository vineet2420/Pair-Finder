import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Controller/constants.dart';
import 'sign_up.dart';
import 'common_ui_elements.dart';

// For the home page authentication UI
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
              SizedBox(height: 70.0, child: CommonUiElements().inputField(Constants().emailPlaceholder)),
              SizedBox(height: 50.0, child: CommonUiElements().inputField(Constants().passwordPlaceholder)),

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
          TextButton(onPressed: () {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
          );
          }, child: Text(Constants().signUpButtonText))
        ],
      );
  }
}