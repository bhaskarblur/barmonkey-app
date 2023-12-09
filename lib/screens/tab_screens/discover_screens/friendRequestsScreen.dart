
import 'package:bar_monkey/app_config/colors.dart';
import 'package:bar_monkey/providers/friend_provider.dart';
import 'package:bar_monkey/screens/tab_screens/discover_screens/yes_maybe_noTile.dart';
import 'package:bar_monkey/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../api_services.dart';
import '../../../app_config/app_details.dart';
import '../../../widget/navigator.dart';

class friendRequestScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => friendRequestScreenState();

}
class friendRequestScreenState extends State<friendRequestScreen> {

    final ApiServices _apiServices = ApiServices();

    getFriendRequests() {
      final provider = Provider.of<FriendProvider>(context, listen: false);
      _apiServices.get(context: context, endpoint: 'user/requests').then((value) {
        provider.clearFriendRequests();
        provider.changeFriendRequests(value['data']);
      });
    }

  @override
  void initState() {
    super.initState();
    getFriendRequests();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        children : [
          Text("Friend Requests",)
        ])),
      body: Consumer<FriendProvider>(builder: (context, provider, _) {
        return SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Yesterday", style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
                gap(18),
                Text("Friend request from someone near you",
                    style: TextStyle(
                        fontSize: 16,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w400)),
                gap(12),
                requestsList(context, provider.friendRequestsNearBy),
                gap(18),
                Text("Friend request from QR Scan",
                    style: TextStyle(
                        fontSize: 16,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w400)),
                gap(12),
                requestsList(context, provider.friendRequestsQrScan),
                gap(18),
                Text("Friend request from global search",
                    style: TextStyle(
                        fontSize: 16,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w400)),
                gap(12),
                requestsList(context, provider.friendRequestsSearch),
                gap(18),
                // Divider(thickness: 1, color: primaryTextColor),
                // gap(18),
                // Text("Last Week", style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
                // gap(18),
                // Text("Friend request from someone near you",
                //     style: TextStyle(
                //         fontSize: 16,
                //         color: primaryTextColor,
                //         fontWeight: FontWeight.w400)),
                // gap(12),
                // requestsList(context, provider.friendRequests),
                // gap(18),
                // Text("Friend request from QR Scan",
                //     style: TextStyle(
                //         fontSize: 16,
                //         color: primaryTextColor,
                //         fontWeight: FontWeight.w400)),
                // gap(12),
                // requestsList(context, provider.friendRequests),
                // gap(18),
                // Text("Friend request from global search",
                //     style: TextStyle(
                //         fontSize: 16,
                //         color: primaryTextColor,
                //         fontWeight: FontWeight.w400)),
                // gap(12),
                // requestsList(context, provider.friendRequests),
                gap(18),
        ])
    ));
      })
    );
  }

    Widget requestsList(BuildContext context, dynamic requestsList) {
      return SizedBox(
          height: requestsList !=null ? 50: 0,
          child: requestsList != null ? requestsList.length > 0 ? ListView.separated(
              scrollDirection: Axis.vertical,
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

}