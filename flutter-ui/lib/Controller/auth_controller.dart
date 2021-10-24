import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipair/UserFlow/local_storage.dart';
import 'package:ipair/UserFlow/user.dart';
import '../Model/auth_model.dart';
import '../View/Main/Home/home.dart';
import '../View/common_ui_elements.dart';
import '../View/Auth/login.dart';
import 'constants.dart';

class AuthController {
  void sanitizeAndSendCredentials(
      String email, String password, BuildContext context) async {
    final List isUser = await Auth().fetchCredentialStatus(email, password);
    String userData = "";

    switch (isUser.elementAt(0)) {
      case 200:
        userData = await isUser.elementAt(1);
        print("User data: ${userData}");
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (Route<dynamic> route) => false,
            arguments: User.newLogIn(userData));
        break;
      case 500:
        CommonUiElements().showMessage("Internal Server Error",
            "Please try again later.", "Okay", context);
        break;
      default:
        CommonUiElements().showMessage("Invalid Credentials",
            "Your email or password is incorrect.", "Try Again", context);
        break;
    }
  }

  void createUser(String firstName, String lastName, String email,
      String username, String password, BuildContext context) async {
    final bool createdUser = await Auth()
        .fetchCreateUserStatus(firstName, lastName, email, username, password);

    if (createdUser) {
      CommonUiElements().showMessageWithAction(
          "Success!",
          "Please check your email to verify your account.",
          "Okay.",
          context,
          (Future) =>
              Navigator.of(context).popAndPushNamed('../View/Auth/login'));
    } else {
      CommonUiElements().showMessage(
          "Unknown Error",
          "Could not create user with provided information.",
          "Try Again",
          context);
    }
  }

  void logOut(BuildContext context) {
    // Clear the cache
    LocalStorage()
        .cacheList(Constants().userStorageKey, <String>["", "", "", ""]);
    Navigator.pushReplacementNamed(context, "/signin");
  }

  String? validateTextField(String? value, String fieldName, int minChars) {
    if (value == null) {
      return "$fieldName field can't be null.";
    } else if (value.isEmpty) {
      return "$fieldName field can't be empty.";
    } else if (value.length < minChars) {
      return "$fieldName field is too short.";
    } else {
      return null;
    }
  }
}
