import 'package:bar_monkey/screens/tab_screens/home_screens/deals_screen.dart';
import 'package:bar_monkey/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../home_screens/club_details.dart';

class storyBottomDialog extends StatelessWidget {

  final dynamic data;

  const storyBottomDialog(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Container(
          decoration: BoxDecoration(
              color: backgroundColor
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                gap(2),
                Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.all( Radius.circular(8.0)),
            border: Border.all(
                color: Colors.yellow,
                width: 3.0),
          ),
            child: Padding(
            padding: EdgeInsets.all(8),
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
                              image: data['_id']['host'] !=
                                  null
                                  ? DecorationImage(
                                  image: NetworkImage(
                                      userImageUrl +
                                          data['_id']['host'][0]
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
                                    data['_id']['host'][0] != null ? data['_id']['host'][0]['firstName'] +
                                        " ${ data['_id']['host'][0] != null ? data['_id']['host'][0]['lastName'] : "Last"}": "")!,
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 16)),
                          ])
                    ]),
                Text(data['_id']['host'][0] != null ? data['_id']['host'][0]['username'] : "username",
                    style:
                    TextStyle(color: primaryColor)),
              ],
            )),
          ),
                gap(28),
                InkWell(
                  onTap: () {
                    Nav.push(
                        context,
                        ClubDetailsScreen(
                            barDetails: data['barDetails']));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all( Radius.circular(0.0)),
                      border: Border.all(
                          color: Colors.yellow,
                          width: 2.0)),
                    child:
                    Stack(
                      children: [
                      Container(
                          height: 250,
                          decoration: BoxDecoration(
                              image: data['barDetails'] != null ? data['barDetails']
                              ['image'] ==
                                  null
                                  ? const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/BarImage.png'),
                                  fit: BoxFit.cover)
                                  : DecorationImage(
                                  image: NetworkImage(
                                      barImageUrl +
                                          data['barDetails']
                                          ['image']),
                                  fit: BoxFit.cover) :
                              const DecorationImage(
                              image: AssetImage(
                              'assets/images/BarImage.png'),
                      fit: BoxFit.cover))),
                      Positioned(
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                    Colors.black.withOpacity(.7),
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Text('Your Friend Here at ',
                                          style: TextStyle(
                                              color:
                                              primaryTextColor)),
                                      Text(
                                         DateFormat.Hm().format(DateTime.parse(data['stories'][data['stories'].length-1]['postedAt'])) ??
                                              '10:00 PM',
                                          style: TextStyle(
                                              color: primaryColor))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            gap(10),
                            Container(
                              width:
                              MediaQuery.of(context).size.width -
                                  0,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.7),
                                  borderRadius:
                                  const BorderRadius.only(
                                      topRight:
                                      Radius.circular(20),
                                      topLeft:
                                      Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(children: [
                                  Row(children: [
                                    Image.asset(
                                        'assets/icons/meet_icons/Bar Logo.png'),
                                    horGap(10),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['stories'] != null ?
                                          data['stories'][data['stories'].length-1]['bar'][0]
                                            ['name'] ??
                                                'Shiner Park' : 'Shiner Park',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 22)),
                                        Row(
                                          children: [
                                            Text( data['stories'] != null ? data['stories'][data['stories'].length-1]['bar'][0]['type'] ?? 'type' : 'Nightclub',
                                                style: TextStyle(
                                                    color:
                                                    primaryTextColor)),
                                            horGap(5),
                                            Container(
                                                height: 5,
                                                width: 5,
                                                decoration:
                                                const BoxDecoration(
                                                    color: Colors
                                                        .white,
                                                    shape: BoxShape
                                                        .circle)),
                                            horGap(5),
                                            Text('RnB, Pop',
                                                style: TextStyle(
                                                    color:
                                                    primaryTextColor)),
                                          ],
                                        ),
                                        gap(5),
                                        Text(  data['stories'] != null ? data['stories'][data['stories'].length-1]['bar'][0]['type'] ?? 'location' : '217 University Drive',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                color:
                                                primaryTextColor)),
                                      ],
                                    ),
                                  ]),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
              ],
    )
    )
    );
  }

}