import 'dart:convert';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/Model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage.dart';

class User {
  String _name = "null", _email = "null", _username = "null";
  bool _isOnline = false;
  int uid = -1;
  List<String> cachedData = <String>["", "", "", ""];

  User();

  User.newLogIn(String data) {
    uid = int.tryParse(jsonDecode(data)['uid']) ?? -1;
    _name = jsonDecode(data)['fullName'];
    _email = jsonDecode(data)['email'];
    _username = jsonDecode(data)['username'];

    LocalStorage().cacheList(Constants().userStorageKey,
        <String>[uid.toString(), _name, _email, _username]);
  }

  User.loadFromCache(List<String> data) {
    uid = int.tryParse(data.elementAt(0)) ?? -1;
    _name = data.elementAt(1);
    _email = data.elementAt(2);
    _username = data.elementAt(3);

    // Background task - non-ui dependent
    syncWithDB();
  }

  Future syncWithDB() async {
    print("in cache");
    // Controller method
    List allData = await Auth().fetchUserDetails(uid);
    String userData = allData[1];

    String dbName = jsonDecode(userData)['fullName'];
    String dbEmail = jsonDecode(userData)['email'];
    String dbUsername = jsonDecode(userData)['username'];

    bool cacheRequired = false;

    if (_name != dbName){
      _name = dbName;
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
          <String>[uid.toString(), _name, _email, _username]);
    }
  }

  String getName() => _name;
  String getEmail() => _email;
  String getUsername() => _username;
}
