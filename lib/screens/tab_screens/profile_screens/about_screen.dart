import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            settingsAppBar(context, 'About'),
            gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                accCard('Terms of Service', () {}),
                accCard('Privacy Policy', () {}),
                accCard('Cookie Policy', () {}),
              ]),
            )
          ]),
        ));
  }

  Widget accCard(String title, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: TextStyle(color: primaryTextColor, fontSize: 18)),
          Icon(Icons.keyboard_arrow_right, color: primaryTextColor)
        ]),
      ),
    );
  }
}
