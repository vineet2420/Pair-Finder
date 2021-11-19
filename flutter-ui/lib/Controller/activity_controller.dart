import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/Model/activity_model.dart';
import 'package:ipair/UserFlow/local_storage.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:ipair/View/Main/Home/home.dart';
import 'package:ipair/View/Common/common_ui_elements.dart';
import 'constants.dart';

class ActivityController {
  createActivity(Activity activity, BuildContext context, User user) async {
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
                    Navigator.of(context).pushReplacementNamed('/home', arguments: user);
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

  displayNewActivity(BuildContext context, User currentUser) async {
    int c = 0;
    print("called");
    List<String> activityDetails;
    int activityOwnerId;
    ActivityModel().socket.on('message', (data) {
      data = data.toString().replaceAll('[', '');
      data = data.toString().replaceAll(']', '');
      data = data.toString().replaceAll('\'', '');
      activityDetails = data.split(new RegExp(r', +'));

      activityOwnerId = int.parse(activityDetails[0]);

      if (currentUser.uid != activityOwnerId) {
        CommonUiElements()
            .showMessage("New Activity Found", data, "Okay", context);
      }

      print(data.toString() + " c: $c");
      c++;
    });
  }

  disconnectSocket() => ActivityModel().socket.disconnect();

  Future<String> translateAddress(LatLng pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    Placemark place = placemarks[0];
    return "${place.name}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}";
  }
}
