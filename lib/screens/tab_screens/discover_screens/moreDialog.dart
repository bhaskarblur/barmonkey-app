
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
        }, width: MediaQuery.of(context).size.width - 20),
        gap(28),
        borderedWhiteButton(buttonName: "Yes Maybe No", onTap: () {
        }, width: MediaQuery.of(context).size.width - 20),
        gap(28),
        borderedWhiteButton(buttonName: "Deals", onTap: () {

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DealsScreen()));
        }, width: MediaQuery.of(context).size.width - 20),
        gap(28),
        borderedButton(buttonName: "Create Yes Maybe No", onTap: () {
        }, width: MediaQuery.of(context).size.width - 20),
      ],
    )));
  }

}