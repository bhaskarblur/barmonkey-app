import '/app_config/app_details.dart';
import '/providers/friend_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../api_services.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    getFriendRequests();
    super.initState();
  }

  getFriendRequests() {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    _apiServices.get(context: context, endpoint: 'user/requests').then((value) {
      provider.clearFriendRequests();
      provider.changeFriendRequests(value['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer<FriendProvider>(builder: (context, provider, _) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                statusBar(context),
                Stack(children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Nav.pop(context);
                          },
                          child:
                              Icon(Icons.arrow_back, color: primaryTextColor)),
                    ],
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text('Notifications',
                          style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)))
                ]),
                gap(10),
                Text('Friend request from someone near you.',
                    style: TextStyle(color: primaryTextColor)),
                Expanded(
                  child: provider.friendRequests.length < 1
                      ? Center(
                          child: Text(
                          'No Notifications Yet!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: primaryTextColor),
                        ))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: provider.friendRequests.length,
                          separatorBuilder: (context, index) {
                            return gap(20);
                          },
                          itemBuilder: (context, index) {
                            var data = provider.friendRequests[index];
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
                          }),
                ),
              ]);
        }),
      ),
    );
  }
}
