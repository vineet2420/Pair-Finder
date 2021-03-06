import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Controller/auth_controller.dart';
import '../../Controller/constants.dart';
import 'signup.dart';
import '../Common/common_ui_elements.dart';

// For the home page authentication UI
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                SizedBox(height: 160.0, child: Constants().logoAsset),
                SizedBox(height: 40),
                loginForm(_formKey, emailFieldController, passwordFieldController),
                Row(children: <Widget>[
                  const Spacer(),
                  TextButton(
                      onPressed: () {},
                      child: Text(Constants().forgotPasswordButtonText))
                ]),
                IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AuthController().sanitizeAndSendCredentials(
                            emailFieldController.text,
                            passwordFieldController.text,
                            context);
                      }
                    },
                    icon: Icon(Icons.login_outlined,
                        color: Constants().themeColor),
                    iconSize: 35),
                Spacer(),
                bottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(Constants().createAccountText),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              );
            },
            child: Text(Constants().signUpButtonText))
      ],
    );
  }

  Form loginForm(Key? formKey, TextEditingController emailController,
      TextEditingController passwordController) {

    return Form(
        key: formKey,
        child: Column(children: <Widget>[
          SizedBox(
              height: 70.0,
              child: CommonUiElements().inputField("Email", emailController, 3)),
          const SizedBox(height: 10),
      SizedBox(
          height: 70.0,
          child: CommonUiElements().inputField("Password", passwordController, 8)),
        ]));
  }
}
