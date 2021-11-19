import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/Controller/activity_controller.dart';

class CommonActivityElements {
  Widget displayAllActivities(BuildContext context) {
    return Container(
        //color: Colors.red,
        height: 300,
        width: double.infinity,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          children: <Widget>[
            singleSmallCardActivity(context),
            singleSmallCardActivity(context)
          ],
        ));
  }

  Widget singleLargeCardActivity(Activity activity) {
    LatLng pos = LatLng(activity.activityLatitude, activity.activityLongitude);
    List<Marker> marker = [
      Marker(markerId: MarkerId(pos.toString()), position: pos)
    ];

    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                height: 400,
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
                            style: TextStyle(fontSize: 22)),
                        Text(activity.activityDescription,
                            style: TextStyle(fontSize: 15)),
                        displayMap(pos, marker),
                        Center(child: Text(activity.activityLocation)),
                      ],
                    ),
                  ),
                  color: Colors.blueGrey.withOpacity(.8),
                ),
              )
            ]));
  }

  Widget singleSmallCardActivity(BuildContext context) {
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
                        children: const [
                          Text(
                              "nameFieldContro ller.text .text nameFieldCont roller.text",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15)),
                          SizedBox(height: 30),
                          Text("😀", style: TextStyle(fontSize: 30))
                        ],
                      ),
                      color: Colors.blueGrey.withOpacity(.2),
                    ),
                  ),
                ]),
            onTap: () async {
              print("Button Pressed");
              showCupertinoDialog(
                  context: context, builder: (context) => popUp(context));
            }));
  }

  Widget popUp(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
          child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 500,
              color: Colors.blueGrey[100],
              child: Center(
                child: Column(
                  children: [
                    singleLargeCardActivity(Activity(
                        "1",
                        "_activity_name",
                        "_activity_description",
                        LatLng(40.7128, -74.0060),
                        "_activityLocation")),
                    CupertinoDialogAction(
                        child: Text('Close'),
                        onPressed: () => Navigator.pop(context))
                  ],
                ),
              ),
            ),
          ))),
    );
  }

  Widget displayMap(LatLng pos, List<Marker> marker) {
    return Container(
        height: 200,
        child:  GoogleMap(
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: pos,
                zoom: 11.0,
              ),
              markers: Set.from(marker),
            ));
  }
}
