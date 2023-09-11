import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '/api_services.dart';
import '/app_config/app_details.dart';
import '/providers/friend_provider.dart';
import '/providers/profile_provider.dart';
import '/screens/tab_screens/profile_screens/friends_profile_screen.dart';
import '/widget/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';
import 'notification_screen.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with TickerProviderStateMixin {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  TabController? _tabController;

  Barcode? result;

  bool camera = false;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController!.addListener(_handleTabSelection);

    getFriends();
    getFriendRequests();

    getFriendsByContacts();

    super.initState();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  getFriends() {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    _apiServices
        .get(context: context, endpoint: 'user/friend-list')
        .then((value) {
      provider.clearAllFriends();
      provider.changeAllFriends(value['data']);
    });
  }

  getFriendRequests() {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    _apiServices
        .get(context: context, endpoint: 'user/requests', progressBar: false)
        .then((value) {
      provider.clearFriendRequests();
      provider.changeFriendRequests(value['data']);
    });
  }

  getFriendsByContacts() async {
    List<String> _numbers = [];

    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus == PermissionStatus.granted) {
      var contacts = await ContactsService.getContacts();

      contacts.forEach((element) {
        print(element.phones![0].value);
        _numbers.add(element.phones![0].value!);
      });
      print("Contact List " + contacts.toList().toString());
    } else {
      print("Contact List: Permission denied ");
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to location data denied',
        details: null,
      );
    }

    final profileProvider = Provider.of<FriendProvider>(context, listen: false);

    // ignore: use_build_context_synchronously
    _apiServices
        .post(
            context: context,
            endpoint: 'user/contact-match',
            body: {"numbers": _numbers},
            progressBar: false)
        .then((value) {
      profileProvider.changeContactFriends(value['data']);
    });
  }

  bool flag = true;

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      if (flag) {
        flag = false;
        result = scanData;
        setState(() {
          camera = false;
        });
        if (flag == false) {
          Nav.push(context, FriendsProfileScreen(userId: result!.code, source: 'qr_scan'));
        }
        flag = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: backgroundColor,
          body: Consumer<FriendProvider>(builder: (context, provider, _) {
            return Column(
              children: [
                statusBar(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Social',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              Nav.push(context, const NotificationsScreen());
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(Icons.notifications,
                                    color: primaryTextColor, size: 30),
                                Positioned(
                                  right: -3,
                                  top: -5,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.red),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        child: Text(
                                            provider.friendRequests == null
                                                ? '0'
                                                : provider.friendRequests.length
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryTextColor)),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                gap(20),
                TabBar(
                  controller: _tabController,
                  indicatorColor: primaryColor,
                  tabs: [
                    Tab(
                        icon: SvgPicture.asset(
                            _tabController!.index == 0
                                ? 'assets/icons/social_icons/scan_color.svg'
                                : 'assets/icons/social_icons/scan.svg',
                            height: 24,
                            width: 24)),
                    Tab(
                        icon: SvgPicture.asset(
                            _tabController!.index == 1
                                ? 'assets/icons/social_icons/search_friend_color.svg'
                                : 'assets/icons/social_icons/search_friend.svg',
                            height: 24,
                            width: 24)),
                    Tab(
                        icon: SvgPicture.asset(
                            _tabController!.index == 2
                                ? 'assets/icons/social_icons/group_color.svg'
                                : 'assets/icons/social_icons/group.svg',
                            height: 24,
                            width: 24)),
                  ],
                ),
                Expanded(
                  child: Column(children: [
                    gap(10),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        camera
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.4,
                                    width: double.infinity,
                                    child: QRView(
                                      key: qrKey,
                                      onQRViewCreated: _onQRViewCreated,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 120,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          camera = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Text(
                                            'Show QR Code',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Consumer<ProfileProvider>(
                                builder: (context, provider, _) {
                                return SingleChildScrollView(
                                  child: Column(children: [
                                    gap(40),
                                    Text(
                                        toBeginningOfSentenceCase(provider
                                                .profile['data']['firstName'] +
                                            ' ' +
                                            provider.profile['data']
                                                ['lastName'])!,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: primaryTextColor,
                                            fontWeight: FontWeight.bold)),
                                    gap(10),
                                    Text(provider.profile['data']['username'],
                                        style: TextStyle(
                                            color: primaryColor, fontSize: 16)),
                                    gap(30),
                                    FutureBuilder(
                                        future: _apiServices.get(
                                            context: context,
                                            endpoint: 'user/qr',
                                            progressBar: false),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return SizedBox(
                                              height: 200,
                                              child: Image.network(
                                                  qrImageUrl +
                                                      snapshot.data['data']
                                                          ['qrCodeUrl'],
                                                  fit: BoxFit.cover),
                                            );
                                          } else {
                                            return CircularProgressIndicator(
                                                color: primaryColor);
                                          }
                                        }),
                                    gap(40),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          camera = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Text(
                                            'Scan Code',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                );
                              }),


                        Column(children: [
                          Container(
                            color: Colors.white,
                            child: TextFormField(
                              controller: _search,
                              style: TextStyle(color: primaryTextColor),
                              decoration: InputDecoration(
                                hintText: 'Search by Username or Phone Number',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.black,
                                prefixIcon:
                                    Icon(Icons.search, color: primaryTextColor),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _apiServices
                                        .get(
                                            context: context,
                                            endpoint:
                                                'user/search?text=${_search.text}')
                                        .then((value) {
                                      provider.changeSearch(value['data']);
                                      if (value['data'].length < 1) {
                                        dialog(context, 'No Profile Found', () {
                                          Nav.pop(context);
                                        });
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.arrow_forward_rounded,
                                      color: primaryTextColor),
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.clearSearch();
                                }
                              },
                            ),
                          ),
                          gap(10),

                          if (provider.allFriends != null)
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (provider.search != null &&
                                        provider.search.length > 0)
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Search Result',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: primaryTextColor)),
                                            gap(10),
                                            ListView.separated(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              itemCount: provider.search.length,
                                              separatorBuilder:
                                                  (context, index) {
                                                return gap(10);
                                              },
                                              itemBuilder: (context, index) {
                                                var data =
                                                    provider.search[index];
                                                bool sent = false;
                                                return StatefulBuilder(
                                                    builder: (context, st) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Nav.push(
                                                          context,
                                                          FriendsProfileScreen(
                                                            userId: data['_id'],
                                                            source: 'search',
                                                          ));
                                                    },
                                                    child: friendsTile(
                                                        'assets/images/profile_pic.png',
                                                        data['firstName'] +
                                                            data['lastName'],
                                                        data['username'],
                                                        buttonName: sent == true
                                                            ? 'Sent'
                                                            : 'Send Request',
                                                        onTap: () {
                                                      _apiServices.post(
                                                          context: context,
                                                          endpoint:
                                                              'user/send-request',
                                                          body: {
                                                            "userId":
                                                                data['_id'],
                                                            "source": "search"
                                                          }).then((value) {
                                                        st(() {
                                                          sent = true;
                                                        });
                                                        if (value['flag'] ==
                                                            true) {
                                                          dialog(
                                                              context,
                                                              value['message'] ??
                                                                  value['data'],
                                                              () {
                                                            Nav.pop(context);
                                                          });
                                                        } else {
                                                          dialog(
                                                              context,
                                                              value['message'] ??
                                                                  value['data'],
                                                              () {
                                                            Nav.pop(context);
                                                          });
                                                        }
                                                      });
                                                    }, sent: sent),
                                                  );
                                                });
                                              },
                                            ),
                                            gap(30),
                                          ]),
                                    if (provider.contactFriends != null &&
                                        provider.contactFriends.length > 1)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        gap(20),
                                        Text('Found in your contacts',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: primaryTextColor)),
                                        gap(10),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              provider.contactFriends.length,
                                          separatorBuilder: (context, index) {
                                            return gap(10);
                                          },
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Nav.push(
                                                    context,
                                                    FriendsProfileScreen(
                                                        userId: provider
                                                                .contactFriends[
                                                            index]['_id'],
                                                    source: 'contacts',));
                                              },
                                              child: friendsTile(
                                                  'assets/images/profile_pic.png',
                                                  provider.contactFriends[index]
                                                          ['firstName'] +
                                                      provider.contactFriends[
                                                          index]['lastName'],
                                                  provider.contactFriends[index]
                                                      ['username'],
                                                  buttonName: 'Block',
                                                  onTap: () {
                                                _apiServices.post(
                                                    context: context,
                                                    endpoint:
                                                        '${baseUrl}user/block',
                                                    body: {
                                                      "userId": provider
                                                              .contactFriends[
                                                          index]['_id'],
                                                      "action": "0"
                                                    }).then((value) {
                                                  dialog(
                                                      context,
                                                      value['message'] ??
                                                          value['data'] ??
                                                          value['error'], () {
                                                    Nav.pop(context);
                                                  });
                                                });
                                              }),
                                            );
                                          },
                                        ),
                                        gap(20),
                                      ]),
                                    Text('Friends',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: primaryTextColor)),
                                    gap(10),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: provider.allFriends.length,
                                      separatorBuilder: (context, index) {
                                        return gap(10);
                                      },
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Nav.push(
                                                context,
                                                FriendsProfileScreen(
                                                    userId: provider
                                                            .allFriends[index]
                                                        ['_id'],
                                                source: 'contacts',));
                                          },
                                          child: friendsTile(
                                              provider.allFriends[index]
                                                      ['image'],
                                              provider.allFriends[index]
                                                      ['firstName'] +
                                                  provider.allFriends[index]
                                                      ['lastName'],
                                              provider.allFriends[index]
                                                  ['username'],
                                              buttonName: 'Block', onTap: () {
                                            _apiServices.post(
                                                context: context,
                                                endpoint:
                                                    '${baseUrl}user/block',
                                                body: {
                                                  "userId": provider
                                                      .allFriends[index]['_id'],
                                                  "action": "0"
                                                }).then((value) {
                                              dialog(
                                                  context,
                                                  value['message'] ??
                                                      value['data'] ??
                                                      value['error'], () {
                                                Nav.pop(context);
                                              });
                                            });
                                          }),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ]),

                        Column(children: [
                          gap(100),
                          Text(
                            'TROOPS\nComing Soon! Stay tuned :) ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                      ]),
                    ),
                  ]),
                ),
              ],
            );
          })),
    );
  }
}
