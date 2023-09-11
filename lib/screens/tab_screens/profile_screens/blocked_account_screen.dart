import '/api_services.dart';
import '/screens/tab_screens/profile_screens/all_friends_screen.dart';
import '/widget/navigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class BlockedAccountScreen extends StatefulWidget {
  const BlockedAccountScreen({super.key});

  @override
  State<BlockedAccountScreen> createState() => _BlockedAccountScreenState();
}

class _BlockedAccountScreenState extends State<BlockedAccountScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  dynamic blockedAccounts;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          settingsAppBar(context, 'Blocked Account',
              actionButton: InkWell(
                onTap: () {
                  Nav.push(context, const FriendsScreen());
                },
                child: Icon(Icons.add, color: primaryColor, size: 28),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Container(
                  color: Colors.white,
                  child: TextFormField(
                    controller: _search,
                    style: TextStyle(color: primaryTextColor),
                    decoration: InputDecoration(
                      hintText: 'Search for blocked account',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.black,
                      prefixIcon: Icon(Icons.search, color: primaryTextColor),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_rounded,
                            color: primaryTextColor),
                      ),
                      border: InputBorder.none,
                    ),
                    onEditingComplete: () {},
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: blockedAccounts == null
                      ? gap(0)
                      : blockedAccounts.length < 1
                          ? Center(
                              child: Text('There are no blocked accounts.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: primaryTextColor)))
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: blockedAccounts.length,
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: blockedAccounts[index]
                                                    ['image'] ==
                                                null
                                            ? const BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/formal_pic.png')))
                                            : BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        blockedAccounts[index]
                                                            ['image']))),
                                      ),
                                      horGap(20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              toBeginningOfSentenceCase(
                                                  blockedAccounts[index]
                                                          ['firstName'] +
                                                      ' ' +
                                                      blockedAccounts[index]
                                                          ['lastName'])!,
                                              style: TextStyle(
                                                  color: primaryTextColor)),
                                          Text(
                                              blockedAccounts[index]
                                                  ['username'],
                                              style: TextStyle(
                                                  color: primaryColor))
                                        ],
                                      ),
                                    ]),
                                    InkWell(
                                      onTap: () {
                                        _apiServices.post(
                                            context: context,
                                            endpoint: 'user/block',
                                            body: {
                                              "userId": blockedAccounts[index]
                                                  ['_id'],
                                              "action": "1"
                                            }).then((value) {
                                          if (value['flag']) {
                                            getData();
                                          } else {
                                            dialog(
                                                context,
                                                value['message'] ??
                                                    value['error'], () {
                                              Nav.pop(context);
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: primaryColor),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Unblock',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )),
                                    )
                                  ],
                                );
                              },
                            ),
                ),
              ]),
            ),
          ),
        ]));
  }

  getData() {
    _apiServices.get(context: context, endpoint: 'user/block').then((value) {
      if (value['flag']) {
        blockedAccounts = value['data'];
      } else {
        dialog(context, value['message'] ?? value['error'], () {
          Nav.pop(context);
        });
      }
    });
  }
}
