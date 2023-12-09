
import 'package:bar_monkey/screens/tab_screens/discover_screens/storyBottomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

Widget storyTileList(BuildContext context, dynamic storyList, void onPressed(int index)) {
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
        print('storylist');
        print(data);
        List<dynamic> story = data['stories'];
        return InkWell(
          onTap: () {
            showModalBottomSheet(context: context, builder: (_) => storyBottomDialog(storyList[index]));
            onPressed(index);
          },
          child: Container(
            width: 62.0,
            height: 62.0,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: data['_id']['host'][0]['image'] == null
                  ? const DecorationImage(
                  image: AssetImage(
                      'assets/images/profile_pic.png'),
                  fit: BoxFit.cover) :
              DecorationImage(
                image: NetworkImage(userImageUrl + data['_id']['host'][0]['image']),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all( Radius.circular(50.0)),
              border: story[story.length-1]['seen'] != null ?
              story[story.length-1]['seen'] == false ? Border.all(
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