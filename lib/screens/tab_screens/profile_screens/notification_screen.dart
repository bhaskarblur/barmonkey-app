import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool push = false;
  bool sms = false;
  bool email = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            settingsAppBar(context, 'Notification'),
            gap(30),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      notificationTile('Push Notification', push, 1),
                      gap(30),
                      notificationTile('SMS Notification', sms, 2),
                      gap(30),
                      notificationTile('Email Notification', email, 3),
                      gap(30),
                    ])),
          ],
        ));
  }

  Container notificationTile(String title, bool selectedValue, int intValue) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(color: primaryTextColor, fontSize: 18)),
              CupertinoSwitch(
                  activeColor: primaryColor,
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      if (intValue == 1) {
                        push = value;
                      } else if (intValue == 2) {
                        sms = value;
                      } else if (intValue == 3) {
                        email = value;
                      }
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
