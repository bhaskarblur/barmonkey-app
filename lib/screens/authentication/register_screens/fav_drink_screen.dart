import 'package:bar_monkey/screens/authentication/register_screens/add_bio_screen.dart';
import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class FavDrinkScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String date;

  const FavDrinkScreen(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.date});

  @override
  State<FavDrinkScreen> createState() => _FavDrinkScreenState();
}

class _FavDrinkScreenState extends State<FavDrinkScreen> {
  final TextEditingController drink = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('What’s your favorite drink?',
              style: TextStyle(
                  fontSize: 18,
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold)),
          gap(10),
          Text(
              'This will be a part of your profile and can be changed at any time. Know everyone’s drink of choice!',
              style: TextStyle(fontSize: 14, color: primaryTextColor)),
          gap(30),
          customTextField(drink, 'Favorite Drink'),
          gap(30),
          fullWidthButton(
              buttonName: 'Next',
              onTap: () {
                Nav.push(
                    context,
                     AddBio(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      date: widget.date,
                      drink: drink.text,
                    ));
              }),
          gap(20),
          borderedButton(
              buttonName: 'Skip',
              onTap: () {
                Nav.push(
                    context,
                     AddBio(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      date: widget.date,
                      drink: drink.text,
                    ));
              })
        ]),
      ),
    );
  }
}
