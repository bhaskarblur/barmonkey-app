
import 'package:bar_monkey/screens/tab_screens/discover_screens/storyBottomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

Widget storyTileList(BuildContext context, dynamic storyList) {
  return SizedBox(
    height: 62,
    child: storyList != null ? storyList.length > 0
        ? ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: storyList.length,
      separatorBuilder: (context, index) {
        return horGap(10);
      },
      itemBuilder: (context, index) {
        dynamic data = storyList[index];
        return InkWell(
          onTap: () {
            showModalBottomSheet(context: context, builder: (_) => storyBottomDialog(storyList[index]));
          },
          child: Container(
            width: 62.0,
            height: 62.0,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: data['image'] == null
                  ? const DecorationImage(
                  image: AssetImage(
                      'assets/images/profile_pic.png'),
                  fit: BoxFit.cover) :
              DecorationImage(
                image: NetworkImage(userImageUrl + data['image']),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all( Radius.circular(50.0)),
              border: data['isViewed'] != null ?
              data['isViewed'] == false ? Border.all(
                color: Colors.yellow,
                width: 3.0,
              ) : Border.all() : Border.all(),
            ),
          ),
        );
      },
    )
        : Center(
      child: Text('No Stories',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 16)),
    ) :
    Center(
      child: Text('No Stories',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 16)),
    ),
  );
}