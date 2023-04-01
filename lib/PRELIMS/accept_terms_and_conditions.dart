import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thekabsfamilyapp/PRELIMS/sign_in.dart';

class AcceptTermsAndConditions extends StatefulWidget {
  const AcceptTermsAndConditions({super.key});

  @override
  AcceptTermsAndConditionsState createState() =>
      AcceptTermsAndConditionsState();
}

class AcceptTermsAndConditionsState extends State<AcceptTermsAndConditions> {
  String termsState = '';
  bool isLoading = false;
  late User currentUser;
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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

  setTerms() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    // Write data to local
    await _sharedPreferences.setString('termsState', 'yes');
    // ignore: use_build_context_synchronously
    Navigator.push(context, fadeIn(const SignIn()));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  ListTile(title: Center(child: Text("Terms"))),
                ]),
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "NOT NOW",
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            backgroundColor: Colors.green),
                        onPressed: () {
                          setTerms();
                        },
                        child: const Text(
                          "AGREE",
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
