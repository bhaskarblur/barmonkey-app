import 'package:bar_monkey/api_services.dart';
import 'package:bar_monkey/screens/authentication/register_screens/turnon_notification.dart';
import 'package:flutter/material.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class PrivecyLevelScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String date;
  final String drink;
  final String bio;

  const PrivecyLevelScreen(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.date,
      required this.drink,
      required this.bio});

  @override
  State<PrivecyLevelScreen> createState() => _PrivecyLevelScreenState();
}

class _PrivecyLevelScreenState extends State<PrivecyLevelScreen> {
  final ApiServices _apiServices = ApiServices();

  bool public = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Select your privacy level',
                  style: TextStyle(
                      fontSize: 18,
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold)),
              gap(10),
              Text(
                  'All users may be able to see your profile. Control what those who aren’t your friends can see.',
                  style: TextStyle(fontSize: 14, color: primaryTextColor)),
              gap(30),
              card(
                  'Public',
                  'Entire profile including your name, pictures, and liked bars will be visible to non-friends',
                  'assets/icons/earth.png',
                  public, () {
                setState(() {
                  public = true;
                });
              }),
              gap(30),
              card(
                  'Private',
                  'Hides full name, all pictures, your friends, and liked bars from non-friends',
                  'assets/icons/hand.png',
                  !public, () {
                setState(() {
                  public = false;
                });
              }),
              gap(30),
              fullWidthButton(
                  buttonName: 'Next',
                  onTap: () {
                    _apiServices
                        .patch(context: context, endpoint: 'user', body: {
                      "firstName": widget.firstName,
                      "lastName": widget.lastName,
                      "dob": widget.date,
                      "isPublic": public,
                      "favouriteDrink": widget.drink,
                      "bio": widget.bio
                    }).then((value) {
                      if (value['flag'] == true) {
                        Nav.push(context, const TurnonNotification());
                      } else {
                        dialog(context, value['error'] ?? value['message'], () {
                          Nav.pop(context);
                        });
                      }
                    });
                  })
            ]),
          ],
        ),
      ),
    );
  }
}
