import '/api_services.dart';
import '/app_config/app_details.dart';
import '/widget/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class NearbyUserScreen extends StatefulWidget {
  final dynamic userDetails;
  final dynamic barDetails;
  final String source;
  const NearbyUserScreen({super.key, this.userDetails, this.barDetails, required this.source});

  @override
  State<NearbyUserScreen> createState() => _NearbyUserScreenState();
}

class _NearbyUserScreenState extends State<NearbyUserScreen> {
  final ApiServices _apiServices = ApiServices();

  dynamic userDetails;

  @override
  void initState() {
    _apiServices
        .get(
            context: context,
            endpoint: 'user/profile/${widget.userDetails['_id']}')
        .then((value) {
      if (value['flag'] == true) {
        userDetails = value['data'];
        setState(() {});
      } else {
        dialog(context, value['error'] ?? value['message'], () {
          Nav.pop(context);
        });
      }
    });

    addViewToUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: userDetails == null
              ? gap(10)
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  statusBar(context),
                  Text('Meet',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor)),
                  InkWell(
                    onTap: () {
                      Nav.pop(context);
                    },
                    child: Row(
                      children: [
                        Text('People near  ',
                            style: TextStyle(color: primaryTextColor)),
                        Text(widget.barDetails['name'],
                            style: TextStyle(color: primaryColor)),
                        Icon(Icons.keyboard_arrow_down, color: primaryColor)
                      ],
                    ),
                  ),
                  gap(30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Nav.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(children: [
                                  Icon(Icons.keyboard_arrow_left,
                                      color: primaryTextColor, size: 16),
                                  horGap(5),
                                  Text('Gallery View',
                                      style: TextStyle(color: primaryTextColor))
                                ]),
                              ),
                            ),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(children: [
                                SvgPicture.asset(
                                    'assets/icons/meet_icons/drinks.svg'),
                                horGap(3),
                                Text('Fav Drink',
                                    style: TextStyle(color: primaryColor))
                              ]),
                              gap(3),
                              Text(userDetails['favouriteDrink'],
                                  style: TextStyle(
                                      color: primaryTextColor, fontSize: 16))
                            ]),
                      ]),
                  gap(20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: userDetails['image'] == null
                                    ? const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/formal_pic.png'))
                                    : DecorationImage(
                                        image: NetworkImage(userImageUrl +
                                            userDetails['image']))),
                          ),
                          horGap(10),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    toBeginningOfSentenceCase(
                                        userDetails['firstName'] +
                                            ' ' +
                                            userDetails['lastName'])!,
                                    style: TextStyle(
                                        color: primaryTextColor, fontSize: 16)),
                                gap(5),
                                Text(userDetails['username'],
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 16)),
                              ])
                        ]),
                        Row(children: [
                          Icon(FontAwesomeIcons.instagram,
                              color: primaryTextColor, size: 30),
                          horGap(30),
                          Icon(FontAwesomeIcons.twitter,
                              color: primaryTextColor, size: 30),
                        ]),
                      ]),
                  gap(20),
                  SizedBox(
                    height: 250,
                    child: userDetails['posts'].length < 1
                        ? Center(
                            child: Text(
                              'No Image Found',
                              style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: userDetails['posts'].length,
                            separatorBuilder: (context, index) {
                              return horGap(20);
                            },
                            itemBuilder: (context, index) {
                              return SizedBox(
                                  height: 250,
                                  child: Image.network(
                                      postImageUrl +
                                          userDetails['posts'][index]['image'],
                                      fit: BoxFit.cover));
                            },
                          ),
                  ),
                  gap(20),
                  Center(
                      child: Text(userDetails['bio'],
                          style:
                              TextStyle(color: primaryTextColor, fontSize: 16),
                          textAlign: TextAlign.center)),
                  gap(50),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 6),
                    child: borderedButton(
                        buttonName: 'Send Friend Request',
                        onTap: () {
                          _apiServices.post(
                              context: context,
                              endpoint: 'user/send-request',
                              body: {
                                "userId": userDetails['_id'],
                                "source": widget.source
                              }).then((value) {
                            dialog(context, value['message'] ?? value['data'],
                                () {
                              Nav.pop(context);
                            });
                          });
                        }),
                  ),
                ]),
        ));
  }

  addViewToUser() {
    _apiServices
        .post(context: context, endpoint: 'user/view'
        , body: {
          "userId":widget.userDetails['_id']
        })
        .then((value) {
      print(value);

    });
  }
}
