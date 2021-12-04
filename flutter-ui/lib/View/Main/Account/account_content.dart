import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ipair/Controller/activity_controller.dart';
import 'package:ipair/Controller/activity_state_provider.dart';
import 'package:ipair/Controller/auth_controller.dart';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/Model/activity_model.dart';
import 'package:ipair/UserFlow/local_storage.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:ipair/View/Common/common_ui_elements.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  final User user;

  const AccountPage(User this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool switchVal = true;
  late double _currentSliderValue;

  @override
  void initState() {
    _currentSliderValue = widget.user.getRadius();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;

    return CupertinoPageScaffold(
        child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
        WillPopScope(
        onWillPop: () => updateRadius(user),
        child: const CupertinoSliverNavigationBar(
            largeTitle: AutoSizeText("Account")
        )

          )
        ];
      },
      body: Scaffold(
          body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          CommonUiElements().sectionHeader('General'),
          sectionRow('Name', user.getFullName()),
          sectionRow('Email', user.getEmail()),
          sectionRow('Username', user.getUsername()),
          const SizedBox(height: 20),

          CommonUiElements().sectionHeader('Radius'),
          Slider(
            value: _currentSliderValue,
            min: 5,
            max: 100,
            divisions: 95,
            label: _currentSliderValue.round().toString() + " mi",
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),

          /*
          CommonUiElements().sectionHeader('Notifications'),
          customWidgetSectionRow('Enable', <Widget>[
            Switch(
                onChanged: (bool value) {
                  setState(() {
                    switchVal = value;
                  });
                },
                value: switchVal,
                activeColor: Colors.red)
          ]),
           */
          logOutButton()
        ],
      )),
    ));
  }

  Future<bool> updateRadius(User user) async{
    print("Before round: $_currentSliderValue, and after: ${_currentSliderValue.roundToDouble()}");
    widget.user.radius = _currentSliderValue.roundToDouble();
    print("Updated user radius in object: ${ widget.user.getRadius()}");

    ActivityStateProvider activityStateProvider = Provider.of<ActivityStateProvider>(context, listen: false);
    List<String> cachedActivityData =
        await LocalStorage().getCachedList(Constants().userActivityStorageKey) ??
            <String>["49"];

    if (user.getRadius().toString()!= cachedActivityData[0].toString()){
      activityStateProvider.addAllNearByActivities(await ActivityController().fetchActivities(user, FetchActivityType.Near, context));
    }

    return true;
  }

  Widget sectionRow(String title, String content) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 100,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              customRowTitle(title + ": "),
              customRowText(content),
            ],
          ),
        ),
        color: Constants().themeColor.withOpacity(.8),
      ),
      // color: Constants().themeColor.withOpacity(.5),
    );
  }

  Widget customWidgetSectionRow(String title, List<Widget> content) {
    content.insert(0, customRowTitle(title + ": "));
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 100,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: content,
          ),
        ),
        color: Constants().themeColor.withOpacity(.8),
      ),
    );
  }

  Text customRowTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text customRowText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget logOutButton() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: ElevatedButton(
            style: ButtonStyle(
              // backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              minimumSize: MaterialStateProperty.all(const Size(225, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            onPressed: () {
              AuthController().logOut(context);
            },
            child: const Text('Log Out')));
  }
}
