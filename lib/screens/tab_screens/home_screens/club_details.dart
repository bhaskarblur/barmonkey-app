import 'package:intl/intl.dart';

import '/api_services.dart';
import '/app_config/app_details.dart';
import '/app_config/colors.dart';
import '/providers/bars_provider.dart';
import '/widget/navigator.dart';
import '/widget/sahared_prefs.dart';
import '/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClubDetailsScreen extends StatefulWidget {
  final dynamic barDetails;

  const ClubDetailsScreen({super.key, this.barDetails});

  @override
  State<ClubDetailsScreen> createState() => _ClubDetailsScreenState();
}

class _ClubDetailsScreenState extends State<ClubDetailsScreen>
    with TickerProviderStateMixin {
  final ApiServices _apiServices = ApiServices();

  bool liked = false;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<BarsProvider>(context, listen: false);

    _apiServices
        .get(
            context: context,
            endpoint: 'bar/details/${widget.barDetails['_id']}')
        .then((value) {
      provider.changeBarDetails(value['data']);
      provider.clearCategory();

      _tabController = TabController(
          vsync: this, length: provider.barDetails['menu'].length);
      _tabController!.addListener(_handleTabSelection);

      for (int i = 0; i < value['data']['menu'].length; i++) {
        provider.changeSelectedCategory(value['data']['menu'][0]['category']);
        provider.addToCategory(value['data']['menu'][i]['category']);
      }

      _apiServices.get(context: context, endpoint: 'bar/liked').then((value) {
        provider.clearLikedBars();
        provider.addToLikedBarList(value['data']);

        for (int i = 0; i < provider.likedBars.length; i++) {
          if (provider.likedBars[i]["_id"] == provider.barDetails["_id"]) {
            liked = true;
          }
        }
      });
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<BarsProvider>(builder: (context, provider, _) {
        return provider.barDetails == null
            ? gap(0)
            : DefaultTabController(
                length: provider.barDetails['menu'].length,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: provider.barDetails['image'] == null
                              ? const DecorationImage(
                                  image:
                                      AssetImage('assets/images/BarImage.png'))
                              : DecorationImage(
                                  image: NetworkImage(barImageUrl +
                                      provider.barDetails['image']))),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          color: Colors.black.withOpacity(.2),
                          child: Column(children: [
                            statusBar(context),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Nav.pop(context);
                                      },
                                      icon: Icon(Icons.arrow_back,
                                          color: primaryTextColor)),
                                  Row(children: [
                                    // IconButton(
                                    //     onPressed: () {},
                                    //     icon:
                                    //         Icon(Icons.search, color: primaryTextColor)),
                                    if (provider.barDetails['website'] !=
                                            null ||
                                        provider.barDetails['website'] != '')
                                      IconButton(
                                          onPressed: () {
                                            urlLauncher(
                                                provider.barDetails['website'],
                                                context);
                                          },
                                          icon: SvgPicture.asset(
                                              'assets/icons/more.svg')),
                                  ])
                                ]),
                            Container(
                              color: Colors.black.withOpacity(.7),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(provider.barDetails['name'],
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: primaryTextColor)),
                                              Row(children: [
                                                Text('Night Club',
                                                    style: TextStyle(
                                                        color: primaryColor)),
                                                horGap(5),
                                                Container(
                                                    height: 5,
                                                    width: 5,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: primaryColor)),
                                                horGap(5),
                                                Text('RnB, Pop',
                                                    style: TextStyle(
                                                        color: primaryColor)),
                                              ])
                                            ],
                                          ),
                                          Row(children: [
                                            Icon(Icons.watch_later_outlined,
                                                color: primaryColor, size: 16),
                                            horGap(5),
                                            Text('Open until',
                                                style: TextStyle(
                                                    color: primaryTextColor)),
                                            horGap(5),
                                            Text(
                                                provider.barDetails[
                                                        'openTill'] ??
                                                    '',
                                                style: TextStyle(
                                                    color: primaryColor)),
                                          ])
                                        ],
                                      ),
                                      gap(10),
                                      Row(children: [
                                        SvgPicture.asset(
                                            'assets/icons/smile_color.svg'),
                                        horGap(5),
                                        Text('Happy hour from ',
                                            style: TextStyle(
                                                color: primaryTextColor)),
                                        Text(
                                            provider.barDetails['happyHours'] ??
                                                '',
                                            style:
                                                TextStyle(color: primaryColor))
                                      ]),
                                      gap(10),
                                      Row(
                                        children: [
                                          Consumer<BarsProvider>(
                                              builder: (context, provider, _) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.black),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: InkWell(
                                                  onTap: () {
                                                    Prefs.getToken()
                                                        .then((token) {
                                                      _apiServices.post(
                                                          context: context,
                                                          endpoint: 'bar/like',
                                                          body: {
                                                            "barId": widget
                                                                    .barDetails[
                                                                "_id"],
                                                            "type": liked
                                                                ? "1"
                                                                : "0"
                                                          }).then((value) {
                                                        _apiServices
                                                            .get(
                                                                context:
                                                                    context,
                                                                endpoint:
                                                                    'bar/liked')
                                                            .then((value) {
                                                          provider
                                                              .clearLikedBars();
                                                          provider
                                                              .addToLikedBarList(
                                                                  value[
                                                                      'data']);
                                                        });
                                                        if (value['flag'] ==
                                                            true) {
                                                          liked = !liked;
                                                          setState(() {});
                                                        }
                                                      });
                                                    });
                                                  },
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                            liked
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_outline,
                                                            size: 16,
                                                            color: Colors.red),
                                                        horGap(8),
                                                        Text(
                                                            liked
                                                                ? 'Liked Bar'
                                                                : 'Like Bar',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryTextColor))
                                                      ]),
                                                ),
                                              ),
                                            );
                                          }),
                                          horGap(10),
                                          InkWell(
                                            onTap: () async {
                                              MapUtils.openMap(
                                                  provider.barDetails[
                                                          'location']
                                                      ['coordinates'][0],
                                                  provider.barDetails[
                                                          'location']
                                                      ['coordinates'][1]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.black),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          size: 16,
                                                          color: Colors.blue),
                                                      horGap(8),
                                                      Text('Get Direction',
                                                          style: TextStyle(
                                                              color:
                                                                  primaryTextColor))
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          horGap(10),
                                          InkWell(
                                            onTap: () async {
                                              // make an api call to add story

                                              _apiServices.getLocation().then((value) {
                                                var lat = value.latitude.toString();
                                                var lon = value.longitude.toString();

                                                _apiServices.post(
                                                    context: context,
                                                    endpoint:
                                                    'user/verify-location',
                                                    body: {
                                                      "barId":
                                                      widget.barDetails['_id'],
                                                      "location": {
                                                        "latitude":lat,
                                                        "longitude":lon,
                                                      }
                                                    }).then((value) {
                                                  print(value['data']);
                                                  if (value['data']
                                                  ["userInBar"] ==
                                                      true) {
                                                    _apiServices.post(
                                                        context: context,
                                                        endpoint: 'user/story',
                                                        body: {
                                                          "barId": widget
                                                              .barDetails['_id']
                                                        }).then((value) {
                                                      if (value['flag'] ==
                                                          true) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            "Story Uploaded!");
                                                      } else if (value[
                                                      'message'] !=
                                                          null) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            value['message']);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            "There was an error in posting story");
                                                      }
                                                    });
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        "You're not in this bar!");
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.black),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          size: 16,
                                                          color: Colors.green),
                                                      horGap(8),
                                                      Text('Post Bar',
                                                          style: TextStyle(
                                                              color:
                                                                  primaryTextColor))
                                                    ]),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      gap(10),
                                      Container(
                                          height: 3,
                                          width: double.infinity,
                                          color: Colors.grey),
                                      gap(10),
                                      TabBar(
                                        isScrollable: true,
                                        controller: _tabController,
                                        indicatorColor: primaryColor,
                                        tabs: [
                                          for (int i = 0;
                                              i < provider.category.length;
                                              i++)
                                            Tab(
                                                text: toBeginningOfSentenceCase(
                                                    provider.category[i])),
                                        ],
                                      ),
                                    ]),
                              ),
                            )
                          ]),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child:
                              TabBarView(controller: _tabController, children: [
                            for (int i = 0;
                                i < provider.barDetails['menu'].length;
                                i++)
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.shade900),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                provider.barDetails['menu'][i]
                                                    ['name'],
                                                style: TextStyle(
                                                    color: primaryTextColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            gap(10),
                                            Text(
                                                provider.barDetails['menu'][i]
                                                    ['description'],
                                                style: TextStyle(
                                                    color: primaryTextColor)),
                                          ]),
                                    ),
                                  ),
                                  gap(10)
                                ],
                              )
                          ])),
                    )
                  ],
                ),
              );
      }),
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
