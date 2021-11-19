import 'package:http/http.dart' as http;

class Auth {
  final String loginRoute = "http://localhost:8000/login?";
       //"http://ec2-52-201-232-123.compute-1.amazonaws.com:5000/login?";

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

  final String signUpRoute = "http://localhost:8000/signup?";
       //"http://ec2-52-201-232-123.compute-1.amazonaws.com:5000/signup?";

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

  final String userDetailsRoute = "http://localhost:8000/getuser?uid=";
      //"http://ec2-52-201-232-123.compute-1.amazonaws.com:5000/getuser?uid=";

  Future<List> fetchUserDetails(int uid) async {
    try {
      final response =
          await http.post(Uri.parse(userDetailsRoute + uid.toString()));
      print("User Details: ${response.body}");
      return [response.statusCode, response.body];
    } on Exception catch (e) {
      print("Sever Error: $e");
      return [500, "-1"];
    }
  }
}
