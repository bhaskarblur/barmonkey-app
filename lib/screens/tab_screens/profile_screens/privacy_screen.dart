import '/api_services.dart';
import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final ApiServices _apiServices = ApiServices();

  bool public = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          settingsAppBar(context, 'Privacy'),
          gap(30),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select your privacy level',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.bold)),
                          gap(10),
                          Text(
                              'All users may be able to see your profile. Control what those who aren’t your friends can see.',
                              style: TextStyle(
                                  fontSize: 14, color: primaryTextColor)),
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
                              buttonName: 'Save Changes',
                              onTap: () {
                                _apiServices.patch(
                                    context: context,
                                    endpoint: 'user',
                                    body: {"isPublic": public}).then((value) {
                                  dialog(context,
                                      value['message'] ?? value['error'], () {
                                    Nav.pop(context);
                                  });
                                });
                              })
                        ]),
                  ])),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [gap(0)]),
            Text('To learn more about our privacy policy, please ',
                style: TextStyle(color: primaryTextColor)),
            Text('Click Here',
                style: TextStyle(
                    color: primaryColor, decoration: TextDecoration.underline)),
          ],
        ),
      ),
    );
  }
}
