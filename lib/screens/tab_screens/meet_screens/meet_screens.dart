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

class MeetScreen extends StatefulWidget {
  const MeetScreen({super.key});

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _search = TextEditingController();

  bool data = false;

  dynamic selectedBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<BarsProvider>(builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: data
                ? Column(
                    children: [
                      statusBar(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Meet',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor)),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    data = false;
                                  });
                                  barBottomSheet(context);
                                },
                                child: Row(
                                  children: [
                                    Text('People near  ',
                                        style:
                                            TextStyle(color: primaryTextColor)),
                                    Text('Shiner Park',
                                        style: TextStyle(color: primaryColor)),
                                    Icon(Icons.keyboard_arrow_down,
                                        color: primaryColor)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                profileBottomSheet(context, 'self');
                              },
                              icon: Icon(Icons.more_horiz,
                                  color: primaryTextColor))
                        ],
                      ),
                      gap(20),
                      Expanded(
                        child: provider.barsNearbyUsers == null
                            ? gap(0)
                            : provider.barsNearbyUsers.length < 1
                                ? Center(
                                    child: Text(
                                      'No User Here!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: primaryTextColor),
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: provider.barsNearbyUsers.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) {
                                      var data =
                                          provider.barsNearbyUsers[index];
                                      return InkWell(
                                        onTap: () {
                                          Nav.push(
                                              context,
                                              NearbyUserScreen(
                                                  barDetails: selectedBar,
                                                  userDetails: data,
                                              source: 'meet'));
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    image: data['image'] == null
                                                        ? const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/formal_pic.png'),
                                                            fit: BoxFit.cover)
                                                        : DecorationImage(
                                                            image: NetworkImage(
                                                                userImageUrl +
                                                                    data[
                                                                        'image']),
                                                            fit:
                                                                BoxFit.cover))),
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    20,
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(.7)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(children: [
                                                    Row(children: [
                                                      Image.asset(
                                                          'assets/icons/meet_icons/Bar Logo.png'),
                                                      horGap(10),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              data['firstName'] +
                                                                  ' ' +
                                                                  data[
                                                                      'lastName'],
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryTextColor,
                                                                  fontSize:
                                                                      18)),
                                                          Text('Shiner Park',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      primaryTextColor)),
                                                        ],
                                                      ),
                                                    ]),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      statusBar(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Meet',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor)),
                              if (data == false)
                                Text('Meet new people, one drink at a time',
                                    style: TextStyle(
                                        color: primaryTextColor, fontSize: 12)),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                profileBottomSheet(context, 'self');
                              },
                              icon: Icon(Icons.more_horiz,
                                  color: primaryTextColor, size: 26))
                        ],
                      ),
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined,
                                  color: primaryColor, size: 40),
                              gap(20),
                              Text('Your Location Must Be Verified',
                                  style: TextStyle(
                                      color: primaryTextColor, fontSize: 16)),
                              gap(30),
                              Text(
                                  'By selecting the bar, you accept sharing the following information to those near your regardless of your profile’s privacy setting.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryTextColor, fontSize: 14)),
                              gap(30),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    textBanner('Name'),
                                    horGap(20),
                                    textBanner('Social Links'),
                                    horGap(20),
                                    textBanner('Spotlight Pics'),
                                  ]),
                              gap(10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    textBanner('Profile Info and Bio'),
                                    horGap(20),
                                    textBanner('Bar Location'),
                                  ]),
                              gap(30),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 6),
                                child: Column(children: [
                                  fullWidthButton(
                                      buttonName: 'Select Bar',
                                      onTap: () {
                                        barBottomSheet(context);
                                      }),
                                  gap(20),
                                  borderedButton(
                                      buttonName: 'Preview Your Profile',
                                      onTap: () {
                                        profileBottomSheet(context, '');
                                      })
                                ]),
                              ),
                            ]),
                      ),
                    ],
                  ),
          );
        }));
  }

  barBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        builder: (context1) {
          return Consumer<BarsProvider>(builder: (context, provider, _) {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    statusBar(context),
                    gap(5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Select Bar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  color: primaryTextColor)),
                          InkWell(
                            onTap: () {
                              Nav.pop(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.xmark,
                              color: primaryTextColor,
                              size: 30,
                            ),
                          )
                        ]),
                    gap(10),
                    TextFormField(
                      controller: _search,
                      style: TextStyle(color: primaryTextColor),
                      decoration: InputDecoration(
                        hintText: 'Search for bars',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        prefixIcon: Icon(Icons.search, color: primaryTextColor),
                        suffixIcon: IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _apiServices
                                .get(
                                    context: context,
                                    endpoint: 'bar?text=${_search.text}',
                                    progressBar: false)
                                .then((value) {
                              provider.clearSearchedBars();
                              provider.addToSearchedBarList(value['data']);
                            });
                          },
                          icon: Icon(Icons.arrow_forward_rounded,
                              color: primaryTextColor),
                        ),
                        border: InputBorder.none,
                      ),
                      onEditingComplete: () {},
                      onChanged: (value) {
                        if (value.isEmpty) {
                          FocusScope.of(context).unfocus();
                          _apiServices
                              .get(context: context, endpoint: 'bar')
                              .then((value) {
                            provider.clearSearchedBars();
                            provider.addToSearchedBarList(value['data']);
                          });
                        }
                      },
                    ),
                    gap(20),
                    Expanded(
                      child: provider.searchedBars == null
                          ? gap(0)
                          : provider.searchedBars.length < 1
                              ? Center(
                                  child: Text(
                                    'No Bars Yet!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: primaryTextColor),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: provider.barsNearbyUsers.length,
                                  separatorBuilder: (context, index) {
                                    return gap(20);
                                  },
                                  itemBuilder: (context, index) {
                                    dynamic bar = provider.searchedBars[index];
                                    return InkWell(
                                      onTap: () {
                                        selectedBar = bar;
                                        Nav.pop(context);
                                        setState(() {
                                          data = true;
                                        });
                                        provider.clearBarsNearbyUsers();
                                        _apiServices
                                            .get(
                                                context: context,
                                                endpoint:
                                                    'bar/nearby-user/${bar['_id']}',
                                                progressBar: false)
                                            .then((value) {
                                          if (value['flag']) {
                                            provider.changeBarsNearbyUsers(
                                                value['data']);
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
                                      child: Stack(
                                        children: [
                                          Container(
                                              height: 250,
                                              decoration: BoxDecoration(
                                                  image: bar['image'] == null
                                                      ? const DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/BarImage.png'),
                                                          fit: BoxFit.cover)
                                                      : DecorationImage(
                                                          image: NetworkImage(
                                                              barImageUrl +
                                                                  bar['image']),
                                                          fit: BoxFit.cover))),
                                          Positioned(
                                            bottom: 0,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20,
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(.7),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          topLeft:
                                                              Radius.circular(
                                                                  20))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(children: [
                                                  Row(children: [
                                                    Image.asset(
                                                        'assets/icons/meet_icons/Bar Logo.png'),
                                                    horGap(10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(bar['name'],
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColor,
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
                                                                decoration: const BoxDecoration(
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
                                                        Text(
                                                            '217 University Drive',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    primaryTextColor)),
                                                      ],
                                                    ),
                                                  ]),
                                                ]),
                                              ),
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
              ),
            );
          });
        });
  }

  Widget textBanner(String text) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(text, style: TextStyle(color: primaryTextColor)),
      ),
    );
  }

  profileBottomSheet(BuildContext context, String profileType) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Consumer<ProfileProvider>(builder: (context, provider, _) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.3,
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.grey.shade800),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Your profile as seen by others',
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: () {
                                Nav.pop(context);
                              },
                              child: Icon(FontAwesomeIcons.xmark,
                                  size: 26, color: primaryTextColor),
                            )
                          ],
                        ),
                        gap(10),
                        Text('Edit profile to see changes',
                            style: TextStyle(
                                color: primaryTextColor, fontSize: 12)),
                        gap(30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  var provider =
                                      Provider.of<HomeScreenProvider>(context,
                                          listen: false);
                                  Nav.pop(context);
                                  provider.changeSelectedIndex(4);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(children: [
                                        Icon(Icons.edit,
                                            color: primaryTextColor, size: 16),
                                        horGap(5),
                                        Text('Edit Profile',
                                            style: TextStyle(
                                                color: primaryTextColor))
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                              Column(children: [
                                Row(children: [
                                  SvgPicture.asset(
                                      'assets/icons/meet_icons/drinks.svg'),
                                  horGap(3),
                                  Text('Fav Drink',
                                      style: TextStyle(color: primaryColor))
                                ]),
                                gap(3),
                                Text(provider.profile['data']['favouriteDrink'],
                                    style: TextStyle(
                                        color: primaryTextColor, fontSize: 16))
                              ]),
                            ]),
                        gap(20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: provider.profile['data']['image'] ==
                                                  null ||
                                              provider.profile['data']['image'] ==
                                                  ''
                                          ? Image.asset(
                                              'assets/images/profile_pic.png',
                                              fit: BoxFit.cover)
                                          : Image.network(
                                              userImageUrl +
                                                  provider.profile['data']
                                                      ['image'],
                                              fit: BoxFit.cover)),
                                ),
                                horGap(5),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          toBeginningOfSentenceCase(
                                              provider.profile['data']
                                                      ['firstName'] +
                                                  ' ' +
                                                  provider.profile['data']
                                                      ['lastName'])!,
                                          style: TextStyle(
                                              color: primaryTextColor,
                                              fontSize: 16)),
                                      gap(5),
                                      Text(provider.profile['data']['username'],
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 16)),
                                    ])
                              ]),
                              Row(children: [

                                if( provider
                                    .profile['data']
                                [
                                'socialLinks'].toString().contains('instagram'))
                                  InkWell(

                                    onTap: () {
                                      dynamic instagram;
                                      for (int i = 0;
                                      i <
                                          provider
                                              .profile['data']
                                          [
                                          'socialLinks']
                                              .length;
                                      i++) {

                                        if (provider.profile[
                                        'data'][
                                        'socialLinks']
                                        [i]['name'] ==
                                            'instagram') {
                                          instagram = provider
                                              .profile['data']
                                          ['socialLinks'][i];
                                        }
                                      }

                                      if (instagram == null) {
                                        dialog(context,
                                            'No Instagram account is linked.',
                                                () {
                                              Nav.pop(context);
                                            });
                                      } else {
                                        urlLauncher(
                                            instagram['link'],
                                            context);
                                      }
                                    },
                                    child: Icon(
                                        FontAwesomeIcons
                                            .instagram,
                                        color: primaryTextColor),
                                  ),

                                horGap(20),
                                if( provider
                                    .profile['data']
                                [
                                'socialLinks'].toString().contains('twitter'))
                                  InkWell(
                                    onTap: () {
                                      dynamic twitter;
                                      for (int i = 0;
                                      i <
                                          provider
                                              .profile['data']
                                          [
                                          'socialLinks']
                                              .length;
                                      i++) {
                                        if (provider.profile[
                                        'data'][
                                        'socialLinks']
                                        [i]['name'] ==
                                            'twitter') {
                                          twitter = provider
                                              .profile['data']
                                          ['socialLinks'][i];
                                        }
                                      }

                                      if (twitter == null) {
                                        dialog(context,
                                            'No Twitter account is linked.',
                                                () {
                                              Nav.pop(context);
                                            });
                                      } else {
                                        urlLauncher(
                                            twitter['link'],
                                            context);
                                      }
                                    },
                                    child: Icon(
                                        FontAwesomeIcons.twitter,
                                        color: primaryTextColor),
                                  ),
                              ]),
                            ]),
                        gap(20),
                        SizedBox(
                          height: 250,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.posts.length,
                            separatorBuilder: (context, index) {
                              return horGap(20);
                            },
                            itemBuilder: (context, index) {
                              return SizedBox(
                                  height: 250,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      postImageUrl +
                                          provider.posts[index]['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ));
                            },
                          ),
                        ),
                        gap(20),
                        Center(
                            child: Text(provider.profile['data']['bio'],
                                style: TextStyle(
                                    color: primaryTextColor, fontSize: 16),
                                textAlign: TextAlign.center)),
                        gap(20),
                        if (profileType == 'self')
                          borderedButton(
                              buttonName: 'Hide Myself from Public Feed',
                              onTap: () {
                                Nav.pop(context);
                                Nav.push(context, const PrivacyScreen());
                              }),
                      ]),
                ),
              ),
            );
          });
        });
  }

  profile(dynamic data) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      statusBar(context),
      Text('Meet',
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: primaryTextColor)),
      InkWell(
        onTap: () {
          barBottomSheet(context);
          setState(() {
            data = false;
          });
        },
        child: Row(
          children: [
            Text('People near  ', style: TextStyle(color: primaryTextColor)),
            Text('Shiner Park', style: TextStyle(color: primaryColor)),
            Icon(Icons.keyboard_arrow_down, color: primaryColor)
          ],
        ),
      ),
      gap(30),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(children: [
                  Icon(Icons.keyboard_arrow_left,
                      color: primaryTextColor, size: 16),
                  horGap(5),
                  Text('Gallery View',
                      style: TextStyle(color: primaryTextColor))
                ]),
              ),
            ),
          ),
        ),
        Column(children: [
          Row(children: [
            SvgPicture.asset('assets/icons/meet_icons/drinks.svg'),
            horGap(3),
            Text('Fav Drink', style: TextStyle(color: primaryColor))
          ]),
          gap(3),
          Text('Dark Whiskey',
              style: TextStyle(color: primaryTextColor, fontSize: 16))
        ]),
      ]),
      gap(20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          SizedBox(
              height: 60,
              width: 60,
              child: Image.asset('assets/images/profile_pic.png')),
          horGap(5),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('James Bond',
                style: TextStyle(color: primaryTextColor, fontSize: 16)),
            gap(5),
            Text('@the_real_007',
                style: TextStyle(color: primaryColor, fontSize: 16)),
          ])
        ]),
        Row(children: [
          Icon(FontAwesomeIcons.instagram, color: primaryTextColor, size: 30),
          horGap(30),
          Icon(FontAwesomeIcons.twitter, color: primaryTextColor, size: 30),
        ]),
      ]),
      gap(20),
      SizedBox(
        height: 250,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (context, index) {
            return horGap(20);
          },
          itemBuilder: (context, index) {
            return SizedBox(
                height: 250,
                child: Image.asset('assets/images/full_image.png',
                    fit: BoxFit.cover));
          },
        ),
      ),
      gap(20),
      Center(
          child: Text('You did not see me in a movie... Lets connect!',
              style: TextStyle(color: primaryTextColor, fontSize: 16),
              textAlign: TextAlign.center)),
      gap(50),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 6),
        child: borderedButton(buttonName: 'Send Friend Request', onTap: () {}),
      ),
    ]);
  }
}
