import 'package:flutter/material.dart';
import 'package:ipair/UserFlow/local_storage.dart';
import 'package:ipair/UserFlow/user.dart';
import '../Model/auth_model.dart';
import '../View/Common/common_ui_elements.dart';
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
    final List createdUser = await Auth()
        .fetchCreateUserStatus(firstName, lastName, email, username, password);

    switch (createdUser.elementAt(0)) {
      case 200:
      CommonUiElements().showMessageWithAction(
          "Success!",
          "Please sign in with your credentials.",
          "Okay.",
          context, (Future) => Navigator.of(context).popAndPushNamed('../View/Auth/login'));
      break;
      case 409:
        CommonUiElements().showMessageWithAction("Account Exists",
            "Your account was found, please proceed to sign in.", "Okay 🤔",
            context, (Future) => Navigator.of(context).popAndPushNamed('../View/Auth/login'));
        break;
      case 410:
        CommonUiElements().showMessage("Username Exists",
            "Please choose another username.", "Okay", context);
        break;
      case 500: CommonUiElements().showMessage("Internal Server Error",
          "Please try again later.", "Okay", context);
      break;
      default:
        CommonUiElements().showMessage("Unknown Error",
            "Could not create user with provided information.", "Try Again", context);
        break;
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
      if (fieldName == "Email"){
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
          return "Please check email address format.";
        }
      }
      return null;
    }
  }
}
