import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/UserFlow/user.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

enum FetchActivityType {
  Near, Sent, Going
}

class ActivityModel {

  IO.Socket socket = IO.io(Constants().host,
      <String, dynamic>{
    'transports': ['websocket']
  });

  final String newActivityRoute = Constants().host + "/activity/create?";

  Future<List> fetchActivityCreationStatus(Activity activity) async{
    final response;
    print(activity.activityLocation);
    try {
      response = await http.get(
          Uri.parse(newActivityRoute + 'owner=' + activity.owner + "&actname=" + activity.activityName
          + "&actdesc=" + activity.activityDescription + "&actlat=" + activity.activityLatitude.toString() +
              "&actlong=" + activity.activityLongitude.toString() + "&creationtime=" + activity.activityTimestamp.toString()
              + "&actaddress=" + activity.activityLocation));

      print("Activity Created Status: ${response.body}");
      return [response.statusCode, response.body];
    } on Exception catch (e) {
      print("Activity Created Status Sever Error: $e");
      return [500, "-1"];
    }

  }

  final String fetchNearActivityRoute = Constants().host + "/activity/fetch?";
  final String fetchSentActivityRoute = Constants().host + "/activity/fetchSent?";
  final String fetchGoingActivityRoute = Constants().host + "/activity/fetchGoing?";

  Future<List> fetchActivities (User user, FetchActivityType type) async {
    final response;
    // print("(${user.latitude}, ${user.longitude})");
    try {
      switch (type){

        case FetchActivityType.Near:
          response = await http.get(
              Uri.parse(fetchNearActivityRoute + 'userlat=' + user.latitude.toString() + "&userlong=" + user.longitude.toString()
                  + "&userradius="+user.getRadius().toString()),
              headers: {
                'Content-Type':'application/json'
              });

          // print(fetchNearActivityRoute + 'userlat=' + user.latitude.toString() + "&userlong=" + user.longitude.toString()
            //  + "&userradius=50");
          // print("RAW RESPONSE: ${response.body.toString()}");
          return [response.statusCode, response.body];

        case FetchActivityType.Sent:
          response = await http.get(
              Uri.parse(fetchSentActivityRoute + 'owner=' + user.uid.toString()));
          // print("Received Sent Events: ${response.body}");
          return [response.statusCode, response.body.toString()];

        case FetchActivityType.Going:
          response = await http.get(
              Uri.parse(fetchGoingActivityRoute + 'pair=' + user.uid.toString()));
          return [response.statusCode, response.body];
      }

      // print("Activity Fetched Status: ${response.body}");

    } on Exception catch (e) {

      print("Activity Fetched Status Sever Error: $e");
      return [500, "-1"];

    }
  }

  final String addPairRoute = Constants().host + "/activity/addUser?";

  Future<List> addPair(Activity activity, User user) async{
    final response;
    try {
      response = await http.get(
          Uri.parse(addPairRoute + 'pair=' + user.uid.toString() +
          '&aid=' + activity.getActivityID));

      print("Pair Added Status: ${response.body}");
      return [response.statusCode, response.body];
    } on Exception catch (e) {
      print("Paid Added Status Sever Error: $e");
      return [500, "-1"];
    }
  }

  void connectAndListen() async {
    if (!socket.connected){
      socket.onConnect((data)=>print("Connected"));
    }

   // socket.disconnect();
  }

  final String fetchRadiusUpdateRoute = Constants().host + "/activity/setRadius?";

  Future<List> sendUpdatedRadius(User user) async{
    final response;
    try {
      response = await http.get(Uri.parse(fetchRadiusUpdateRoute + 'radius=' +
          user.getRadius().toString() + '&uid=' + user.uid.toString()));

      print("Radius Updated Status: ${response.body}");

      return [response.statusCode, response.body];
    }
    on Exception catch (e) {

      print("Radius Updated Status Sever Error: $e");

      return [500, "-1"];
    }
  }

}

