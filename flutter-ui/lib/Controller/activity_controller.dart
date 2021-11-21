import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/ActivityFlow/activity_handler.dart';
import 'package:ipair/Controller/tab_state_provider.dart';
import 'package:ipair/Model/activity_model.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:ipair/View/Common/common_ui_elements.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ipair/View/Main/Home/home.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:provider/provider.dart';

import 'activity_state_provider.dart';

class ActivityController {
  createActivity(Activity activity, BuildContext context, User user) async {

    TabStateProvider tabProvider = Provider.of<TabStateProvider>(context, listen: false);

    final List creationStatus =
        await ActivityModel().fetchActivityCreationStatus(activity);

    String activityData = "";

    switch (creationStatus.elementAt(0)) {
      case 200:
        activityData = await creationStatus.elementAt(1);
        print("Activity Created Server Response: ${activityData}");

        // Transition tab back to home
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success!"),
              content: Text("Activity distributed to all nearby users."),
              actions: <Widget>[
                TextButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.pop(context);
                    tabProvider.changeTab(2);
                  },
                ),
              ],
            );
          },
        );

        break;
      case 404:
      case 500:
        CommonUiElements().showMessage("Internal Server Error",
            "Please try again later.", "Okay", context);
        break;

      default:
        CommonUiElements().showMessage(
            "Unknown Error", "Please try again later.", "Okay", context);
        break;
    }
  }

  Future<List<Activity>> fetchActivities(
      User user, FetchActivityType type, BuildContext context) async {
    final List fetchStatus = await ActivityModel().fetchActivities(user, type);

    String rawActivityData = "";
    List activitiesFound = [];

    switch (fetchStatus.elementAt(0)) {
      case 200:
        rawActivityData = await fetchStatus.elementAt(1);

        final parsedActivities = json.decode(rawActivityData);
        activitiesFound = parsedActivities['ActivitiesFound'] as List;

        // No events near by
        if (activitiesFound[0] == "false") {
          return [];
        }
        // print(allActivities);

        return convertJsonToActivity(rawActivityData, 'ActivitiesFound', user, type);
      case 404:
      case 500:
        return [];
      default:
        return [];
    }
  }

  displayNewActivity(BuildContext context, User currentUser) async {

    ActivityStateProvider activityStateProvider = Provider.of<ActivityStateProvider>(context, listen: false);

    int c = 0;
    print("called");
    ActivityModel().socket.on('message', (data) {
      List<Activity> newSingleActivity = ActivityController()
          .convertJsonToActivity(data, 'ActivityCreated', currentUser, FetchActivityType.Near);

      if (newSingleActivity.isNotEmpty) {

        activityStateProvider.addNearByActivity(newSingleActivity[0]);

        CommonUiElements().showMessage(
            "New Event Found!", newSingleActivity[0].activityName, "Okay",
            context);
      }
      print(data);
    });
  }

  disconnectSocket() => ActivityModel().socket.disconnect();

  Future<String> translateAddress(LatLng pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    Placemark place = placemarks[0];
    return "${place.name}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}";
  }

  Future<Position> getUserLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void permissionDeniedMessage(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Location Permission Required"),
          content: Text("Please enable location services from your settings "
              "application to continue using the app."),
        );
      },
    );
  }

  List<Activity> convertJsonToActivity(String response, String key, User user, FetchActivityType type){
    final parsedActivities = json.decode(response);

    // Dynamic 2d list [[activity], [activity]] parsed from json
    List activitiesFound = parsedActivities[key] as List;
    List<Activity> allActivities = [];
    // print(activitiesFound);
    for (int outer = 0; outer < activitiesFound.length; outer++) {
      LatLng pos = LatLng(0, 0);
      try{
        pos = LatLng(activitiesFound[outer][3].toDouble(),
            activitiesFound[outer][4].toDouble());

      }
      catch (e){
        print("$e for ${activitiesFound[outer][3]}");
        pos = LatLng(double.parse(activitiesFound[outer][3]),
            double.parse(activitiesFound[outer][4]));
      }

      String owner = activitiesFound[outer][0];
      String activityName = activitiesFound[outer][1];
      String desc = activitiesFound[outer][2];
      String pair = activitiesFound[outer][5] == "None"
          ? ""
          : activitiesFound[outer][5];
      String location = activitiesFound[outer][6];

      Activity activity =
      Activity(owner, activityName, desc, pos, location);
      activity.pairID = pair;

      // Skip events sent by the user to display in near by activities
      if (type == FetchActivityType.Near && int.parse(owner) == user.uid){
        continue;
      }

      allActivities.add(activity);
    }

    return allActivities;
  }
}
