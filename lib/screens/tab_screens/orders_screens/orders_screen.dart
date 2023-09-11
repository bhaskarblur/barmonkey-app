import '/providers/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text('Orders',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/home_icons/receipt_color.svg', height: 40, width: 40),
              gap(20),
              Text('Coming Soon!',
                  style: TextStyle(fontSize: 20, color: primaryTextColor)),
              gap(20),
              Text('Skip the wait, order with your phone',
                  style: TextStyle(fontSize: 14, color: primaryTextColor)),
              gap(30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 6),
                child: fullWidthButton(buttonName: 'View Bars', onTap: () {
                  final provider = Provider.of<HomeScreenProvider>(context, listen: false);
                  provider.changeSelectedIndex(2);
                }),

              )
            ]),
      ),
    );
  }
}
