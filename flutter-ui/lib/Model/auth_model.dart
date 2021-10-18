import 'package:http/http.dart' as http;

class Auth{
  final String loginRoute = "http://localhost:5000/login?";

  Future<int> fetchCredentialStatus(String email, String password) async {
    final response;

    try{
      response = await http.get(Uri.parse(loginRoute+'email='+email+"&password="+password));
      print("Login Status: ${response.statusCode}");
      return response.statusCode;
    }
    on Exception catch (e){

      print("Login Status Sever Error: $e");
      return 500;
    }
  }

  final String signUpRoute = "http://localhost:5000/signup?";

  Future<bool> fetchCreateUserStatus(String firstName, String lastName, String email, String uname, String password) async {
    final response = await http.get(Uri.parse(signUpRoute+
        'fname='+firstName+'&lname='+lastName+'&email='+email+'&uname='+uname+
        '&password='+password));

    print("Signup Status: ${response.statusCode}");
    return response.statusCode == 200;
  }

}
