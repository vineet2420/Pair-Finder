import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Controller/constants.dart';
import '../common_ui_elements.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(height: 120),
                        IconButton(
                          iconSize: 30,
                            icon: Icon(Icons.arrow_back, color: Constants().themeColor,),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ]
                    ),
                    SizedBox(
                        height: 100.0,
                        child: CommonUiElements().inputField("First Name: ")),
                    SizedBox(
                        height: 100.0,
                        child: CommonUiElements().inputField("Last Name: ")),

                    SizedBox(
                        height: 100.0,
                        child: CommonUiElements().inputField("Username: ")),

                    SizedBox(
                        height: 100.0,
                        child: CommonUiElements().inputField(Constants().emailPlaceholder)),
                    SizedBox(
                        height: 100.0,
                        child: CommonUiElements().inputField(Constants().passwordPlaceholder)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward, color: Constants().themeColor), iconSize: 35,),
                    Spacer(),
                  ],
            )),
      ),
    );
  }
}
