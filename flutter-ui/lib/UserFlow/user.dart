import 'dart:convert';
import 'package:ipair/Controller/activity_controller.dart';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/Model/activity_model.dart';
import 'package:ipair/Model/auth_model.dart';
import 'local_storage.dart';
import 'package:geolocator/geolocator.dart';

class User {
  String
  _firstName = "null", _lastName = "null", _email = "null", _username = "null";
  String _fullName = "null";
  int uid = -1;
  List<String> cachedData = <String>["", "", "", ""];
  double latitude = 0;
  double longitude = 0;

  User();

  User.newLogIn(String data) {
    uid = int.tryParse(jsonDecode(data)['uid']) ?? -1;
    _firstName = jsonDecode(data)['first_name'];
    _lastName = jsonDecode(data)['last_name'];
    _fullName = _firstName + " " + _lastName;
    _email = jsonDecode(data)['email'];
    _username = jsonDecode(data)['username'];

    LocalStorage().cacheList(Constants().userStorageKey,
        <String>[uid.toString(), _firstName, _lastName, _fullName, _email, _username]);

    ActivityModel().connectAndListen();
  }

  User.loadFromCache(List<String> data) {
    uid = int.tryParse(data.elementAt(0)) ?? -1;
    _firstName = data.elementAt(1);
    _lastName = data.elementAt(2);
    _fullName = data.elementAt(3);
    _email = data.elementAt(4);
    _username = data.elementAt(5);

    // Background task - non-ui dependent
    syncWithDB();

    ActivityModel().connectAndListen();
  }

  Future syncWithDB() async {
    print("syncing with db info");
    // Controller method
    try{
      List allData = await Auth().fetchUserDetails(uid);
      String userData = allData[1];

      String dbFirstName = jsonDecode(userData)['first_name'];
      String dbLastName = jsonDecode(userData)['last_name'];
      String dbEmail = jsonDecode(userData)['email'];
      String dbUsername = jsonDecode(userData)['username'];

      bool cacheRequired = false;

      if (_firstName != dbFirstName){
        _firstName = dbFirstName;
        cacheRequired = true;
      }
      if (_lastName != dbLastName){
        _lastName = dbLastName;
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
            <String>[uid.toString(), _firstName, _lastName, _fullName, _email, _username]);
      }
    }
    on Exception catch (e){
      print("Server error - tried validating an already authenticated/signed in user"
          " with the db for any changes but could not connect to the server. \n $e");
    }
  }

  String getFirstName() => _firstName;
  String getFullName() => _fullName;
  String getEmail() => _email;
  String getUsername() => _username;
}
