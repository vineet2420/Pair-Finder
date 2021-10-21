class User{
  String _name = "null", _email = "null", _username = "null";
  bool _isOnline = false;
  int _uid = -1;
  List<String> details = List.filled(3, "null");

  User(int uid){
    _name = details.elementAt(0);
    _email = details.elementAt(1);
    _username = details.elementAt(2);
  }

  String getName() => _name;
  String getEmail() =>  _email;
  String getUsername() =>  _username;
}