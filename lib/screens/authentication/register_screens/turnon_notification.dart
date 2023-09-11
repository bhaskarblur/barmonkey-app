import 'package:bar_monkey/screens/authentication/register_screens/location_service.dart';
import 'package:flutter/material.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class TurnonNotification extends StatefulWidget {
  const TurnonNotification({super.key});

  @override
  State<TurnonNotification> createState() => _TurnonNotificationState();
}

class _TurnonNotificationState extends State<TurnonNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Text('Turn on notifications',
              style: TextStyle(
                  fontSize: 18,
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold)),
          gap(10),
          Text(
              'Find out when people request to be your friend, get notified on happy hours near you and more!',
              style: TextStyle(fontSize: 14, color: primaryTextColor),
              textAlign: TextAlign.center),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            fullWidthButton(
                buttonName: 'Turn On',
                onTap: () {
                  Nav.push(context, const LocationService());
                }),
            gap(20),
            borderedButton(
                buttonName: 'Skip',
                onTap: () {
                  Nav.push(context, const LocationService());
                })
          ],
        ),
      ),
    );
  }
}
