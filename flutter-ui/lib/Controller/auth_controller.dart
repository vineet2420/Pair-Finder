import 'package:flutter/material.dart';
import '../Model/auth_model.dart';
import '../View/Main/Home/home.dart';
import '../View/common_ui_elements.dart';
import '../View/Auth/login.dart';

class AuthController {
  void sanitizeAndSendCredentials(
      String email, String password, BuildContext context) async {
    final int isUser = await Auth().fetchCredentialStatus(email, password);

    switch (isUser) {
      case 200:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
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
}
