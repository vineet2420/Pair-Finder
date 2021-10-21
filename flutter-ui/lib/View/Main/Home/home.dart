import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:ipair/View/Main/Account/account_content.dart';
import '../Activity/activity_content.dart';
import '../Schedule/schedule_content.dart';
import 'home_content.dart';

// For the home page UI
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexToSet = 0;
  late List<Widget> widgetPages;

  User user = User(1);

  onTabSelected(int requestedIndex) {

    setState(() {
      indexToSet = requestedIndex;
    });

  }

  @override
  Widget build(BuildContext context) {
    widgetPages = [
      HomeContent().setupHomeContent(),
      ActivityContent().setupActivity(),
      ScheduleContent().setupSchedule()];


    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return navigationController('Welcome, Vinny');
        },
        body: Scaffold(
          body: widgetPages[indexToSet],
          bottomNavigationBar: bottomNavBar(),
        ),

        
      ),

    );
  }

  List<Widget> navigationController(String navBarText) {
    return <Widget>[
      CupertinoSliverNavigationBar(
        largeTitle: AutoSizeText(navBarText),
        trailing: accountSettings(),
      )
    ];
  }

  Widget accountSettings() {
    return Material(
        child: IconButton(
      icon: const Icon(Icons.manage_accounts_outlined),
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => AccountPage(user)),
        );
      },
    ));
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: indexToSet,
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Activities'),
      ],
    );
  }
}