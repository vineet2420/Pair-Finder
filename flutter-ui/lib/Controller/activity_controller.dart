import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/ActivityFlow/activity_handler.dart';
import 'package:ipair/Controller/tab_state_provider.dart';
import 'package:ipair/Model/activity_model.dart';
import 'package:ipair/UserFlow/local_storage.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:ipair/View/Common/common_ui_elements.dart';
import 'package:provider/provider.dart';
import 'activity_state_provider.dart';
import 'package:vector_math/vector_math.dart';

import 'constants.dart';

class ActivityController {
  createActivity(Activity activity, BuildContext context, User user) async {
    TabStateProvider tabProvider =
        Provider.of<TabStateProvider>(context, listen: false);

    final List creationStatus =
        await ActivityModel().fetchActivityCreationStatus(activity);

    String activityData = "";
    String aid = "";
    switch (creationStatus.elementAt(0)) {
      case 200:
        ActivityStateProvider activityStateProvider =
            Provider.of<ActivityStateProvider>(context, listen: false);

        activityData = await creationStatus.elementAt(1);

        print(
            "Activity Created Server Response: ${json.decode(activityData)["ActivityCreated"]}");
        aid = json.decode(activityData)["ActivityCreated"].toString();

        activity.setActivityID = aid;

        ActivityHandler().sentActivities.add(activity);

        activityStateProvider
            .addSentActivities(ActivityHandler().sentActivities);

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
                    activityStateProvider.setActivityName("");
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
        // print("RAW DATA: $rawActivityData");

        final parsedActivities = await json.decode(rawActivityData);

        // print("parsedActivities: $parsedActivities");

        activitiesFound = parsedActivities['ActivitiesFound'] as List;

        // No events near by, sent, or going to
        if (activitiesFound[0] == "false") {
          return [];
        }
        // print(allActivities);

        return convertJsonToActivity(
            rawActivityData, 'ActivitiesFound', user, type);
      case 404:
      case 500:
        return [];
      default:
        return [];
    }
  }

  listenOnActivityUpdates(BuildContext context, User currentUser) async {
    ActivityStateProvider activityStateProvider =
        Provider.of<ActivityStateProvider>(context, listen: false);

    ActivityModel().socket.on('message', (data) async {
      try {
        final realTimeUpdate = json.decode(data);

        // New event written to db, check if within radius
        if (realTimeUpdate["ActivityCreated"] != null) {
          print(realTimeUpdate);

          //print("Here $data");
          List<Activity> newSingleActivity = await ActivityController()
              .convertJsonToActivity(
                  data, 'ActivityCreated', currentUser, FetchActivityType.Near);

          if (newSingleActivity.isNotEmpty) {
            if (isWithinRadius(newSingleActivity[0].activityLatitude,
                newSingleActivity[0].activityLongitude, currentUser.getRadius(), currentUser)) {

              print("Within radius");

              activityStateProvider.addNearByActivity(newSingleActivity[0]);

              CommonUiElements().showMessage("New Event Found!",
                  newSingleActivity[0].activityName, "Okay", context);
            }
          }
        }
        // Sent activity matched by another user
        else if (realTimeUpdate["ActivityUpdated"] != null) {
          late Activity activityToMoveToGoing;
          String aidReceived = realTimeUpdate["ActivityUpdated"][0].toString();
          String activityOwner =
              realTimeUpdate["ActivityUpdated"][1].toString();
          print(realTimeUpdate);

          if (activityOwner == currentUser.uid.toString()) {
            for (int i = 0; i < ActivityHandler().sentActivities.length; i++) {
              // print("Here ${ActivityHandler().sentActivities[i].getActivityID}");
              if (ActivityHandler().sentActivities[i].getActivityID ==
                  aidReceived) {
                // print("In loop");
                activityToMoveToGoing = ActivityHandler().sentActivities[i];

                ActivityHandler().sentActivities.remove(activityToMoveToGoing);
                ActivityHandler()
                    .attendingActivities
                    .add(activityToMoveToGoing);

                activityStateProvider
                    .addSentActivities(ActivityHandler().sentActivities);
                activityStateProvider
                    .addGoingActivities(ActivityHandler().attendingActivities);

                CommonUiElements().showMessage(
                    "Activity Matched!",
                    "Activity: ${activityToMoveToGoing.activityName}",
                    "Okay",
                    context);

                break;
              }
            }
          }
        }

        //print((realTimeUpdate["ActivityUpdated"] as List).length == 2);
      } catch (e) {
        print("Exception during real time update in socket: $e");
      }
    });
  }

  attendActivity(Activity activity, User user, BuildContext context) async {
    final List addPairResponse = await ActivityModel().addPair(activity, user);
    TabStateProvider tabProvider =
        Provider.of<TabStateProvider>(context, listen: false);

    switch (addPairResponse.elementAt(0)) {
      case 200:
        try {
          var activityStateProvider =
              Provider.of<ActivityStateProvider>(context, listen: false);
          ActivityHandler().nearByActivities.remove(activity);
          ActivityHandler().attendingActivities.add(activity);

          activityStateProvider
              .addAllNearByActivities(ActivityHandler().nearByActivities);
          activityStateProvider
              .addGoingActivities(ActivityHandler().attendingActivities);
          tabProvider.changeTab(2);
        } catch (e) {
          print(e);
        }

        return;
      case 404:
      case 500:
        return [];
      default:
        return [];
    }
  }

  disconnectSocket() => ActivityModel().socket.disconnect();

  Future<String> translateAddress(LatLng pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    Placemark place = placemarks[0];
    return "${place.name}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}";
  }

  Future<List<Activity>> convertJsonToActivity(
      response, String key, User user, FetchActivityType type) async {
    final parsedActivities = await json.decode(response);

    // print("In Convert: $parsedActivities");
    // Dynamic 2d list [[activity], [activity]] parsed from json
    List activitiesFound = parsedActivities[key] as List;
    List<Activity> activities = [];
    // print(activitiesFound[0]);
    for (int outer = 0; outer < activitiesFound.length; outer++) {
      LatLng pos = LatLng(0, 0);

      // print("Activities found: ${activitiesFound}");

      try {
        pos = LatLng(activitiesFound[outer][4].toDouble(),
            activitiesFound[outer][5].toDouble());
      } catch (e) {
        pos = LatLng(double.tryParse(activitiesFound[outer][4]) ?? 0.0,
            double.tryParse(activitiesFound[outer][5]) ?? 0.0);
        // print(e);
      }
      String aid = activitiesFound[outer][0].toString();
      String owner = activitiesFound[outer][1].toString();
      String activityName = activitiesFound[outer][2];
      String desc = activitiesFound[outer][3].toString();
      String pair =
          activitiesFound[outer][6] == "None" ? "" : activitiesFound[outer][6];
      String location = activitiesFound[outer][7];

      Activity activity = Activity(owner, activityName, desc, pos, location);
      activity.pairID = pair;
      activity.setActivityID = aid;

      // Skip events sent by the user to display in near by activities or if they are already matched
      if (type == FetchActivityType.Near &&
          (int.parse(owner) == user.uid || pair.isNotEmpty)) {
        //print("Name: $activityName Pair: $pair");
        continue;
      }
      // Skip events if the pair is matched so it will appear in going, not sent anymore
      else if (type == FetchActivityType.Sent && pair.isNotEmpty) {
        continue;
      }

      activities.add(activity);
    }

    return activities;
  }

  void updateRadius(User user) {

    LocalStorage().cacheList(Constants().userActivityStorageKey,
        <String>[user.getRadius().toString()]);

    ActivityModel().sendUpdatedRadius(user);
  }

  bool isWithinRadius(
      double latitude, double longitude, double radius, User user) {
    double distance = acos(
            sin(radians(user.latitude)) * sin(radians(latitude)) +
                cos(radians(user.latitude)) *
                    cos(radians(latitude)) *
                    cos(radians(longitude) - (radians(user.longitude)))) *
        3958.8;

    print("Distance: $distance");
    return distance <= radius;
  }
}
