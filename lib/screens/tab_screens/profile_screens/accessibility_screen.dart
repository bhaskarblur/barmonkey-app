import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            settingsAppBar(context, 'Accessibility'),
            gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                accCard('Language', () {}),
                gap(30),
                accCard('Motion', () {}),
                gap(30),
                accCard('Display Mode', () {}),
              ]),
            ),
          ]),
        ));
  }

  Widget accCard(String title, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black87, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: TextStyle(color: primaryTextColor, fontSize: 18)),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: primaryTextColor,
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
