import 'dart:async';

import '../../../providers/bars_provider.dart';
import '/api_services.dart';
import '/app_config/app_details.dart';
import '/providers/map_provider.dart';
import '/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:label_marker/label_marker.dart';
import 'package:provider/provider.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/sahared_prefs.dart';
import 'club_details.dart';
import 'deals_screen.dart';
import 'home_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    _apiServices.getCurrentLocation(context);
    goToCureentPosition();

    super.initState();
  }

  bool filter = false;

  final Completer<GoogleMapController> _completer = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MapProvider>(builder: (context, provider, _) {
        return Stack(children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) async {
              _completer.complete(controller);
            },
            zoomControlsEnabled: false,
            onTap: (value) {
              provider.changeShowDetails(!provider.showBarDetails);
              provider.changeSelectedMarker(null);
            },
            initialCameraPosition: CameraPosition(
                target: provider.currentPosition.position, zoom: 15),
            markers: provider.markers,
            myLocationEnabled: true,
            // myLocationButtonEnabled: false,
            myLocationButtonEnabled: false,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Stack(
              children: [
                Column(children: [
                  statusBar(context),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.7),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            horGap(10),
                            SvgPicture.asset('assets/icons/monkey.svg',
                                height: 25, width: 25),
                            horGap(10),
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
                                Nav.push(context, const DealsScreen());
                              },
                              child: SvgPicture.asset('assets/icons/smile.svg',
                                  height: 25, width: 25),
                            ),
                            IconButton(
                                onPressed: () {
                                  Nav.pop(context);
                                },
                                icon: Icon(FontAwesomeIcons.rectangleList,
                                    color: primaryTextColor)),
                          ],
                        )
                      ],
                    ),
                  ),
                  gap(10),
                  TextFormField(
                    controller: _search,
                    style: TextStyle(color: primaryTextColor),
                    decoration: InputDecoration(
                        hintText: 'Search for bars',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.black.withOpacity(.7),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: primaryTextColor),
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
                        // provider.clearSearchedBars();
                        provider.clearMarker();
                      }
                    },
                    onTap: () {
                      provider.changeShowDetails(false);
                    },
                    onEditingComplete: () {
                      _apiServices
                          .get(
                              context: context,
                              endpoint: 'bar?text=${_search.text}')
                          .then((value) {
                        provider.clearMarker();
                        for (int i = 0; i < value['data'].length; i++) {
                          provider.addMarker(LabelMarker(
                              label: value['data'][i]['name'],
                              markerId: MarkerId(value['data'][i]['name']),
                              position: LatLng(
                                  value['data'][i]['location']['coordinates']
                                      [0],
                                  value['data'][i]['location']['coordinates']
                                      [1]),
                              onTap: () {
                                provider.changeShowDetails(true);
                                provider.changeSelectedMarker(value['data'][i]);
                              }));
                        }
                      });
                    },
                  ),
                  //////////////////////////
                  // TextFormField(
                  //   controller: _search,
                  //   style: TextStyle(color: primaryTextColor),
                  //   decoration: InputDecoration(
                  //     hintText: 'Search for bars',
                  //     hintStyle: const TextStyle(color: Colors.grey),
                  //     filled: true,
                  //     fillColor: Colors.black.withOpacity(.7),
                  //     prefixIcon: Icon(Icons.search, color: primaryTextColor),
                  //     suffixIcon: IconButton(
                  //       onPressed: () {
                  //         FocusScope.of(context).unfocus();
                  //         _apiServices
                  //             .get(
                  //                 context: context,
                  //                 endpoint: 'bar?text=${_search.text}')
                  //             .then((value) {
                  //           provider.clearMarker();
                  //           for (int i = 0; i < value['data'].length; i++) {
                  //             provider.addMarker(LabelMarker(
                  //                 label: value['data'][i]['name'],
                  //                 markerId: MarkerId(value['data'][i]['name']),
                  //                 position: LatLng(
                  //                     value['data'][i]['location']
                  //                         ['coordinates'][0],
                  //                     value['data'][i]['location']
                  //                         ['coordinates'][1]),
                  //                 onTap: () {
                  //                   provider.changeShowDetails(true);
                  //                   provider
                  //                       .changeSelectedMarker(value['data'][i]);
                  //                 }));
                  //           }
                  //         });
                  //       },
                  //       icon: Icon(Icons.arrow_forward_rounded,
                  //           color: primaryTextColor),
                  //     ),
                  //     border: InputBorder.none,
                  //   ),
                  //   onTap: () {
                  //     provider.changeShowDetails(false);
                  //   },
                  //   onEditingComplete: () {
                  //     FocusScope.of(context).unfocus();
                  //   },
                  //   onChanged: (value) {
                  //     if (value.isEmpty) {
                  //       FocusScope.of(context).unfocus();
                  //       provider.clearMarker();
                  //       _apiServices
                  //           .get(context: context, endpoint: 'user/nearby-bars')
                  //           .then((value) {
                  //         for (int i = 0; i < value['data'].length; i++) {
                  //           provider.addMarker(LabelMarker(
                  //               label: value['data'][i]['name'],
                  //               markerId: MarkerId(value['data'][i]['name']),
                  //               position: LatLng(
                  //                   value['data'][i]['location']['coordinates']
                  //                       [0],
                  //                   value['data'][i]['location']['coordinates']
                  //                       [1]),
                  //               onTap: () {
                  //                 provider.changeShowDetails(true);
                  //                 provider
                  //                     .changeSelectedMarker(value['data'][i]);
                  //               }));
                  //         }
                  //         provider.notify();
                  //       });
                  //     }
                  //   },
                  // ),
                  // //////////////////////////
                ]),
                if (provider.selectedMarker != null && provider.showBarDetails)
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          Nav.push(
                              context,
                              ClubDetailsScreen(
                                  barDetails: provider.selectedMarker));
                        },
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                              image:
                                  provider.selectedMarker['happyHours'] == null
                                      ? const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/BarImage.png'),
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: NetworkImage(barImageUrl +
                                              provider.selectedMarker['image']),
                                          fit: BoxFit.cover)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.7),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(children: [
                                      Text('Happy hour from ',
                                          style: TextStyle(
                                              color: primaryTextColor)),
                                      Text(
                                          provider.selectedMarker[
                                                  'happyHours'] ??
                                              '',
                                          style: TextStyle(color: primaryColor))
                                    ]),
                                  ),
                                ),
                              ),
                              gap(10),
                              Container(
                                width: MediaQuery.of(context).size.width - 20,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.7),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
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
                                          Text(provider.selectedMarker['name'],
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 22)),
                                          Row(
                                            children: [
                                              Text('Nightclub',
                                                  style: TextStyle(
                                                      color: primaryTextColor)),
                                              horGap(5),
                                              Container(
                                                  height: 5,
                                                  width: 5,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle)),
                                              horGap(5),
                                              Text('RnB, Pop',
                                                  style: TextStyle(
                                                      color: primaryTextColor)),
                                            ],
                                          ),
                                          gap(5),
                                          Text('217 University Drive',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryTextColor)),
                                        ],
                                      ),
                                    ]),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
              ],
            ),
          ),
          if (filter)
            Positioned(
              left: 0,right: 0,
                top: MediaQuery.of(context).viewPadding.top + 126,
                child: filterSheet(context)),
        ]);
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          goToCureentPosition();
        },
        child: Icon(
          Icons.location_on,
          color: primaryColor,
        ),
      ),
    );
  }

  goToCureentPosition() async {
    final provider = Provider.of<MapProvider>(context, listen: false);

    final c = await _completer.future;

    _apiServices.getLocation().then((value) {
      provider.changeCurrentPosition(LabelMarker(
          label: 'You',
          markerId: const MarkerId('You'),
          position: LatLng(value.latitude, value.longitude)));

      final p = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 14.4746);
      c.animateCamera(CameraUpdate.newCameraPosition(p));
    });
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
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
                              provider
                                  .removeFromFilterMusic(musicString[i].key!);
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
                            setState(() {});
                          },
                          width: MediaQuery.of(context).size.width / 2)),
                  gap(30),
                ]);
          }),
        ),
      ),
    );
  }

  filterApi() {
    final provider = Provider.of<BarsProvider>(context, listen: false);
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
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
                  'user/nearby-bars?category=$category&music=$music${provider.feedType == null ? '' : '&feed_type=${provider.feedType}'}')
          .then((value) {
        // provider.clearSearchedBars();
        // provider.addToSearchedBarList(value['data']);
        // if (value['data'] == null || value['data'].length < 1) {
        //   dialog(context, 'No bar found.', () {
        //     Nav.pop(context);
        //   });
        // }
        mapProvider.clearMarker();
        for (int i = 0; i < value['data'].length; i++) {
          mapProvider.addMarker(LabelMarker(
              label: value['data'][i]['name'],
              markerId: MarkerId(value['data'][i]['name']),
              position: LatLng(value['data'][i]['location']['coordinates'][0],
                  value['data'][i]['location']['coordinates'][1]),
              onTap: () {
                mapProvider.changeShowDetails(true);
                mapProvider.changeSelectedMarker(value['data'][i]);
              }));
        }
      });
    }
  }
}
