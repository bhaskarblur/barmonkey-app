import 'dart:math';

import 'package:bar_monkey/api_services.dart';
import 'package:bar_monkey/app_config/colors.dart';
import 'package:bar_monkey/providers/friend_provider.dart';
import 'package:bar_monkey/screens/tab_screens/discover_screens/yes_maybe_noTile.dart';
import 'package:bar_monkey/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../widget/sahared_prefs.dart';

class yesMaybeNoCreatorScreen extends StatefulWidget {
  @override
  State<yesMaybeNoCreatorScreen> createState() =>
      yesMaybeNoCreatorScreenState();
}

class yesMaybeNoCreatorScreenState extends State<yesMaybeNoCreatorScreen> {
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  var privacy = "0";
  var themeColor = "0";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        dateController.text = picked.month.toString() +
            '-' +
            picked.day.toString() +
            '-' +
            picked.year.toString();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
    if (picked != null) {
      setState(() {
        timeController.text = picked.hour.toString() +
            ':' +
            picked.minute.toString() +
            " " +
            picked.period.name.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            backgroundColor: backgroundColor,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Yes Maybe No Creator",
                      style: TextStyle(color: primaryColor))
                ])),
        body: Consumer<FriendProvider>(builder: (context, provider, _) {
          return SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Title",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            gap(8),
                            TextField(
                              controller: titleController,
                              style: TextStyle(color: primaryTextColor),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: primaryTextColor),
                                hintText: 'Enter yes maybe no question',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                            )
                          ]),
                      gap(18),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            gap(8),
                            TextField(
                              controller: descriptionController,
                              style: TextStyle(color: primaryTextColor),
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: primaryTextColor),
                                hintText:
                                    'State your plans, describe your question, etc.',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                            )
                          ]),
                      gap(18),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Location",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            gap(8),
                            TextField(
                              controller: locationController,
                              style: TextStyle(color: primaryTextColor),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: primaryTextColor),
                                hintText:
                                    'Type the address or name of the place ',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryTextColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                            )
                          ]),
                      gap(18),
                      Row(children: [
                        SizedBox(
                            width: 142,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Date",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  gap(8),
                                  TextField(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    readOnly: true,
                                    controller: dateController,
                                    style: TextStyle(color: primaryTextColor),
                                    decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(color: primaryTextColor),
                                      hintText: 'MM - DD - YYYY',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryTextColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryTextColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryTextColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    ),
                                  )
                                ])),
                        horGap(18),
                        SizedBox(
                            width: 142,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Time",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  gap(8),
                                  TextField(
                                    onTap: () {
                                      _selectTime(context);
                                    },
                                    readOnly: true,
                                    controller: timeController,
                                    style: TextStyle(color: primaryTextColor),
                                    decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(color: primaryTextColor),
                                      hintText: 'HH:MM  PM/AM',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryTextColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryTextColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryTextColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    ),
                                  )
                                ])),
                      ]),
                      gap(18),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Privacy",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            gap(8),
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xf232428),
                                        border: Border.all(
                                            color: privacy == "0"
                                                ? primaryColor
                                                : primaryTextColor),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            privacy = "0";
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Row(children: [
                                              Icon(Icons.lock_outline,
                                                  color: primaryTextColor),
                                              horGap(8),
                                              Text("Friends only",
                                                  style: TextStyle(
                                                      color: primaryTextColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ])))),
                                horGap(18),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xf232428),
                                        border: Border.all(
                                            color: privacy == "1"
                                                ? primaryColor
                                                : primaryTextColor),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            privacy = "1";
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Row(children: [
                                              Icon(Icons.lock_open_rounded,
                                                  color: primaryTextColor),
                                              horGap(8),
                                              Text("Friends and mutuals",
                                                  style: TextStyle(
                                                      color: primaryTextColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ]))))
                              ],
                            ),
                          ]),
                      gap(18),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Theme",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            gap(8),
                            Row(children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    themeColor = "0";
                                  });
                                },
                                child: Container(
                                    width: 42.0,
                                    height: 42.0,
                                    decoration: BoxDecoration(
                                        color: new Color(int.parse(
                                                '4285F4'.substring(0, 6),
                                                radix: 16) +
                                            0xFF000000),
                                        border: Border.all(
                                            color: themeColor == "0"
                                                ? primaryColor
                                                : backgroundColor),
                                        borderRadius:
                                            BorderRadius.circular(60))),
                              ),
                              horGap(18),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      themeColor = "1";
                                    });
                                  },
                                  child: Container(
                                      width: 42.0,
                                      height: 42.0,
                                      decoration: BoxDecoration(
                                          color: new Color(int.parse(
                                                  'DB4437'.substring(0, 6),
                                                  radix: 16) +
                                              0xFF000000),
                                          border: Border.all(
                                              color: themeColor == "1"
                                                  ? primaryColor
                                                  : backgroundColor),
                                          borderRadius:
                                              BorderRadius.circular(60)))),
                              horGap(18),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      themeColor = "2";
                                    });
                                  },
                                  child: Container(
                                      width: 42.0,
                                      height: 42.0,
                                      decoration: BoxDecoration(
                                          color: new Color(int.parse(
                                                  '7B1FA2'.substring(0, 6),
                                                  radix: 16) +
                                              0xFF000000),
                                          border: Border.all(
                                              color: themeColor == "2"
                                                  ? primaryColor
                                                  : backgroundColor),
                                          borderRadius:
                                              BorderRadius.circular(60)))),
                              horGap(18),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      themeColor = "3";
                                    });
                                  },
                                  child: Container(
                                      width: 42.0,
                                      height: 42.0,
                                      decoration: BoxDecoration(
                                          color: new Color(int.parse(
                                                  '0F9D58'.substring(0, 6),
                                                  radix: 16) +
                                              0xFF000000),
                                          border: Border.all(
                                              color: themeColor == "3"
                                                  ? primaryColor
                                                  : backgroundColor),
                                          borderRadius:
                                              BorderRadius.circular(60)))),
                            ])
                          ]),
                      gap(36),
                      fullWidthButton(
                          buttonName: "Create question",
                          onTap: () async {
                            if (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty &&
                                locationController.text.isNotEmpty &&
                                dateController.text.isNotEmpty &&
                                timeController.text.isNotEmpty) {

                                ApiServices().post(
                                    context: context,
                                    endpoint: 'user/event',
                                    body: {
                                      "title": titleController.text,
                                      "location": locationController.text,
                                      "description": descriptionController.text,
                                      "date": dateController.text,
                                      "time": timeController.text,
                                      "privacy": privacy,
                                      "theme": themeColor,
                                    }).then((value) {
                                      print(value);
                                      if(value['flag'] == true) {
                                        Fluttertoast.showToast(msg: "Yes maybe no created!");
                                        Navigator.pop(context);
                                      }
                                      else {
                                        Fluttertoast.showToast(msg: "Error creating yes maybe no!");
                                      }
                                });
                            }
                          }),
                      gap(12),
                    ],
                  )));
        }));
  }
}
