import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ipair/Controller/constants.dart';
import '../../common_ui_elements.dart';
import 'dart:io' as IO;

class ActivityContent extends StatefulWidget {
  const ActivityContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActivityContentState();
}

enum Pages { name, location }

class _ActivityContentState extends State<ActivityContent>
    with TickerProviderStateMixin {
  TextEditingController eventNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();


  late List<Widget> allWidgetPages = [first(), second()];
  int page = Pages.name.index;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        child: allWidgetPages[page],
        switchOutCurve: Curves.easeInExpo,
        switchInCurve: Curves.easeOutExpo,
        transitionBuilder: (widget, animation) => ScaleTransition(
              scale: animation,
              child: widget,
            ));
  }



  Widget first() {

    return Container(
        key: Key('Name'),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
                key: _formKey,
                child: CommonUiElements()
                    .inputField("Event Name", eventNameController, 8)),
            SizedBox(height: 40),
            IconButton(
                onPressed: () {
                  setState(() {
                    page = 1;
                  });
                },
                icon: Icon(Icons.arrow_forward, color: Constants().themeColor),
                iconSize: 35),


          ],
        ));
  }



  Widget second() {
    return Container(
        key: Key('Location'),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
                key: _formKey2,
                child: CommonUiElements()
                    .inputField("Location", eventNameController, 8)),
            SizedBox(height: 40),
            IconButton(
                onPressed: () {
                  setState(() {
                    page = 0;
                  });
                },
                icon: Icon(Icons.arrow_forward, color: Constants().themeColor),
                iconSize: 35)
          ],
        ));
  }
}
