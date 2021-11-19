import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipair/Controller/auth_controller.dart';
import '../../Controller/constants.dart';
import '../Common/common_ui_elements.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameFieldController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  const SizedBox(height: 120),
                  IconButton(iconSize: 30, icon: Icon(Icons.arrow_back, color: Constants().themeColor),
                      onPressed: () {Navigator.pop(context);}),
                ]
                ),
                signUpForm(_formKey),
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      AuthController().createUser(
                          firstNameController.text,
                          lastNameFieldController.text,
                          emailController.text,
                          usernameController.text,
                          passwordController.text,
                          context);
                    }
                  },
                  icon:
                      Icon(Icons.arrow_forward, color: Constants().themeColor),
                  iconSize: 35,
                ),
                Spacer(),
              ],
            )),
      ),
    );
  }

  Form signUpForm(Key? formKey) {
    return Form(
        key: formKey,
        child: Column(children: <Widget>[
          SizedBox(
              height: 100.0,
              child: CommonUiElements()
                  .inputField("First Name", firstNameController, 1)),
          SizedBox(
              height: 100.0,
              child: CommonUiElements()
                  .inputField("Last Name", lastNameFieldController, 1)),
          SizedBox(
              height: 100.0,
              child: CommonUiElements()
                  .inputField("Username", usernameController, 5)),
          SizedBox(
              height: 100.0,
              child:
                  CommonUiElements().inputField("Email", emailController, 3)),
          SizedBox(
              height: 100.0,
              child: CommonUiElements()
                  .inputField("Password", passwordController, 8))
        ]));
  }
}
