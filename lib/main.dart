import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:task5/helper/authenticate.dart';
import 'package:task5/helper/helperfunction.dart';
import 'package:task5/views/Home.dart';
import 'package:task5/views/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task5/widget/colors.dart';
import 'package:task5/views/firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool userisloggedin = false;
  @override
  void initState() {
    // TODO: implement initState

    getloginState();
    super.initState();
  }

  getloginState() async {
    await HelperFunction.GetuserLoggedInSharedPreference().then((value) {
      setState(() {
        {
          if (value != null) {
            userisloggedin = value;
          } else {
            userisloggedin = false;
          }
        }
      });
    });
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              theme: ThemeData(
                primaryColor: Color(0xfff833AB4),
                accentColor: Color(0xfff5B51D8),
              ),
              builder: BotToastInit(), //1. call BotToastInit
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
              home: userisloggedin ? Home() : Authenticate());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}
