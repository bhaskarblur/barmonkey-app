import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '/api_services.dart';
import '/app_config/colors.dart';
import '/providers/bars_provider.dart';
import '/providers/profile_provider.dart';
import '/screens/tab_screens/home_screens/club_details.dart';
import '/screens/tab_screens/home_screens/deals_screen.dart';
import '/screens/tab_screens/home_screens/map_screen.dart';
import '/widget/navigator.dart';
import '/widget/sahared_prefs.dart';
import '/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:label_marker/label_marker.dart';
import 'package:provider/provider.dart';

import '../../../app_config/app_details.dart';
import '../../../providers/map_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  bool filter = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<BarsProvider>(builder: (context, provider, _) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  statusBar(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SvgPicture.asset(
                                    'assets/icons/monkey.svg',
                                    height: 25,
                                    width: 20)),
                            FutureBuilder(
                                future: Prefs.getPrefs('firstName'),
                                builder: (context, snapshot) {
                                  return Text(
                                      'Hello there, ${snapshot.hasData ? toBeginningOfSentenceCase(snapshot.data)! : ''} 👋',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20));
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  provider.resetFilter();
                                  Nav.push(context, const DealsScreen());
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/smile.svg',
                                    height: 22,
                                    width: 22)),
                            IconButton(
                                onPressed: () async {
                                  // Nav.push(context, const MapScreen());
                                  provider.resetFilter();

                                  turnOnLocation();
                                },
                                icon: Icon(Icons.map_outlined,
                                    color: primaryTextColor)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _search,
                            style: TextStyle(color: primaryTextColor),
                            decoration: InputDecoration(
                                hintText: 'Search for bars',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.black,
                                border: InputBorder.none,
                                prefixIcon:
                                    Icon(Icons.search, color: primaryTextColor),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      filter = !filter;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                        filter
                                            ? FontAwesomeIcons.xmark
                                            : Icons.keyboard_arrow_down,
                                        color: primaryTextColor,
                                        size: filter ? 26 : 36))),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                FocusScope.of(context).unfocus();
                                _search.clear();
                                provider.clearSearchedBars();
                              }
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              if (_search.text.isNotEmpty) {
                                _apiServices
                                    .get(
                                        context: context,
                                        endpoint: 'bar?text=${_search.text}')
                                    .then((value) {
                                  provider.clearSearchedBars();
                                  provider.addToSearchedBarList(value['data']);
                                });
                              }
                            },
                          ),
                          gap(10),
                          Expanded(
                            child: SingleChildScrollView(
                              child: provider.barsNearbyUsers == null
                                  ? gap(0)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: provider.searchedBars != null
                                          ? Column(
                                              children: [
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(children: [
                                                    filterTag(provider
                                                        .filterCategory),
                                                    horGap(10),
                                                    filterTag(
                                                        provider.filterMusic),
                                                    horGap(10),
                                                    if (provider.feedType !=
                                                        null)
                                                      Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      14),
                                                          child: Center(
                                                            child: Text(
                                                                toBeginningOfSentenceCase(
                                                                    provider
                                                                        .feedType)!,
                                                                style: const TextStyle(
                                                                    color:
                                                                        Colors.black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                      )
                                                  ]),
                                                ),
                                                gap(10),
                                                GridView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: provider
                                                      .searchedBars.length,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 10,
                                                          childAspectRatio:
                                                              .85),
                                                  itemBuilder:
                                                      (context, index) {
                                                    dynamic data = provider
                                                        .searchedBars[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        provider.resetFilter();
                                                        Nav.push(
                                                            context,
                                                            ClubDetailsScreen(
                                                                barDetails:
                                                                    data));
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              height: 150,
                                                              width: 200,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  image: data['image'] ==
                                                                          null
                                                                      ? const DecorationImage(
                                                                          image: AssetImage(
                                                                              'assets/images/BarImage.png'),
                                                                          fit: BoxFit
                                                                              .cover)
                                                                      : DecorationImage(
                                                                          image:
                                                                              NetworkImage(barImageUrl + data['image']),
                                                                          fit: BoxFit.cover))),
                                                          gap(5),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                  height: 3),
                                                              Text(data['name'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          primaryTextColor,
                                                                      fontSize:
                                                                          16)),
                                                              const SizedBox(
                                                                  height: 3),
                                                              Text(
                                                                  'Night Club - RnB, pop',
                                                                  style: TextStyle(
                                                                      color:
                                                                          primaryColor,
                                                                      fontSize:
                                                                          12)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                gap(60)
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Popular in Your City',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color:
                                                            primaryTextColor)),
                                                gap(10),
                                                listView(context,
                                                    provider.popularInYourCity),
                                                gap(10),
                                                Text('Near You',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color:
                                                            primaryTextColor)),
                                                gap(10),
                                                listView(context,
                                                    provider.barsNearbyUsers),
                                                gap(10),
                                                Text('Liked by Your Friends',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color:
                                                            primaryTextColor)),
                                                listView(context,
                                                    provider.likedByFriends),
                                                gap(60),
                                              ],
                                            ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (filter)
                Positioned(
                    top: MediaQuery.of(context).viewPadding.top + 126,
                    child: filterSheet(context)),
            ],
          );
        }),
      ),
    );
  }

  Widget filterTag(dynamic list) {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (context, index) {
          return horGap(10);
        },
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                child: Text(toBeginningOfSentenceCase(list[index])!,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }

  List<FilterType> categoryString = [
    FilterType('wine bar', 'Wine Bar'),
    FilterType('sports bar', 'Sports Bar'),
    FilterType('cocktail_lounge', 'Cocktail Lounge'),
    FilterType('beer/brewery', 'Beer/Brewery'),
    FilterType('nightclub', 'Nightclub'),
    FilterType('live music_bar', 'Live Music Bar'),
    FilterType('pub/tavern', 'Pub/Tavern'),
    FilterType('speakeasy', 'Speakeasy'),
    FilterType('whiskey bar', 'Whiskey Bar'),
  ];

  List<FilterType> musicString = [
    FilterType('rock/pop', 'Rock/Pop'),
    FilterType('electronic/dance', 'Electronic/Dance'),
    FilterType('country', 'Country'),
    FilterType('jazz/blues', 'Jazz/Blues'),
    FilterType('rap/hiphop', 'Rap/Hiphop'),
    FilterType('latin/salsa', 'Latin/Salsa'),
    FilterType('live music', 'Live Music'),
  ];

  List<String> feedString = [
    'popular in your city',
    'liked by friends',
    'near you',
  ];

  filterSheet(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(.8),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<BarsProvider>(builder: (context, provider, _) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Icon(Icons.store_outlined,
                        color: primaryTextColor, size: 22),
                    horGap(10),
                    Text('Category',
                        style:
                            TextStyle(color: primaryTextColor, fontSize: 14)),
                  ]),
                ),
                gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(spacing: 10, runSpacing: 10, children: [
                    for (int i = 0; i < categoryString.length; i++)
                      InkWell(
                        onTap: () {
                          if (provider.filterCategory
                              .contains(categoryString[i].key)) {
                            provider.removeFromFilterCategory(
                                categoryString[i].key!);
                          } else {
                            provider
                                .addToFileterCategory(categoryString[i].key!);
                          }

                          filterApi();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: provider.filterCategory.contains(categoryString[i].key)
                                    ? primaryColor
                                    : Colors.black,
                                border: Border.all(
                                    color: provider.filterCategory.contains(categoryString[i].key)
                                        ? primaryColor
                                        : primaryTextColor),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(categoryString[i].name!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: provider.filterCategory.contains(categoryString[i].key)
                                            ? Colors.black
                                            : primaryTextColor)))),
                      )
                  ]),
                ),
                gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Icon(Icons.music_note, color: primaryTextColor, size: 22),
                    horGap(10),
                    Text('Music',
                        style:
                            TextStyle(color: primaryTextColor, fontSize: 14)),
                  ]),
                ),
                gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(spacing: 10, runSpacing: 10, children: [
                    for (int i = 0; i < musicString.length; i++)
                      InkWell(
                        onTap: () {
                          if (provider.filterMusic
                              .contains(musicString[i].key)) {
                            provider.removeFromFilterMusic(musicString[i].key!);
                          } else {
                            provider.addToFileterMusic(musicString[i].key!);
                          }
                          filterApi();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: provider.filterMusic.contains(musicString[i].key)
                                    ? primaryColor
                                    : Colors.black,
                                border: Border.all(
                                    color: provider.filterMusic.contains(musicString[i].key)
                                        ? primaryColor
                                        : primaryTextColor),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(musicString[i].name!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            provider.filterMusic.contains(musicString[i].key)
                                                ? Colors.black
                                                : primaryTextColor)))),
                      )
                  ]),
                ),
                gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Icon(Icons.feed_outlined,
                        color: primaryTextColor, size: 22),
                    horGap(10),
                    Text('Feed Type',
                        style:
                            TextStyle(color: primaryTextColor, fontSize: 14)),
                  ]),
                ),
                gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(spacing: 10, runSpacing: 10, children: [
                    for (int i = 0; i < feedString.length; i++)
                      InkWell(
                        onTap: () {
                          provider.changeFeedType(feedString[i]);
                          filterApi();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: provider.feedType == feedString[i]
                                    ? primaryColor
                                    : Colors.black,
                                border: Border.all(
                                    color: provider.feedType == feedString[i]
                                        ? primaryColor
                                        : primaryTextColor),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text(feedString[i],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            provider.feedType == feedString[i]
                                                ? Colors.black
                                                : primaryTextColor)))),
                      )
                  ]),
                ),
                gap(15),
                Center(
                    child: borderedButton(
                        buttonName: 'Reset Filter',
                        onTap: () {
                          filter = !filter;
                          _search.clear();
                          provider.resetFilter();
                          provider.clearSearchedBars();
                        },
                        width: MediaQuery.of(context).size.width / 2)),
                gap(30),
              ]);
        }),
      ),
    );
  }

  filterApi() {
    final provider = Provider.of<BarsProvider>(context, listen: false);
    if (provider.filterCategory.isEmpty &&
        provider.filterMusic.isEmpty &&
        provider.feedType == null) {
    } else {
      String category = '';
      for (int i = 0; i < provider.filterCategory.length; i++) {
        category = category + ('${provider.filterCategory[i]},');
      }

      String music = '';
      for (int i = 0; i < provider.filterMusic.length; i++) {
        music = music + ('${provider.filterMusic[i]},');
      }
      print(provider.feedType);

      _apiServices
          .get(
              context: context,
              endpoint:
                  'bar?category=$category&music=$music${provider.feedType == null ? '' : '&feed_type=${provider.feedType}'}')
          .then((value) {
        provider.clearSearchedBars();
        provider.addToSearchedBarList(value['data']);
        if (value['data'] == null || value['data'].length < 1) {
          dialog(context, 'No bar found.', () {
            Nav.pop(context);
          });
        }
      });
    }
  }

  Widget listView(BuildContext context, dynamic barData) {
    return SizedBox(
      height: barData.length > 0 ? 200 : 150,
      width: MediaQuery.of(context).size.width - 50,
      child: barData.length > 0
          ? ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: barData.length,
              separatorBuilder: (context, index) {
                return horGap(10);
              },
              itemBuilder: (context, index) {
                dynamic data = barData[index];
                return InkWell(
                  onTap: () {
                    final provider =
                        Provider.of<BarsProvider>(context, listen: false);
                    provider.resetFilter();

                    Nav.push(context, ClubDetailsScreen(barDetails: data));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: data['image'] == null
                                  ? const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/BarImage.png'),
                                      fit: BoxFit.cover)
                                  : DecorationImage(
                                      image: NetworkImage(
                                          barImageUrl + data['image']),
                                      fit: BoxFit.cover))),
                      gap(5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 3),
                          Text(data['name'],
                              style: TextStyle(
                                  color: primaryTextColor, fontSize: 16)),
                          const SizedBox(height: 3),
                          Text('Night Club - RnB, pop',
                              style:
                                  TextStyle(color: primaryColor, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text('No Bars Found Yet!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 16)),
            ),
    );
  }

  turnOnLocation() async {
    final provider = Provider.of<BarsProvider>(context, listen: false);

    Location location = Location();

    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();

    if (serviceEnabled == true) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MapScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ));
    } else {
      // ignore: use_build_context_synchronously
      showYesNoButton(context, 'Want to enable location service?', () {
        Nav.pop(context);
        Geolocator.openLocationSettings().then((value) async {
          provider.resetFilter();
          provider.clearSearchedBars();

          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const MapScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
        });
      }, () {
        Nav.pop(context);
      });
    }
  }

  getData() {
    final provider = Provider.of<BarsProvider>(context, listen: false);

    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    _apiServices.get(context: context, endpoint: 'bar/homelist').then((value) {
      provider.clearPopularInYourCity();
      provider.addToPopularInYourCity(value['data']['popular']);

      provider.clearBarsNearbyUsers();
      provider.changeBarsNearbyUsers(value['data']['nearBy']);

      provider.clearLikedByFriends();
      provider.addToLikedByFriends(value['data']['likedByFriends']);

      mapProvider.clearMarker();
      for (int i = 0; i < value['data']['nearBy'].length; i++) {
        mapProvider.addMarker(LabelMarker(
            label: value['data']['nearBy'][i]['name'],
            markerId: MarkerId(value['data']['nearBy'][i]['name']),
            position: LatLng(
                value['data']['nearBy'][i]['location']['coordinates'][0],
                value['data']['nearBy'][i]['location']['coordinates'][1]),
            onTap: () {
              mapProvider.changeShowDetails(true);
              mapProvider.changeSelectedMarker(value['data']['nearBy'][i]);
            }));
      }
    });

    // for current location
    _apiServices.getLocation().then((value) {
      mapProvider.changeCurrentPosition(LabelMarker(
          label: 'You',
          markerId: const MarkerId('Current'),
          position: LatLng(value.latitude, value.longitude)));
    });

    // Other APIs
    _apiServices
        .get(context: context, endpoint: 'bar/liked', progressBar: false)
        .then((value) {
      provider.clearLikedBars();
      provider.addToLikedBarList(value['data']);
    });

    _apiServices.getCurrentLocation(context);

    Prefs.getPrefs('userId').then((userId) {
      _apiServices
          .get(
              context: context,
              endpoint: 'user/profile/$userId',
              progressBar: false)
          .then((value) {
        profileProvider.chnageProfile(value);
        // profileProvider.chnagePosts(value['data']['posts']);
        profileProvider.clearPosts();

        if(value['data']['posts'] != null) {
          for (int i = 0; i < value['data']['posts'].length; i++) {
            if (value['data']['posts'][i]['isZipped'] == true) {
              profileProvider.addToPosts(value['data']['posts'][i]);
            }
          }
          for (int i = 0; i < value['data']['posts'].length; i++) {
            if (value['data']['posts'][i]['isZipped'] == false) {
              profileProvider.addToPosts(value['data']['posts'][i]);
            }
          }
        }
          profileProvider.notify();

      });
    });
  }

  tile(dynamic data) {
    return data == null
        ? const Expanded(child: Center(child: CircularProgressIndicator()))
        : data.length < 1
            ? const Expanded(
                child: Center(
                  child: Text('No Photo Found',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              )
            : Expanded(
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          final provider =
                              Provider.of<BarsProvider>(context, listen: false);
                          provider.resetFilter();
                          Nav.push(context, const ClubDetailsScreen());
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 7,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Image.network(
                                      data[index]['urls']['regular'],
                                      fit: BoxFit.cover),
                                )),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 3),
                                  Text('ID: ${data[index]['id']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: primaryTextColor,
                                          fontSize: 16)),
                                  const SizedBox(height: 3),
                                  Text(
                                      'Height: ${data[index]['height']},  Width: ${data[index]['width']}',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 12)),
                                  const SizedBox(height: 3),
                                  Text(
                                      'Author: ${data[index]['user']['username']}',
                                      style: TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              );
  }

  listItem(String title) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      Text(title,
          style: TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      SizedBox(
        height: 200,
        child: ListView.separated(
          itemCount: 5,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 10);
          },
          itemBuilder: (context, index) {
            return SizedBox(
              height: 200,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(child: Image.asset('assets/images/BarImage.png')),
                    const SizedBox(height: 5),
                    Text('Shiner Park',
                        style: TextStyle(
                            color: primaryTextColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text('Night Club',
                            style: TextStyle(color: primaryColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              height: 3,
                              width: 3,
                              decoration: BoxDecoration(
                                  color: primaryColor, shape: BoxShape.circle)),
                        ),
                        Text('RnB, Pop', style: TextStyle(color: primaryColor)),
                      ],
                    ),
                  ]),
            );
          },
        ),
      )
    ]);
  }
}

class FilterType {
  String? key;
  String? name;

  FilterType(this.key, this.name);
}
