import 'dart:ffi';

import 'package:bar_monkey/screens/tab_screens/discover_screens/storyTile.dart';
import 'package:bar_monkey/screens/tab_screens/discover_screens/yes_maybe_noTile.dart';
import 'package:flutter/cupertino.dart';

import '../../../providers/friend_provider.dart';
import '../home_screens/club_details.dart';
import '/providers/bars_provider.dart';
import '/providers/home_screen_provider.dart';
import '/providers/profile_provider.dart';
import '/screens/tab_screens/meet_screens/nearby_user_screen.dart';
import '/widget/navigator.dart';
import '/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../api_services.dart';
import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../profile_screens/privacy_screen.dart';
import 'moreDialog.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  bool data = false;

  dynamic selectedBar;

  getFriendRequests() {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    _apiServices.get(context: context, endpoint: 'user/requests').then((value) {
      provider.clearFriendRequests();
      provider.changeFriendRequests(value['data']);
    });
  }

  getDeals() {
    final provider = Provider.of<BarsProvider>(context, listen: false);

    _apiServices.get(context: context, endpoint: 'bar/deals').then((value) {
      if (value['flag'] == true) {
        provider.clearDealBars();
        provider.addToDealBarList(value['data']);
      } else {
        dialog(context, value['message'] ?? value['error'], () {
          Nav.pop(context);
        });
      }
    });
  }

  getFriendStories() {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    _apiServices.get(context: context, endpoint: 'user/stories').then((value) {
      provider.clearFriendStories();
      provider.changefriendsStories(value['data']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeals();
    getFriendRequests();
    getFriendStories();
  }

  bool openBottomSheet = false;
  var controller_ = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<FriendProvider>(builder: (context, provider, _) {
          return Consumer<BarsProvider>(builder: (context, provider2, _) {
           return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
            Column(
                    children: [
                      statusBar(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Discover',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor)),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(context: context, builder: (_) => moreOptionsDialog());
                              },
                              icon: Icon(Icons.keyboard_arrow_down_sharp,
                                  color: primaryTextColor, size: 32))
                        ],
                      ),
                      Expanded(
                        child:  SingleChildScrollView(
                          controller: controller_,
                          scrollDirection: Axis.vertical,
                          child:
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 14,
                              ),
                              storyTileList(context,[{},{}]),
                              gap(14),
                              Text("Friend request from someone near you",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w400)),
                              gap(14),
                              requestsList(context, provider.friendRequests),
                              gap(14),
                              Text("Yes Maybe No",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: primaryTextColor,
                                      fontWeight: FontWeight.w600)),
                              gap(14),
                              yesMaybeNoList(context, [{"title":"Come home to me i am playing", "location": "Georgia", "time" :"9:00",
                                "date" : "12 Aug, 2023", "totalPeople": "12" }, {"title":"Come home to me i am playing", "location": "Georgia", "time" :"9:00",
                                "date" : "12 Aug, 2023", "totalPeople": "12" }], 0, 270),
                              gap(14),
                              Text("Deals",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: primaryTextColor,
                                      fontWeight: FontWeight.w400)),
                              gap(14),
                              provider2.dealBars.length > 0 ?
                              dealsList(context, provider2.dealBars) :
                                  Text("")
                            ])),


                      ),
                    ],
                  ),
          );
          });
        }),);
  }

  Widget requestsList(BuildContext context, dynamic requestsList) {
    return SizedBox(
      height: requestsList !=null ? 50: 0,
        child: requestsList != null ? requestsList.length > 0 ? ListView.separated(
      scrollDirection: Axis.horizontal,
        itemCount: requestsList !=null ? requestsList.length : 0,
        separatorBuilder: (context, index) {
          return gap(10);
        },
        itemBuilder: (context, index) {
          var data = requestsList[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: data['requestor']['image'] !=
                            null
                            ? DecorationImage(
                            image: NetworkImage(
                                userImageUrl +
                                    data['requestor']
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
                              data['requestor']['firstName'] +
                                  ' ' +
                                  data['requestor']
                                  ['lastName'])!,
                          style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 16)),
                      gap(3),
                      Text(data['requestor']['username'],
                          style:
                          TextStyle(color: primaryColor)),
                    ])
              ]),
              Row(children: [
                InkWell(
                  onTap: () {
                    _apiServices.post(
                        context: context,
                        endpoint: 'user/accept-request',
                        body: {
                          "userId": data['requestor']['_id']
                        }).then((value) {
                      getFriendRequests();
                      dialog(context,
                          value['message'] ?? value['error'],
                              () {
                            Nav.pop(context);
                          });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Accept',
                            style: TextStyle(
                                color: Colors.green))),
                  ),
                ),
                horGap(5),
                InkWell(
                  onTap: () {
                    _apiServices.post(
                        context: context,
                        endpoint: 'user/reject-request',
                        body: {
                          "userId": data['requestor']['_id']
                        }).then((value) {
                      getFriendRequests();
                      dialog(context,
                          value['message'] ?? value['error'],
                              () {
                            Nav.pop(context);
                          });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Reject',
                            style: TextStyle(
                                color: Colors.red))),
                  ),
                ),
              ]),
            ],
          );
        })
        : Center(
        child: Text("No friend requests",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: 16)),
    ) :
         Center(
        child: Text('No friend requests',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: 16)),
    ));}

  Widget dealsList(BuildContext context, dynamic dealsList) {
    return SizedBox(
        height: dealsList !=null ? 200: 0,
        child:  ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: dealsList.length,
          separatorBuilder: (context, index) {
            return gap(20);
          },
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Nav.push(
                    context,
                    ClubDetailsScreen(
                        barDetails: dealsList[index]));
              },
              child: Stack(
                children: [
                  Container(
                      height: 250,
                      decoration: BoxDecoration(
                          image: dealsList[index]
                          ['image'] ==
                              null
                              ? const DecorationImage(
                              image: AssetImage(
                                  'assets/images/BarImage.png'),
                              fit: BoxFit.cover)
                              : DecorationImage(
                              image: NetworkImage(
                                  barImageUrl +
                                      dealsList[index]
                                      ['image']),
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
                                  Text('Happy hour: ',
                                      style: TextStyle(
                                          color:
                                          primaryTextColor)),
                                  Text(
                                      dealsList[index]
                                      ['happyHours'] ??
                                          '',
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
                              20,
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
                                        dealsList[index]
                                        ['name'] ??
                                            '',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 22)),
                                    Row(
                                      children: [
                                        Text('Nightclub',
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
                                    Text('217 University Drive',
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
            );
          },
        ));
  }
}
