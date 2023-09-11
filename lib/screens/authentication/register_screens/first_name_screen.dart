import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';
import 'dateofbirth_screen.dart';

class Firstname extends StatefulWidget {
  const Firstname({super.key});

  @override
  State<Firstname> createState() => _FirstnameState();
}

class _FirstnameState extends State<Firstname> {
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: _nameKey,
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Add your name',
                    style: TextStyle(
                        fontSize: 18,
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold)),
                gap(10),
                Text(
                    'Add your name so your friends can find you easily. You control your name’s visibility with non-friends.',
                    style: TextStyle(fontSize: 14, color: primaryTextColor)),
                gap(30),
                customTextField(firstName, 'First Name', validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter first name.';
                  } else {
                    return null;
                  }
                }),
                gap(20),
                customTextField(lastName, 'Last Name', validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter last name.';
                  } else {
                    return null;
                  }
                }),
                gap(30),
                fullWidthButton(
                    buttonName: 'Next',
                    onTap: () {
                      if (_nameKey.currentState!.validate()) {
                      Nav.push(
                          context,
                          DateOfBirthScreen(
                              firstName: firstName.text,
                              lastName: lastName.text));
                      }
                    })
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
