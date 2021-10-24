import 'dart:convert';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/Model/auth_model.dart';
import 'local_storage.dart';

class User {
  String firstName = "null", lastName = "null", _email = "null", _username = "null";
  String fullName = "null";
  bool _isOnline = false;
  int uid = -1;
  List<String> cachedData = <String>["", "", "", ""];

  User();

  User.newLogIn(String data) {
    uid = int.tryParse(jsonDecode(data)['uid']) ?? -1;
    firstName = jsonDecode(data)['first_name'];
    lastName = jsonDecode(data)['last_name'];
    _email = jsonDecode(data)['email'];
    _username = jsonDecode(data)['username'];

    LocalStorage().cacheList(Constants().userStorageKey,
        <String>[uid.toString(), firstName, _email, _username]);
  }

  User.loadFromCache(List<String> data) {
    uid = int.tryParse(data.elementAt(0)) ?? -1;
    firstName = data.elementAt(1);
    _email = data.elementAt(2);
    _username = data.elementAt(3);

    // Background task - non-ui dependent
    syncWithDB();
  }

  Future syncWithDB() async {
    print("in cache");
    // Controller method
    try{
      List allData = await Auth().fetchUserDetails(uid);
      String userData = allData[1];

      String dbName = jsonDecode(userData)['fullName'];
      String dbEmail = jsonDecode(userData)['email'];
      String dbUsername = jsonDecode(userData)['username'];

      bool cacheRequired = false;

      if (firstName != dbName){
        firstName = dbName;
        cacheRequired = true;
      }
      if (_email != dbEmail){
        _email = dbEmail;
        cacheRequired = true;
      }
      if (_username != dbUsername){
        _username = dbUsername;
        cacheRequired = true;
      }

      if (cacheRequired){
        LocalStorage().cacheList(Constants().userStorageKey,
            <String>[uid.toString(), firstName, _email, _username]);
      }
    }
    on Exception catch (e){
      print("Server error - tried validating an already authenticated/signed in user"
          " with the db for any changes but could not connect to the server. \n $e");
    }
  }

  String getName() => firstName;
  String getEmail() => _email;
  String getUsername() => _username;
}
