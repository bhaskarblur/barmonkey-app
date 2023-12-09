import 'dart:ffi';

import 'package:bar_monkey/screens/tab_screens/discover_screens/yesMaybeNoBottomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

Widget yesMaybeNoList(BuildContext context, dynamic storyList, int direction,
    int? height) {
  return SizedBox(
    height: height != null ? height.toDouble() : MediaQuery
        .of(context)
        .size
        .height,
    child: storyList != null
        ? storyList.length > 0
        ? ListView.separated(
      scrollDirection: direction == 0 ? Axis.horizontal : Axis.vertical,
      itemCount: storyList.length,
      separatorBuilder: (context, index) {
        return direction == 0 ? horGap(10) : gap(12);
      },
      itemBuilder: (context, index) {
        dynamic data = storyList[index];
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: data['host']["image"] !=
                                null
                                ? DecorationImage(
                                image: NetworkImage(
                                    userImageUrl +
                                        data['host']
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
                                  data['host'] != null
                                      ? data['host']['firstName']
                                      : "First" +
                                      " ${ data['host'] != null
                                          ? data['host']['lastName']
                                          : "Last" } "
                              )!,
                              style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 16)),
                          gap(3),
                          Text(data['host'] != null
                              ? data['host']['username']
                              : "username",
                              style:
                              TextStyle(color: primaryColor)),
                        ])
                  ]),
              const SizedBox(height: 12),
              InkWell(
                  onTap: () {
                    showBottomSheet(context: context,
                        builder: (_) => yesMaybeNoBottomDialog(data),
                        enableDrag: true);
                  },
                  child:
                  Container(
                    decoration: BoxDecoration(
                        color: data['theme'] != null ? data['theme'] == 0
                            ? Color(int.parse(
                            '4285F4'.substring(0, 6),
                            radix: 16) +
                            0xFF000000)
                            : data['theme'] == 1 ?  Color(int.parse(
                            'DB4437'.substring(0, 6),
                            radix: 16) +
                            0xFF000000) : data['theme'] == 2 ? Color(
                            int.parse(
                                '7B1FA2'.substring(0, 6),
                                radix: 16) +
                                0xFF000000) : data['theme'] == 3 ?
                         Color(int.parse(
                            '0F9D58'.substring(0, 6),
                            radix: 16) +
                            0xFF000000)
                            :  Color(int.parse(
                            '4285F4'.substring(0, 6),
                            radix: 16) +
                            0xFF000000) : Color(int.parse(
                            '4285F4'.substring(0, 6),
                            radix: 16) +
                            0xFF000000),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gap(2),
                              Text(data['title']
                                  .toString()
                                  .length > 36
                                  ?
                              data['title'].toString().substring(0, 36)
                                  : data['title'].toString(),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Icon(Icons.date_range,
                                            color: primaryColor,),
                                          horGap(6),
                                          Text(data['date'] ?? 'date',
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Icon(Icons.watch_later_outlined,
                                                color: primaryColor,),
                                              horGap(6),
                                              Text(data['time'] ?? 'time',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: primaryTextColor,
                                                      fontWeight: FontWeight
                                                          .w500))
                                            ],
                                          )
                                      )
                                  )
                                ],
                              ),
                              gap(10),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8))),
                                child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.location_on,
                                            color: primaryColor),
                                        horGap(6),
                                        Text(data['location'] ?? 'location',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    )),
                              ),
                              gap(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Container(
                                      child:
                                      Row(
                                          children: [
                                            Row(
                                                children: [
                                                  Icon(Icons
                                                      .thumb_up_off_alt_outlined,
                                                    color: primaryTextColor,
                                                    size: 22,),
                                                  horGap(6),
                                                  Text(data['totalPeople'] !=
                                                      null
                                                      ? data['totalPeople'] +
                                                      ' People Going'
                                                      : '20' + ' People Going',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: primaryTextColor,
                                                          fontWeight: FontWeight
                                                              .w500))
                                                ]),
                                            horGap(direction == 0 ? 150 : 165),
                                            Icon(data['privacy'] == "1" ? Icons
                                                .lock_outline : Icons
                                                .lock_open_rounded,
                                                color: primaryColor),
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
      child: Text('No Yes Maybe No Yet!',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 16)),
    )
        : Center(
      child: Text('No Yes Maybe No Yet!',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 16)),
    ),
  );
}
