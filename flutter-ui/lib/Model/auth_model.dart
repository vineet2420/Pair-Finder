import 'package:http/http.dart' as http;

class Auth{
  final String loginRoute = "http://localhost:5000/login";

  Future<bool> fetchCredentialStatus(String email, String password) async {
    final response = await http.get(Uri.parse(loginRoute+'?email='+email+"&password="+password));
    print("Login Status: ${response.statusCode}");
    return response.statusCode == 200;
  }

}
