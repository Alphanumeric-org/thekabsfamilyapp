import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  TextEditingController nameTextEditingController = TextEditingController();
  final FocusNode nameNode = FocusNode();

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome"),
                ]),
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        backgroundColor: Colors.green),
                    onPressed: () {},
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
