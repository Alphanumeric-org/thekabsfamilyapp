import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'accept_terms_and_conditions.dart';
import 'name_page.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  //Variables
  late User currentUser;
  bool isLoading = false;
  bool isLoggedIn = false;
  String termsState = '';

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences? _sharedPreferences;

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                backgroundColor: Colors.green),
            onPressed: () {
              intCheckSignUp();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Continue with google"),
              ],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                backgroundColor: Colors.green),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Continue with email"),
              ],
            ),
          ),
        ),
      ],
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
    isSignedIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  void isSignedIn() async {
    setState(() {
      isLoading = true;
    });

    _sharedPreferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, fadeIn(const NamePage()));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> handleSignUp() async {
    setState(() {
      isLoading = true;
    });
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User? firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      // Write data to local
      currentUser = firebaseUser;
      await _sharedPreferences!.setString('id', firebaseUser.uid);
      await _sharedPreferences!
          .setString('displayName', "${firebaseUser.displayName}");
      await _sharedPreferences!
          .setString('photoUrl', "${firebaseUser.photoURL}");

      // ignore: use_build_context_synchronously
      Navigator.push(context, fadeIn(const NamePage()));
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Sign in success");
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      setState(() {
        isLoading = false;
      });
    }
  }

  intCheckSignUp() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ignore: use_build_context_synchronously
        (termsState == 'yes')
            ? handleSignUp()
            :
            // ignore: use_build_context_synchronously
            Navigator.push(context, fadeIn(const AcceptTermsAndConditions()));
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: 'No internet access');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              _buildBody(),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context, fadeIn(const AcceptTermsAndConditions()));
                  },
                  child: const Text(
                    "Terms and Conditions",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                ))),
          ),
        )
      ]),
    ));
  }
}
