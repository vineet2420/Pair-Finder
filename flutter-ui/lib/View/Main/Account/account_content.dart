import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/UserFlow/user.dart';

class AccountPage extends StatefulWidget {
  final User user;
  const AccountPage(User this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const CupertinoSliverNavigationBar(
                largeTitle: AutoSizeText("Account"),
              )
            ];
          },
          body: Scaffold(
              body: Column(
                children: <Widget>[
                  sectionHeader('General'),
                  sectionRow('Name', widget.user.getName()),
                  sectionRow('Email', widget.user.getEmail()),
                  sectionRow('Username', widget.user.getUsername()),

                  sectionHeader('Notifications'),
                  sectionRow('Enable', ''),


                  Container(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child:
                      ElevatedButton(

                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(225, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                          onPressed: () {},
                          child: Text('Log Out')

                      )
                  )
                ],
              )
          ),
        )
    );
  }

  Widget sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 270, 0),
      height: 60,
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
        color: Colors.red.withOpacity(0.5),
      ),
    );
  }

  Widget sectionRow(String title, String content) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 100,
      child: Card(
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
        color: Constants().themeColor.withOpacity(0.5),
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
}
