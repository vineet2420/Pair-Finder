import 'package:flutter/material.dart';
import "Controller/constants.dart";
import 'View/Auth/login.dart';
import 'View/Main/Home/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPair',
      theme: ThemeData(
        primarySwatch: Constants().themeColor,
        primaryColor: Colors.black,
        brightness: Brightness.light,
        backgroundColor: const Color(0xFF212121),
        dividerColor: Colors.black12,
      ),
      home: const SignInPage(),
    );
  }
}
