import 'package:bar_monkey/screens/tab_screens/discover_screens/storyTile.dart';

import '../../../providers/friend_provider.dart';
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

  getFriendStories() {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    _apiServices.get(context: context, endpoint: 'user/stories').then((value) {
      provider.clearFriendStories();
      provider.changefriendsStories(value['data']);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<FriendProvider>(builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
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
                              },
                              icon: Icon(Icons.keyboard_arrow_down_sharp,
                                  color: primaryTextColor, size: 32))
                        ],
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 14,
                              ),
                              storyTileList(context,provider.friendsStories),
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
                            ]),
                      ),
                    ],
                  ),
          );
        }));
  }

  Widget requestsList(BuildContext context, dynamic requestsList) {
    return SizedBox(
      height: requestsList !=null ? 50: 0,
        child: ListView.separated(
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
        }));
  }
}
