import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleContent extends StatefulWidget {
  const ScheduleContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScheduleContentState();

}

class _ScheduleContentState extends State<ScheduleContent> {
  @override
  Widget build(BuildContext context) {
    return setupSchedule();
  }

  Widget setupSchedule() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        displayActivitySmall(),
        displayActivitySmall(),
      ],
    );
  }

  Widget displayActivitySmall() {
    return Container(
        //color: Colors.red,
        height: 300,
        width: double.infinity,
        alignment: Alignment.center,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          children: <Widget>[
            singleSmallCardActivity(),
            singleSmallCardActivity()
          ],
        ));
  }

  Widget singleSmallCardActivity() {
    return Container(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                                "nameFieldContro ller.text .text nameFieldCont roller.text",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15)),
                            SizedBox(height: 30),
                            Text("😀", style: TextStyle(fontSize: 30)),
                          ],
                        ),
                      ),
                      color: Colors.blueGrey.withOpacity(.2),
                    ),
                  ),
                ]),
            onTap: () {
              print("Button Pressed");
              showCupertinoDialog(
                  context: context, builder: (context) => popUp());
            }));
  }

  Widget popUp() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 200,
              color: Colors.blueGrey[100],
              child: Center(
                  child: CupertinoDialogAction(
                      child: Text('Close'),
                      onPressed: () => Navigator.pop(context))),
            ),
          )),
    );
  }
}
