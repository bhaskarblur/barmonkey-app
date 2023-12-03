import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

Widget yesMaybeNoList(BuildContext context, dynamic storyList) {
  return SizedBox(
    height: 62,
    child: storyList != null
        ? storyList.length > 0
            ? ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: storyList.length,
                separatorBuilder: (context, index) {
                  return horGap(10);
                },
                itemBuilder: (context, index) {
                  dynamic data = storyList[index];
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(children: [
                            
                          ])),
                    ),
                  );
                },
              )
            : Center(
                child: Text('No Yes Maybe No Found',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 16)),
              )
        : Center(
            child: Text('No Yes Maybe No Found',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 16)),
          ),
  );
}
