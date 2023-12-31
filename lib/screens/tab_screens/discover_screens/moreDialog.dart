
import 'package:bar_monkey/screens/tab_screens/discover_screens/friendRequestsScreen.dart';
import 'package:bar_monkey/screens/tab_screens/discover_screens/yesMaybeNoCreatorScreen.dart';
import 'package:bar_monkey/screens/tab_screens/discover_screens/yesMaybeNoScreen.dart';
import 'package:bar_monkey/screens/tab_screens/home_screens/deals_screen.dart';
import 'package:bar_monkey/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';

class moreOptionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor
        ),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
      children: [
        gap(28),
        borderedWhiteButton(buttonName: "Friends Request", onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => friendRequestScreen()));
        }, width: MediaQuery.of(context).size.width - 20),
        gap(28),
        borderedWhiteButton(buttonName: "Yes Maybe No", onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => yesMaybeNoScreen()));
        }, width: MediaQuery.of(context).size.width - 20),
        gap(28),
        borderedWhiteButton(buttonName: "Deals", onTap: () {

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DealsScreen()));
        }, width: MediaQuery.of(context).size.width - 20),
        gap(28),
        borderedButton(buttonName: "Create Yes Maybe No", onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => yesMaybeNoCreatorScreen()));
        }, width: MediaQuery.of(context).size.width - 20),
      ],
    )));
  }

}