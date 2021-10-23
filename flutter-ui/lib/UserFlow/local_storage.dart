import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{

  void cacheList(String key, List<String> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, userDetails);
  }

  Future<List<String>?> getCachedList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userDetails = prefs.getStringList(key) ?? <String>["","","",""];
    return userDetails;
  }
}