import 'package:flutter/material.dart';

// ignore: camel_case_types
class NamePage extends StatefulWidget {
  const NamePage({super.key});
  @override
  NamePageState createState() => NamePageState();
}

// ignore: camel_case_types
class NamePageState extends State<NamePage> {
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
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.2),
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      primaryColor: const Color.fromARGB(33, 170, 173, 217)),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      labelText: 'What is your name',
                      hintText: 'Name...',
                      contentPadding: const EdgeInsets.all(5.0),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    controller: nameTextEditingController,
                    keyboardType: TextInputType.multiline,
                    focusNode: nameNode,
                  ),
                ),
              ),
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
