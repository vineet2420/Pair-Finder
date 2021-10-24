import 'package:flutter/material.dart';
import 'package:ipair/UserFlow/local_storage.dart';
import 'package:ipair/View/Main/Account/account_content.dart';
import "Controller/constants.dart";
import 'UserFlow/user.dart';
import 'View/Auth/login.dart';
import 'View/Main/Home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<String> cachedData =
      await LocalStorage().getCachedList(Constants().userStorageKey) ??
          <String>["", "", "", ""];

  // print(cachedData);
  runApp(MyApp(cachedData));
}

class MyApp extends StatelessWidget {
  final List<String> cachedData;

  const MyApp(List<String> this.cachedData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("In build: ${cachedData}");
    int uid = -1;

    if (cachedData.elementAt(0).isNotEmpty) {
      uid = int.tryParse(cachedData.elementAt(0)) ?? -1;
    }

    return MaterialApp(
        title: 'iPair',
        theme: ThemeData(
          primarySwatch: Constants().themeColor,
          primaryColor: Colors.black,
          brightness: Brightness.light,
          backgroundColor: const Color(0xFF212121),
          dividerColor: Colors.black12,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final arguments = settings.arguments;
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => uid != -1
                      ? HomePage(User.loadFromCache(cachedData))
                      : const SignInPage());
            case '/signin':
              return MaterialPageRoute(
                  builder: (context) => const SignInPage());
            case '/home':
              if (arguments is User) {
                return MaterialPageRoute(
                    builder: (context) => HomePage(arguments));
              }
              return MaterialPageRoute(
                  builder: (context) => const SignInPage());
            case '/account':
              if (arguments is User) {
                return MaterialPageRoute(
                    builder: (context) => AccountPage(arguments));
              }
              return MaterialPageRoute(
                  builder: (context) => const SignInPage());
          }
        });
  }
}
