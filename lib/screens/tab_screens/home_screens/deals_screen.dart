import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/api_services.dart';
import '/app_config/app_details.dart';
import '/app_config/colors.dart';
import '/screens/tab_screens/home_screens/club_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/bars_provider.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';
import 'home_screen.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    getData();

    super.initState();
  }

  bool filter = false;

  getData() {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final provider = Provider.of<BarsProvider>(context, listen: false);
        provider.resetFilter();
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: backgroundColor,
            title: Text('Deals', style: TextStyle(color: primaryTextColor))),
        body: Consumer<BarsProvider>(builder: (context, provider, _) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(children: [
                  TextFormField(
                    controller: _search,
                    style: TextStyle(color: primaryTextColor),
                    decoration: InputDecoration(
                        hintText: 'Search for bars',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.black,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: primaryTextColor),
                        suffixIcon: IconButton(
                            onPressed: () {
                              // provider.resetFilter();
                              filter = !filter;
                              setState(() {});
                              filterApi();
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
                  // TextFormField(
                  //   controller: _search,
                  //   style: TextStyle(color: primaryTextColor),
                  //   decoration: InputDecoration(
                  //     hintText: 'Search for bars',
                  //     hintStyle: const TextStyle(color: Colors.grey),
                  //     filled: true,
                  //     fillColor: Colors.black,
                  //     prefixIcon: Icon(Icons.search, color: primaryTextColor),
                  //     suffixIcon: IconButton(
                  //       onPressed: () {},
                  //       icon: Icon(Icons.arrow_forward_rounded,
                  //           color: primaryTextColor),
                  //     ),
                  //     border: InputBorder.none,
                  //   ),
                  //   onEditingComplete: () {},
                  //   onChanged: (value) {},
                  // ),
                  gap(20),
                  if (provider.dealBars.isNotEmpty)
                    Expanded(
                      child:
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: provider.dealBars.length,
                        separatorBuilder: (context, index) {
                          return gap(20);
                        },
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Nav.push(
                                  context,
                                  ClubDetailsScreen(
                                      barDetails: provider.dealBars[index]));
                            },
                            child: Stack(
                              children: [
                                Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                        image: provider.dealBars[index]
                                                    ['image'] ==
                                                null
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/BarImage.png'),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(
                                                    barImageUrl +
                                                        provider.dealBars[index]
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
                                                    provider.dealBars[index]
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
                                                      provider.dealBars[index]
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
                      ),
                    )
                ]),
              ),
              if (filter)
                Positioned(
                    top: MediaQuery.of(context).viewPadding.top + 50,
                    child: filterSheet(context)),
            ],
          );
        }),
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
                          getData();
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
                  'bar/deals?category=$category&music=$music${provider.feedType == null ? '' : '&feed_type=${provider.feedType}'}')
          .then((value) {
        provider.clearDealBars();
        provider.addToDealBarList(value['data']);
        if (value['data'] == null || value['data'].length < 1) {
          dialog(context, 'No bar found.', () {
            Nav.pop(context);
          });
        }
      });
    }
  }
}
