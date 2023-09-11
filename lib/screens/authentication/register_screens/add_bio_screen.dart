import 'package:bar_monkey/screens/authentication/register_screens/privecy_level_screen.dart';
import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class AddBio extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String date;
  final String drink;

  const AddBio(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.date,
      required this.drink});

  @override
  State<AddBio> createState() => _AddBioState();
}

class _AddBioState extends State<AddBio> {
  final TextEditingController bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Add a bio',
              style: TextStyle(
                  fontSize: 18,
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold)),
          gap(10),
          Text(
              'A profile with a good bio makes you more approachable. You can change this at anytime.',
              style: TextStyle(fontSize: 14, color: primaryTextColor)),
          gap(30),
          customTextField(bio, 'Bio'),
          gap(30),
          fullWidthButton(
              buttonName: 'Next',
              onTap: () {
                Nav.push(
                    context,
                    PrivecyLevelScreen(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      date: widget.date,
                      drink: widget.drink,
                      bio: bio.text,
                    ));
              }),
          gap(30),
          borderedButton(
              buttonName: 'Skip',
              onTap: () {
                Nav.push(
                    context,
                    PrivecyLevelScreen(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      date: widget.date,
                      drink: widget.drink,
                      bio: bio.text,
                    ));
              })
        ]),
      ),
    );
  }
}
