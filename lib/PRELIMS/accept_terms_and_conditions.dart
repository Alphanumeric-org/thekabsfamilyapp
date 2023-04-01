import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghraefx/pages/sign_in.dart';
import 'package:ghraefx/pages/userNameGen.dart';
import 'package:ghraefx/pages/welcome.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'init_page.dart';

class AcceptTermsAndConditions extends StatefulWidget {
  const AcceptTermsAndConditions({super.key});

  @override
  AcceptTermsAndConditionsState createState() =>
      AcceptTermsAndConditionsState();
}

class AcceptTermsAndConditionsState extends State<AcceptTermsAndConditions> {
  User? user;
  String termsStatus = '';
  final FirebaseAuth _ath = FirebaseAuth.instance;
  String? userProfile;
  void inputData() {
    user = _ath.currentUser;
    setState(() {
      userProfile = user?.uid;
    });
  }

  String termsState = '';
  Future<void> recallTerm() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      termsState = _sharedPreferences.getString('termsState')!;
    });
    if (kDebugMode) {
      print('terms is $termsState');
    }
  }

  void setTerms() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString('termsState', 'yes');
    // ignore: use_build_context_synchronously
    handleSignUp();
  }

  @override
  void initState() {
    super.initState();
    inputData();
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
            Column(children: [
              Center(
                child: Image.asset(
                  'assets/images/playstorei.png',
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ListTile(
                title: Column(
                  children: [
                    const Text(
                        "Quodin is updating its terms and privacy policy. By tapping AGREE, you accept the new "),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              _launchTerms();
                            },
                            child: const Text(
                              "terms ",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            )),
                        const Text("and "),
                        InkWell(
                            onTap: () {
                              _launchPrivacy();
                            },
                            child: const Text(
                              "privacy policy,",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            )),
                      ],
                    ),
                    const Text("which takes effect on January 1, 2023. "
                        "After this date, you'll need to accept these updates to continue using Quodin.")
                  ],
                ),
              ),
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
                          handleSignUp();
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

  void _showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Sign in success'),
            SizedBox(width: 5.0),
            Icon(Icons.check_circle_rounded, color: Colors.green),
          ],
        ),
      ),
    );
  }

  void _showProfileSnack(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: WillPopScope(
              onWillPop: () async {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                return true;
              },
              child: const Text('Account does not exist'),
            ),
          ),
        )
        .closed
        .then((reason) {});
  }

  String? mToken = '';
  String dspName = '';
  String loggingStatus = '';
  String status = '';
  bool isLoading = false;
  late User currentUser;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> handleSignUp() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      setState(() {
        mToken = token!;
      });
    });
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

    setState(() {
      dspName = firebaseUser!.displayName!;
    });

    List<String> splitList = dspName.split(" ");
    List<String> indexList = [];
    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }
    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('Users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isEmpty) {
        // Update data to server if new user
        setState(() {
          loggingStatus = 'register';
        });
        FirebaseFirestore.instance
            .collection('Users')
            .doc(firebaseUser.uid)
            .set({
          'displayName': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoURL,
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'aboutMe': "",
          'status': 'active',
          'chattingStatus': 'Away',
          'country': '',
          'countryIndex': '',
          'verified': 'no',
          'phoneNo': "",
          'username': "",
          'userIndex': "",
          'myToken': mToken,
          'location': "",
          'termsAccepted': "yes",
          'locationIndex': "",
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null,
          'searchIndex': indexList,
          'lastSeen': DateTime.now().millisecondsSinceEpoch.toString(),
        }).then((data) async {
          _sharedPreferences = await SharedPreferences.getInstance();
          // Write data to local
          currentUser = firebaseUser;
          await _sharedPreferences.setString('id', firebaseUser.uid);
          await _sharedPreferences.setString(
              'displayName', "${firebaseUser.displayName}");
          await _sharedPreferences.setString(
              'photoUrl', "${firebaseUser.photoURL}");
          await _sharedPreferences.setString('verified', "no");

          //checkRegister();

          //ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const UserName(
                        orgDoc: '',
                      )));
        });
      } else {
        setState(() {
          loggingStatus = 'notRegister';
        });

        _sharedPreferences = await SharedPreferences.getInstance();
        // Write data to local
        await _sharedPreferences.setString('id', documents[0]['id']);
        await _sharedPreferences.setString(
            'displayName', documents[0]['displayName']);
        await _sharedPreferences.setString(
            'photoUrl', documents[0]['photoUrl']);
        await _sharedPreferences.setString(
            'verified', documents[0]['verified']);
        await _sharedPreferences.setString('email', documents[0]['email']);
        await _sharedPreferences.setString('aboutMe', documents[0]['aboutMe']);
        await _sharedPreferences.setString(
            'username', documents[0]['username']);
        await _sharedPreferences.setString('country', documents[0]['country']);
        await _sharedPreferences.setString(
            'location', documents[0]['location']);
        await _sharedPreferences.setString('status', documents[0]['status']);
        await _sharedPreferences.setString('phoneNo', documents[0]['phoneNo']);
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(documents[0]['id'])
            .update({'myToken': await messaging.getToken()});

        setState(() {
          status = documents[0]['status'];
        });
        if (status == 'Deleted') {
          // ignore: use_build_context_synchronously
          _showProfileSnack(context);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => App(
                        currentUserId: documents[0]['id'],
                      )));
        }
      }
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      _showSuccess(context);
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkRegister() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: user!.uid)
        .where('username', isEqualTo: "")
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: Welcome(
                currentUserId: '',
                tIndex: '',
                photo: '',
              )));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: const UserName(
                orgDoc: '',
              )));
    }
  }

  void acceptTerms() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userProfile)
        .update({'termsAccepted': 'yes'}).then((data) {
      checkRegister();
    });
  }

  _launchPrivacy() async {
    String url =
        "https://docs.google.com/document/d/e/2PACX-1vTsEE9XMYlU5iTrMZE4WUAE1pUpz-E30sdLxPiEGrAh0Qa3n4nATGt5IorJ_vkcAqLm563ctqKnwt7T/pub";
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTerms() async {
    String url = "https://quodin.com/terms-of-use/";
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
