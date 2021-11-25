import 'package:http/http.dart' as http;
import 'package:ipair/Controller/constants.dart';

class Auth {
  final String loginRoute = Constants().host + "/login?";

  Future<List> fetchCredentialStatus(String email, String password) async {
    final response;

    try {
      response = await http.get(
          Uri.parse(loginRoute + 'email=' + email + "&password=" + password));
      print("Login Status: ${response.body}");
      return [response.statusCode, response.body];
    } on Exception catch (e) {
      print("Login Status Sever Error: $e");
      return [500, "-1"];
    }
  }

  final String signUpRoute = Constants().host + "/signup?";

  Future<List> fetchCreateUserStatus(String firstName, String lastName,
      String email, String uname, String password) async {
    final response;
    try {
      response = await http.post(Uri.parse(signUpRoute +
          'fname=' + firstName + '&lname=' + lastName +
          '&email=' + email + '&uname=' + uname +
          '&password=' + password));
      print("Signup Status: ${response.body}");
      return [response.statusCode, response.body];
    } on Exception catch (e) {
      print("Sign up Status Sever Error: $e");
      return [500, "-1"];
    }
  }

  final String userDetailsRoute = Constants().host + "/getuser?uid=";

  Future<List> fetchUserDetails(int uid) async {
    try {
      final response =
          await http.post(Uri.parse(userDetailsRoute + uid.toString()));
      // print("User Details: ${response.body}");
      return [response.statusCode, response.body];
    } on Exception catch (e) {
      print("Sever Error: $e");
      return [500, "-1"];
    }
  }
}
