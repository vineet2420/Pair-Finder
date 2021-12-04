import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/Controller/activity_controller.dart';
import 'package:ipair/Controller/activity_state_provider.dart';
import 'package:ipair/Controller/auth_controller.dart';
import 'package:ipair/Controller/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:provider/provider.dart';

class ActivityContent extends StatefulWidget {
  final User user;

  const ActivityContent(User this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActivityContentState();
}

enum Pages { name, description, location, preview }

class _ActivityContentState extends State<ActivityContent>
    with TickerProviderStateMixin {
  late List<Widget> allWidgetPages;
  int page = Pages.name.index;

  TextEditingController nameFieldController = TextEditingController();
  TextEditingController descFieldController = TextEditingController();
  TextEditingController searchFieldController = TextEditingController();

  final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> descFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> locationFormKey = GlobalKey<FormState>();


  late GoogleMapController mapController;
  List<Marker> marker = [];


  late ActivityStateProvider activityStateProvider;

  @override
  Widget build(BuildContext context) {

    activityStateProvider = Provider.of<ActivityStateProvider>(context, listen: false);

    allWidgetPages = [
      nameField(),
      descriptionField(),
      locationField(),
      previewActivity()
    ];

    return  page == 2
        ? locationField()
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: allWidgetPages[page],
            switchOutCurve: Curves.easeInExpo,
            switchInCurve: Curves.easeOutExpo,
            transitionBuilder: (widget, animation) =>
                ScaleTransition(scale: animation, child: widget)
    );
  }

  Widget nameField() {
    nameFieldController.text = activityStateProvider.activityName;

    return Container(
        key: Key("nameKey"),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Form(
                key: nameFormKey,
                child: TextFormField(
                    controller: nameFieldController,
                    validator: (value) => AuthController().validateTextField(value, "Event Name", 2),
                    maxLength: 100,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(hintText: "Event Name"))),
            Spacer(),
            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [transitionButtons(1, 1, [Icons.arrow_forward])],
            )
          ],
        ));
  }

  Widget descriptionField() {
    return Container(
        key: Key("descKey"),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Form(
                key: descFormKey,
                child: TextFormField(
                  controller: descFieldController,
                  validator: (value) => AuthController().validateTextField(value, "Description", 2),
                  maxLength: 500,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(hintText: "Description"),
                )),
            SizedBox(height: 40),
            Spacer(),
            transitionButtons(2, 2, [Icons.arrow_back, Icons.arrow_forward])
          ],
        ));
  }

  Widget locationField() {
    return Container(
        key: Key("locationKey"),
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              activityMap(),
              const SizedBox(height: 20),
                Expanded(child:Form(
                  key: locationFormKey,
                  child: TextFormField(
                    controller: searchFieldController,
                    maxLines: null,
                    validator: (value){
                      if (marker.isEmpty){
                        return "Please tap to add a location on the map.";
                      }
                      else{
                        return AuthController().validateTextField(value, "Search", 2);
                      }
                    },
                    decoration: InputDecoration(hintText: "Search"),
                    textAlign: TextAlign.center,
                  ))),
              const SizedBox(height: 40),
              Spacer(),
              transitionButtons(2, 3, [Icons.arrow_back, Icons.arrow_forward])
            ]
        )
    );
  }

  Widget previewActivity() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Spacer(),
        Container(
          padding: EdgeInsets.all(10),
          height: 500,
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
                  Text(nameFieldController.text, style: TextStyle(fontSize: 22)),
                  Text(descFieldController.text, style: TextStyle(fontSize: 15)),
                  activityMap(),
                  Center(child: Text(searchFieldController.text)),
                ],
              ),
            ),
            color: Colors.blueGrey.withOpacity(.2),
          ),
        ),
            Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    page = 2;
                  });
                },
                icon: Icon(Icons.arrow_back,
                    color: Constants().themeColor),
                iconSize: 35),
            SizedBox(width: 50),
            IconButton(
                onPressed: () {
                  setState(() {
                    Activity newActivity = Activity(widget.user.uid.toString(), nameFieldController.text, descFieldController.text, marker[0].position, searchFieldController.text);
                    ActivityController().createActivity(newActivity, context, widget.user);
                  });
                },
                icon: Icon(Icons.send, color: Constants().themeColor),
                iconSize: 35),
          ],
        )
      ]),
    );
  }

  Container activityMap() {
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
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: marker.isEmpty?LatLng(widget.user.latitude, widget.user.longitude):marker[0].position,
                zoom: 11.0,
              ),
              markers: Set.from(marker),
              onTap: (LatLng pos) async {
                String addressTranslation =
                    await ActivityController().translateAddress(pos);
                setState(() {
                  marker = [];
                  marker.add(Marker(
                      markerId: MarkerId(pos.toString()), position: pos));
                  searchFieldController.text = addressTranslation;
                });
              },
            )
        )
    );
  }

  Widget transitionButtons(int buttons, int nextPage, List<IconData> icons) {
    int prev = nextPage - 1;
    if (buttons == 1) {
      return IconButton(
          onPressed: () {
            if (nameFormKey.currentState!.validate()) {
              setState(() {
                page = nextPage;

                // For activity name text field text save
                activityStateProvider.setActivityName(
                    nameFieldController.text.replaceAll("\n", " "));
              });
            }
          },
          icon: Icon(icons[0], color: Constants().themeColor),
          iconSize: 35);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                page = prev - 1;
              });
            },
            icon: Icon(icons[0], color: Constants().themeColor),
            iconSize: 35),
        SizedBox(width: 50),
        IconButton(
            onPressed: () {
              if (page == 1 && descFormKey.currentState!.validate()) {
                  setState(() {
                    page = nextPage;
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                }
              else if (page == 2 && locationFormKey.currentState!.validate()) {
                setState(() {
                page = nextPage;
                FocusManager.instance.primaryFocus?.unfocus();
                });
              }
              else if (page > 2){
                setState(() {
                  page = nextPage;
                });
              }
            },
            icon: Icon(icons[1], color: Constants().themeColor),
            iconSize: 35),
      ],
    );
  }
}
