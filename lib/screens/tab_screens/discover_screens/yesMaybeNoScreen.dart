
import 'package:bar_monkey/app_config/colors.dart';
import 'package:bar_monkey/providers/friend_provider.dart';
import 'package:bar_monkey/screens/tab_screens/discover_screens/yes_maybe_noTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class yesMaybeNoScreen extends StatelessWidget {

  getData() {
  }

  yesMaybeNoScreen() {
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        children : [
          Text("Yes Maybe No",)
        ])),
      body: Consumer<FriendProvider>(builder: (context, provider, _) {
        return Container(
    child: Padding(
      padding: EdgeInsets.all(16),
            child: yesMaybeNoList(context, provider.yesNoEvents, 1, null )
    ));
      })
    );
  }
}