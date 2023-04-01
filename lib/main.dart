import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thekabsfamilyapp/PRELIMS/sign_in.dart';
import 'PRELIMS/name_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This is the root of the Kabs Family application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kabs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Kabs'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Variables
  SharedPreferences? _sharedPreferences;
  String termsState = '';

  //Transition route
  Route fadeIn(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, page) {
        return FadeTransition(
          opacity: animation,
          child: page,
        );
      },
    );
  }

  Future<void> recallTerm() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      termsState = _sharedPreferences!.getString('termsState') ?? 'no';
    });
    if (kDebugMode) {
      print('terms is $termsState');
    }
  }

  @override
  void initState() {
    super.initState();
    recallTerm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          closingApp();
          return Future.value(false);
        },
        child: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'The Kabs Family Game',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      backgroundColor: Colors.green),
                  onPressed: () {
                    termsState == 'yes'
                        ? Navigator.push(context, fadeIn(const NamePage()))
                        : Navigator.push(context, fadeIn(const SignIn()));
                  },
                  child: const Text("Get Started"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void closingApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
