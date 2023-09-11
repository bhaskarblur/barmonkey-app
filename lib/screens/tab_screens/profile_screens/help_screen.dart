import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          settingsAppBar(context, 'Help'),
          gap(50),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Contact Information',
                          style: TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22)),
                      gap(30),
                      Text('Send us an e-mail to get in touch!',
                          style:
                              TextStyle(color: primaryTextColor, fontSize: 16)),
                      gap(30),
                      Icon(Icons.email, color: primaryTextColor, size: 40),
                      gap(10),
                      Text('info@barmonkey.io',
                          style:
                              TextStyle(color: primaryTextColor, fontSize: 16)),
                      gap(30),
                      Icon(Icons.location_on,
                          color: primaryTextColor, size: 40),
                      gap(10),
                      Text(
                          '10555 Independence Pkwy Frisco, Texas 75035 United States',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: primaryTextColor, fontSize: 16)),
                    ]),
              )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        socialMediaButton(FontAwesomeIcons.twitter),
        horGap(20),
        socialMediaButton(FontAwesomeIcons.instagram),
        horGap(20),
        // socialMediaButton(FontAwesomeIcons.discord),
        Container(
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.black87),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 15, right: 20),
              child: Icon(FontAwesomeIcons.discord, color: primaryTextColor),
            ),
          ),
        )
      ]),
    );
  }

  Widget socialMediaButton(IconData icon) {
    return Container(
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Icon(icon, color: primaryTextColor),
        ),
      ),
    );
  }
}
