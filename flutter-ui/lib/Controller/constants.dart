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
}