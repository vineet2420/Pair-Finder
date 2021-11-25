import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';

class Constants {

  Image logoAsset = Image.asset("assets/images/logo.png", fit: BoxFit.fill);

  // Auth
  String emailPlaceholder = "Email";
  String passwordPlaceholder = "Password";

  String forgotPasswordButtonText = "Forgot Password";
  String signInButtonText = "Sign In";

  String createAccountText = "Don't have an account?";
  String signUpButtonText = "Sign Up";

  MaterialColor themeColor = Colors.indigo;

  String userStorageKey = "userStorage";

  String host = 'http://ec2-18-234-104-49.compute-1.amazonaws.com:8000';
  //String host = "http://10.0.2.2:8000";
  //String host = "http://127.0.0.1:8000";
}