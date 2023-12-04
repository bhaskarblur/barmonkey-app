import 'dart:ffi';

import 'package:bar_monkey/screens/tab_screens/discover_screens/yesMaybeNoBottomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

Widget yesMaybeNoList(BuildContext context, dynamic storyList) {
  return SizedBox(
    height: 270,
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
                  return Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children : [
                      Row(
                          children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: data['user'] !=
                                    null
                                    ? DecorationImage(
                                    image: NetworkImage(
                                        userImageUrl +
                                            data['user']
                                            ['image']),
                                    fit: BoxFit.cover)
                                    : const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/profile_pic.png'),
                                    fit: BoxFit.cover))),
                        horGap(10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  toBeginningOfSentenceCase(
                                      data['user'] != null ? data['user']['firstName'] :  "First" +
                                          " ${ data['user'] != null ? data['user']['lastName'] : "Last" } "
                                  )!,
                                  style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 16)),
                              gap(3),
                              Text(data['user'] != null ? data['user']['username'] : "username",
                                  style:
                                  TextStyle(color: primaryColor)),
                            ])
                      ]),
                    const SizedBox(height: 12),
                  InkWell(
                  onTap: () {
                    showModalBottomSheet(context: context, builder: (_) => yesMaybeNoBottomDialog({}));
                  },
                  child:
                    Container(
                      decoration: BoxDecoration(
                          color: data['eventColor'] != null ? Color(0xff + int.parse(data['eventColor'])) : Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gap(2),
                            Text( data['title'].toString().length > 36 ?
                                data['title'].toString().substring(0,36) : data['title'].toString(),
                                style: TextStyle(
                                    fontSize: 17,
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w600)),
                            gap(14),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.all(Radius.circular(8))),
                                 child: Padding(
                                   padding: EdgeInsets.all(8),
                                   child: Row(
                                     children: [
                                       Icon(Icons.date_range, color: primaryColor,),
                                       horGap(6),
                                       Text(data['date'],
                                           style: TextStyle(
                                               fontSize: 16,
                                               color: primaryTextColor,
                                               fontWeight: FontWeight.w500))
                                     ],
                                   ),
                                 ),
                                ),
                                horGap(10),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child: Padding(
                                      padding: EdgeInsets.all(8),
                                    child: Row(
                                    children: [
                                      Icon(Icons.watch_later_outlined, color: primaryColor,),
                                      horGap(6),
                                      Text(data['time'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: primaryTextColor,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  )
                                )
                              )],
                            ),
                            gap(10),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.all(Radius.circular(8))),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                  Icon(Icons.location_on, color: primaryColor),
                                  horGap(6),
                                  Text(data['location'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: primaryTextColor,
                                          fontWeight: FontWeight.w500))
                                ],
                              )),
                            ),
                            gap(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Container(
                              child:
                              Row(
                                children : [
                              Row(
                                children: [
                                  Icon(Icons.thumb_up_off_alt_outlined, color: primaryTextColor, size: 22,),
                                  horGap(6),
                                  Text(data['totalPeople'] + ' People Going',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: primaryTextColor,
                                          fontWeight: FontWeight.w500))
                                ]),
                              horGap(150),
                              Icon(Icons.lock_outline, color: primaryColor),
                              ])
                                )
                              ],
                            )
                          ])),
                    ))
                  ]);
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
