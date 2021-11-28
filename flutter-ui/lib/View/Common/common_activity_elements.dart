import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/Controller/activity_controller.dart';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/UserFlow/user.dart';

class CommonActivityElements {
  // Nearby Activities horizontal grid view on home page
  Widget displayAllActivities(List<Activity> nearByActivities, User user,
      bool displayActionsRow, BuildContext context) {
    List<Widget> smallActivitiesDisplay = [];
    for (int i = 0; i < nearByActivities.length; i++) {
      smallActivitiesDisplay.add(singleSmallCardActivity(
          nearByActivities[i], user, displayActionsRow, context));
    }

    return Container(
        //color: Colors.red,
        height: 300,
        width: double.infinity,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          children: smallActivitiesDisplay,
        ));
  }

  Widget singleSmallCardActivity(
      Activity activity, User user, bool displayActionsRow, BuildContext context) {

    String activityNameWithoutExtraCharacters = "";

    Constants().emojiMap.forEach((key, value) {
      activityNameWithoutExtraCharacters = activity.activityName.toString().replaceAll(RegExp(r"[^A-Za-z0-9 ]*"), "");
      for (String keyword in value){
        if (activityNameWithoutExtraCharacters.toString().toLowerCase().contains(keyword)){
          activity.setEmoji = key;
        }
      }
    });

    return Container(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 200,
                    width: 350,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(activity.activityName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15)),
                          const SizedBox(height: 30),
                          Text(activity.emoji, style: TextStyle(fontSize: 30))
                        ],
                      ),
                      color: Colors.blueGrey.withOpacity(.2),
                    ),
                  ),
                ]),
            onTap: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) => displayLargeActivity(
                      activity, user, displayActionsRow, context));
            }));
  }

  Widget singleLargeCardActivity(
      Activity activity, User user, bool displayActionsRow, BuildContext context) {
    LatLng pos = LatLng(activity.activityLatitude, activity.activityLongitude);
    List<Marker> marker = [
      Marker(markerId: MarkerId(pos.toString()), position: pos)
    ];
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            height: 550,
            width: double.infinity,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(activity.activityName,
                        style: const TextStyle(fontSize: 22)),
                    Text(activity.activityDescription,
                        style: const TextStyle(fontSize: 15)),
                    displayMap(pos, marker),
                    Center(child: Text(activity.activityLocation)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: displayActionsRow
                            ? (<Widget>[
                                Expanded(
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        size: 50,
                                        color: Colors.indigo,
                                      ),
                                      onPressed: () => Navigator.pop(context)),
                                ),
                                Expanded(
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                            Icons.check_circle_outline,
                                            size: 50,
                                            color: Colors.green),
                                        onPressed: () {
                                          // Add implementation for going to an activity

                                          ActivityController().attendActivity(activity, user, context);

                                            print(activity.getActivityID);
                                            Navigator.pop(context);}))
                              ])
                            : <Widget>[
                              Center(
                                child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                              Icons.arrow_back,
                                              size: 50,
                                              color: Colors.indigo,
                                            ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              ])
                  ],
                ),
              ),
              color: Colors.white.withOpacity(.8),
            ),
          )
        ]));
  }

  Widget displayLargeActivity(
      Activity activity, User user, bool displayActionsRow, BuildContext context) {
    return Container(
        color: Colors.blueGrey.withOpacity(.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            singleLargeCardActivity(activity, user, displayActionsRow, context),
          ],
        ));
  }

  Widget displayMap(LatLng pos, List<Marker> marker) {
    return Container(
        height: 200,
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            child: GoogleMap(
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: pos,
                zoom: 11.0,
              ),
              markers: Set.from(marker),
            )));
  }

  Widget activityListHeader(String headerText) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Text(
            headerText,
            style: TextStyle(fontSize: 20),
          ))
    ]);
  }
}
