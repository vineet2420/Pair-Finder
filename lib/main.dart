import 'package:flutter/material.dart';
import 'View/sign_in.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.black,
        brightness: Brightness.light,
        backgroundColor: const Color(0xFF212121),
        dividerColor: Colors.black12,
      ),
      home: const SignInPage(),
    );
  }
}
