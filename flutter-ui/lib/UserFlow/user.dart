import 'dart:convert';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/Model/auth_model.dart';
import 'local_storage.dart';

class User {
  String
  firstName = "null", lastName = "null", _email = "null", _username = "null";
  String fullName = "null";
  bool _isOnline = false;
  int uid = -1;
  List<String> cachedData = <String>["", "", "", ""];

  User();

  User.newLogIn(String data) {
    uid = int.tryParse(jsonDecode(data)['uid']) ?? -1;
    firstName = jsonDecode(data)['first_name'];
    lastName = jsonDecode(data)['last_name'];
    fullName = firstName + " " + lastName;
    _email = jsonDecode(data)['email'];
    _username = jsonDecode(data)['username'];

    LocalStorage().cacheList(Constants().userStorageKey,
        <String>[uid.toString(), firstName, lastName, fullName, _email, _username]);
  }

  User.loadFromCache(List<String> data) {
    uid = int.tryParse(data.elementAt(0)) ?? -1;
    firstName = data.elementAt(1);
    lastName = data.elementAt(2);
    fullName = data.elementAt(3);
    _email = data.elementAt(4);
    _username = data.elementAt(5);

    // Background task - non-ui dependent
    syncWithDB();
  }

  Future syncWithDB() async {
    print("in cache");
    // Controller method
    try{
      List allData = await Auth().fetchUserDetails(uid);
      String userData = allData[1];

      String dbFirstName = jsonDecode(userData)['first_name'];
      String dbLastName = jsonDecode(userData)['last_name'];
      String dbEmail = jsonDecode(userData)['email'];
      String dbUsername = jsonDecode(userData)['username'];

      bool cacheRequired = false;

      if (firstName != dbFirstName){
        firstName = dbFirstName;
        cacheRequired = true;
      }
      if (lastName != dbLastName){
        lastName = dbLastName;
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
            <String>[uid.toString(), firstName, lastName, fullName, _email, _username]);
      }
    }
    on Exception catch (e){
      print("Server error - tried validating an already authenticated/signed in user"
          " with the db for any changes but could not connect to the server. \n $e");
    }
  }

  String getFirstName() => firstName;
  String getFullName() => fullName;
  String getEmail() => _email;
  String getUsername() => _username;
}
