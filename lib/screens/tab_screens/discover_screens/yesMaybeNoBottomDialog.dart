import 'package:bar_monkey/screens/tab_screens/discover_screens/storyBottomDialog.dart';
import 'package:bar_monkey/screens/tab_screens/home_screens/deals_screen.dart';
import 'package:bar_monkey/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../home_screens/club_details.dart';

class yesMaybeNoBottomDialog extends StatefulWidget {
  final dynamic data;

  const yesMaybeNoBottomDialog(this.data, {super.key});

  @override
  State<yesMaybeNoBottomDialog> createState() => yesMaybeNoBottomDialogState();
}

class yesMaybeNoBottomDialogState extends State<yesMaybeNoBottomDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height - 80,
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(color: backgroundColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        gap(2),
                        Container(
                            decoration: BoxDecoration(
                              color: widget.data['eventColor'] != null
                                  ? Color(
                                  0xff + int.parse(widget.data['eventColor']))
                                  : Colors.blueAccent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                            ),
                            child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(children: [
                                              Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: widget
                                                          .data['user'] != null
                                                          ? DecorationImage(
                                                          image: NetworkImage(
                                                              userImageUrl +
                                                                  widget
                                                                      .data['user']
                                                                  ['image']),
                                                          fit: BoxFit.cover)
                                                          : const DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/profile_pic.png'),
                                                          fit: BoxFit.cover))),
                                              horGap(10),
                                              Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        toBeginningOfSentenceCase(
                                                            widget
                                                                .data['user'] !=
                                                                null
                                                                ? widget
                                                                .data['user']['firstName']
                                                                : "First" +
                                                                " ${widget
                                                                    .data['user'] !=
                                                                    null
                                                                    ? widget
                                                                    .data['user']['lastName']
                                                                    : "Last"} ")!,
                                                        style: TextStyle(
                                                            color: primaryTextColor,
                                                            fontSize: 16)),
                                                    gap(3),
                                                    Text(
                                                        widget.data['user'] !=
                                                            null
                                                            ? widget
                                                            .data['user']['username']
                                                            : "username",
                                                        style:
                                                        TextStyle(
                                                            color: primaryColor)),
                                                  ])
                                            ]),

                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                Icon(Icons.close,
                                                    color: primaryTextColor,
                                                    size: 32)
                                            )
                                          ]),
                                      const SizedBox(height: 8),
                                      InkWell(
                                          onTap: () {},
                                          child: Column(children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                  widget.data['eventColor'] !=
                                                      null
                                                      ? Color(0xff +
                                                      int.parse(widget
                                                          .data['eventColor']))
                                                      : Colors.blueAccent,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(8))),
                                              child: Padding(
                                                  padding: EdgeInsets.all(12),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        gap(2),
                                                        SizedBox(
                                                            width:
                                                            MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width -
                                                                20,
                                                            child: Expanded(
                                                                child: Text(
                                                                    widget
                                                                        .data['title']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 17,
                                                                        color:
                                                                        primaryTextColor,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600)))),
                                                        gap(14),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black54,
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                      Radius
                                                                          .circular(
                                                                          8))),
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .date_range,
                                                                      color:
                                                                      primaryColor,
                                                                    ),
                                                                    horGap(6),
                                                                    Text(
                                                                        widget
                                                                            .data[
                                                                        'date'] ??
                                                                            "Date",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            16,
                                                                            color:
                                                                            primaryTextColor,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w500))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            horGap(10),
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                    Colors
                                                                        .black54,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            8))),
                                                                child: Padding(
                                                                    padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                        8),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .watch_later_outlined,
                                                                          color:
                                                                          primaryColor,
                                                                        ),
                                                                        horGap(
                                                                            6),
                                                                        Text(
                                                                            widget
                                                                                .data[
                                                                            'time'] ??
                                                                                "time",
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                16,
                                                                                color:
                                                                                primaryTextColor,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w500))
                                                                      ],
                                                                    )))
                                                          ],
                                                        ),
                                                        gap(10),
                                                        Row(children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                                    Radius
                                                                        .circular(
                                                                        8))),
                                                            child: Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .location_on,
                                                                        color:
                                                                        primaryColor),
                                                                    horGap(6),
                                                                    Text(
                                                                        widget
                                                                            .data[
                                                                        'location'] ??
                                                                            "location",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            16,
                                                                            color:
                                                                            primaryTextColor,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w500))
                                                                  ],
                                                                )),
                                                          )
                                                        ]),
                                                        gap(20),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                                child: Row(
                                                                    children: [
                                                                      Icon(Icons
                                                                          .lock_outline,
                                                                          color: primaryColor),
                                                                      horGap(8),
                                                                      Text(
                                                                          widget
                                                                              .data[
                                                                          "privacy"] ??
                                                                              "Friends Only",
                                                                          style: TextStyle(
                                                                              color:
                                                                              primaryColor,
                                                                              fontSize: 16,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w500))
                                                                    ]))
                                                          ],
                                                        ),
                                                        gap(12),
                                                        Text(
                                                            widget.data[
                                                            'description'] ??
                                                                "Let’s celebrate my birthday together at my house before we go out for some drinks 🥂 View my liked bars to see where we could go afterwards :)",
                                                            style: TextStyle(
                                                                color: primaryTextColor,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 16))
                                                      ])),
                                            ),
                                            gap(8),
                                          ]))
                                    ],
                                  ),
                                ))),
                        SizedBox(
                            height: 480,
                            child:
                            DefaultTabController(
                              initialIndex: 0,
                              length: 3,
                              child: Scaffold(
                                  appBar: AppBar(
                                    automaticallyImplyLeading: false,
                                    backgroundColor: backgroundColor,
                                    title: TabBar(
                                        indicatorColor: primaryColor,
                                        tabs: <Widget>[
                                          Tab(
                                            text: '${widget
                                                .data['yesCount']} Yes',
                                          ),
                                          Tab(
                                            text: '${widget
                                                .data['maybeCount']} Maybe',
                                          ),
                                          Tab(
                                            text: '${widget
                                                .data['noCount']} No',
                                          ),
                                        ]),
                                  ),
                                  backgroundColor: backgroundColor,
                                  body:
                                  TabBarView(
                                    children: <Widget>[
                                      userNameList(context,[{},{},{},{},{},{},{},{},{},{}]),
                                      userNameList(context,[{},{},{},{},{},{},{},{},{},{}]),
                                      userNameList(context,[{},{},{},{},{},{},{},{},{},{}])
                                    ],
                                  )
                              ),
                            )
                        ),
                      ],
                    ))),
            floatingActionButton:
                Container(
                  color: backgroundColor,
                  child: Padding(
                padding: EdgeInsets.only(
                    left: 48, right: 18, bottom: 38, top: 6),
                child: SizedBox(
                  height: 88,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 78.0,
                        height: 78.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(50.0)),
                            border: Border.all(
                                color: primaryColor,
                                width: 3.0),
                            color: backgroundColor
                        ),
                        child:  InkWell(
                          onTap: () {
                          },
                          child:Icon(
                          Icons.thumb_up_off_alt_outlined, color: primaryColor,
                          size: 32))
                      ),
                      Container(
                        width: 78.0,
                        height: 78.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                              color: primaryTextColor,
                              width: 3.0),
                        ),
                        child: InkWell(
                          onTap: () {

                          },
                          child: Icon(
                            Icons.question_mark, color: primaryTextColor,
                            size: 32),
                      )),
                      Container(
                        width: 78.0,
                        height: 78.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                              color: primaryTextColor,
                              width: 3.0),
                        ),
                        child:  InkWell(
                          onTap: () {

                          },
                          child:Icon(Icons.thumb_down_off_alt_outlined,
                          color: primaryTextColor, size: 32,),
                      )),
                    ],
                  ),
                )))));
  }

  Widget userNameList(BuildContext context, dynamic list) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return gap(10);
        },
        scrollDirection : Axis.vertical,
        itemCount: list.length,
        itemBuilder: (context, index) {
          dynamic data = list[index];
         return Container(
            child: Padding(
                padding: EdgeInsets.only(left: 14, right: 14, top: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          SizedBox(
                              child: Container(
                                  height: 42,
                                  width: 42,
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
                                          fit: BoxFit.cover)))),
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
                              ])
                        ]),
                    Text(data['user'] != null ? data['user']['username'] : "username",
                        style:
                        TextStyle(color: primaryColor)),
                  ],
                )),
          );
        }
    );
  }
}
