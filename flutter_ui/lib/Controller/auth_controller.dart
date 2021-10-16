import 'package:flutter/material.dart';
import '../Model/auth_model.dart';
import '../View/Main/Home/home.dart';

class AuthController {
  void sanitizeAndSendCredentials(String email, String password, BuildContext context) async{
   final bool isUser = await Auth().fetchCredentialStatus(email, password);

    if (isUser) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
    else {

    }
  }



}