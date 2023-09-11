import 'package:bar_monkey/providers/bars_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/api_services.dart';
import '/app_config/app_details.dart';
import '/providers/home_screen_provider.dart';
import '/providers/profile_provider.dart';
import '/screens/authentication/login_screen.dart';
import '/screens/tab_screens/profile_screens/add_post.dart';
import '/screens/tab_screens/profile_screens/help_screen.dart';
import '/screens/tab_screens/profile_screens/all_friends_screen.dart';
import '/screens/tab_screens/profile_screens/blocked_account_screen.dart';
import '/screens/tab_screens/profile_screens/edit_login_screen.dart';
import '/screens/tab_screens/profile_screens/about_screen.dart';
import '/screens/tab_screens/profile_screens/notification_screen.dart';
import '/screens/tab_screens/profile_screens/password_reset.dart';
import '/screens/tab_screens/profile_screens/privacy_screen.dart';
import '/screens/tab_screens/profile_screens/social_link_screen.dart';
import '/screens/tab_screens/profile_screens/user_profile_screen.dart';
import '/widget/navigator.dart';
import '/widget/sahared_prefs.dart';
import '/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../app_config/colors.dart';
import '../home_screens/club_details.dart';
import 'dart:developer';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final ApiServices _apiServices = ApiServices();

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  TabController? _tabController;

  String _selectedImage = '';
  bool hasInstagram= false;
  bool hasTwitter= false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _tabController!.addListener(_handleTabSelection);

    getData();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _key,
        backgroundColor: backgroundColor,
        endDrawer: settingsDrawer(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<ProfileProvider>(builder: (context, provider, _) {
            dynamic data;
            if (provider.profile != null) {
              data = provider.profile['data'];
            }
            return provider.profile == null 
                ? gap(0)
                : Column(
                    children: [
                      statusBar(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Profile',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor)),
                          InkWell(
                            onTap: () {
                              _key.currentState!.openEndDrawer();
                            },
                            child: Icon(
                              Icons.settings_outlined,
                              size: 30,
                              color: primaryTextColor,
                            ),
                          )
                        ],
                      ),
                      gap(10),
                      Expanded(
                        child: Column(children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    openCustomDialog(
                                        context, userImageUrl + data['image']);
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: data['image'] == null
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/profile_pic.png'),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(
                                                    userImageUrl +
                                                        data['image']),
                                                fit: BoxFit.cover)),
                                  ),
                                ),
                                horGap(20),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('@${data['username']}',
                                            style:
                                                TextStyle(color: primaryColor)),
                                        // gap(4),
                                        // Text(data['emailId'] ?? data['phoneId'],
                                        //     style: const TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 12)),
                                        gap(10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/icons/meet_icons/drinks.svg'),
                                                        horGap(3),
                                                        Text('Fav Drink',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColor,
                                                                fontSize: 14)),
                                                      ],
                                                    ),
                                                    Text(data['favouriteDrink'],
                                                        style: TextStyle(
                                                            color:
                                                                primaryTextColor)),
                                                  ]),
                                              InkWell(
                                                onTap: () {
                                                  Nav.push(context,
                                                      const FriendsScreen());
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 5),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  'assets/icons/profile_screen_icons/group.svg'),
                                                              horGap(3),
                                                              Text('Friends',
                                                                  style: TextStyle(
                                                                      color:
                                                                          primaryColor,
                                                                      fontSize:
                                                                          14)),
                                                            ],
                                                          ),
                                                          Text(
                                                              data['friends']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryTextColor)),
                                                        ],
                                                      ),
                                                    )),
                                              )
                                            ]),
                                        gap(15),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              gap(0),
                                              Row(children: [

                                                if( provider
                                                    .profile['data']
                                                [
                                                'socialLinks'].toString().contains('instagram'))
                                              InkWell(

                                                onTap: () {
                                                  dynamic instagram;
                                                  print(hasInstagram);
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
                                              InkWell(
                                                onTap: () {
                                                  Nav.push(context,
                                                      const SocialLinkScreen());
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.white),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.black87),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: Row(children: [
                                                        Icon(Icons.add,
                                                            color:
                                                                primaryTextColor,
                                                            size: 18),
                                                        horGap(3),
                                                        Text('Add Social Link',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryTextColor,
                                                                fontSize: 12))
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ])
                                      ]),
                                ),
                              ]),
                          gap(20),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(data['bio'],
                                  style: TextStyle(color: primaryTextColor))),
                          gap(20),
                          TabBar(
                            controller: _tabController,
                            indicatorColor: primaryColor,
                            tabs: [
                              Tab(
                                  icon: Icon(Icons.person_pin_outlined,
                                      color: _tabController!.index == 0
                                          ? primaryColor
                                          : primaryTextColor)),
                              Tab(
                                  icon: Icon(Icons.favorite_outline,
                                      color: _tabController!.index == 1
                                          ? primaryColor
                                          : primaryTextColor)),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  provider.posts.length < 1
                                      ? Column(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/gifs/finalbinoculars.gif',
                                                      height: 100,
                                                      width: 100),
                                                  gap(20),
                                                  Text(
                                                      'Upload spotlight pics to stand out!',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              primaryTextColor)),
                                                  gap(10),
                                                  borderedButton(
                                                      buttonName:
                                                          'How to meet with barmonkey?',
                                                      onTap: () {
                                                        final provider = Provider
                                                            .of<HomeScreenProvider>(
                                                                context,
                                                                listen: false);
                                                        provider
                                                            .changeSelectedIndex(
                                                                1);
                                                      })
                                                ],
                                              ),
                                            ),
                                            fullWidthButton(
                                                buttonName: 'Upload Picture',
                                                onTap: () {
                                                  Nav.push(context,
                                                      const AddPostScreen());
                                                }),
                                            gap(60)
                                          ],
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 70),
                                          child: GridView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  provider.posts.length + 1,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10,
                                                      childAspectRatio: .8),
                                              itemBuilder: (context, index) {
                                                if (index ==
                                                    provider.posts.length) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Nav.push(context,
                                                          const AddPostScreen());
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade900,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: const Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          color: Colors.white,
                                                          size: 60),
                                                    ),
                                                  );
                                                } else {
                                                  dynamic post =
                                                      provider.posts[index];
                                                  return InkWell(
                                                    onTap: () {
                                                      _selectedImage =
                                                          post['_id'];
                                                      setState(() {});
                                                      spotlightActions(
                                                          context, post);
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                primaryTextColor,
                                                            border: Border.all(
                                                                width: 2,
                                                                color: _selectedImage ==
                                                                        post[
                                                                            '_id']
                                                                    ? primaryColor
                                                                    : Colors
                                                                        .transparent),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    postImageUrl +
                                                                        post['image']),
                                                                fit: BoxFit.cover))),
                                                  );
                                                }
                                              }),
                                        ),
                                  provider.likedBars.length < 1
                                      ? Column(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/gifs/martini.gif',
                                                      height: 100,
                                                      width: 100),
                                                  gap(20),
                                                  Text(
                                                      'Save your favorite bars',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              primaryTextColor)),
                                                  gap(10),
                                                  borderedButton(
                                                      buttonName:
                                                          'See your friends favorite',
                                                      onTap: () {
                                                        final provider = Provider
                                                            .of<BarsProvider>(
                                                                context,
                                                                listen: false);
                                                        provider.changeFeedType(
                                                            'liked by friends');
                                                        _apiServices
                                                            .get(
                                                                context:
                                                                    context,
                                                                endpoint:
                                                                    'bar?feed_type=liked by friends',
                                                                progressBar:
                                                                    false)
                                                            .then((value) {
                                                          provider
                                                              .clearSearchedBars();
                                                          provider
                                                              .addToSearchedBarList(
                                                                  value[
                                                                      'data']);
                                                          if (value['data'] ==
                                                                  null ||
                                                              value['data']
                                                                      .length <
                                                                  1) {
                                                            dialog(context,
                                                                'No bar found.',
                                                                () {
                                                              Nav.pop(context);
                                                            });
                                                          }
                                                        });
                                                        final homerovider = Provider
                                                            .of<HomeScreenProvider>(
                                                                context,
                                                                listen: false);
                                                        homerovider
                                                            .changeSelectedIndex(
                                                                2);
                                                      })
                                                ],
                                              ),
                                            ),
                                            fullWidthButton(
                                                buttonName: 'View Bars',
                                                onTap: () {
                                                  final provider = Provider.of<
                                                          HomeScreenProvider>(
                                                      context,
                                                      listen: false);
                                                  provider
                                                      .changeSelectedIndex(2);
                                                }),
                                            gap(60)
                                          ],
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 70),
                                          child: GridView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  provider.likedBars.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                              ),
                                              itemBuilder: (context, index) {
                                                dynamic data =
                                                    provider.likedBars[index];
                                                return InkWell(
                                                  onTap: () {
                                                    Nav.push(
                                                        context,
                                                        ClubDetailsScreen(
                                                            barDetails: provider
                                                                    .likedBars[
                                                                index]));
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                          flex: 7,
                                                          child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child: data['image'] ==
                                                                      null
                                                                  ? Image.asset(
                                                                      'assets/images/BarImage.png',
                                                                      fit: BoxFit
                                                                          .cover)
                                                                  : Image.network(
                                                                      barImageUrl +
                                                                          data[
                                                                              'image'],
                                                                      fit: BoxFit
                                                                          .cover))),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                                height: 3),
                                                            Text(data['name'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                ]),
                          ),
                        ]),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Future<dynamic> spotlightActions(BuildContext context, dynamic post) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: () {
                  _apiServices
                      .post(
                          context: context,
                          endpoint: 'user/post/zip',
                          body: {
                            "postId": post['_id'],
                            "type": post['isZipped'] ? '1' : '0'
                          },
                          progressBar: false)
                      .then((value) {
                    if (value['flag'] == true) {
                      Nav.pop(context);
                      getProfile();
                    } else {
                      dialog(context, value['error'] ?? value['message'], () {
                        Nav.pop(context);
                      });
                    }
                  });
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5))),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(post['isZipped'] ? 'Unpin' : 'Pin',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)))),
              ),
              Container(height: .7, width: double.infinity, color: Colors.grey),
              InkWell(
                onTap: () {
                  Nav.push(context, AddPostScreen(imageId: post['_id']));
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade900),
                    child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Replace Image',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)))),
              ),
              Container(height: .7, width: double.infinity, color: Colors.grey),
              InkWell(
                onTap: () {
                  _apiServices
                      .delete(
                          context: context,
                          endpoint: 'user/post/${post['_id']}',
                          progressBar: false)
                      .then((value) {
                    if (value['flag'] == true) {
                      Nav.pop(context);
                      getProfile();
                    } else {
                      dialog(context, value['error'] ?? value['message'], () {
                        Nav.pop(context);
                      });
                    }
                  });
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Delete Image',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)))),
              ),
              gap(30),
              InkWell(
                onTap: () {
                  Nav.pop(context);
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)))),
              ),
            ]),
          );
        });
  }

  settingsDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 60, top: 10),
        child: Column(
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
                      child: Icon(Icons.arrow_back, color: primaryTextColor)),
                ],
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text('Settings',
                      style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)))
            ]),
            gap(15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Account Settings',
                          style: TextStyle(color: primaryColor)),
                      gap(10),
                      tile('Profile',
                          'assets/icons/profile_screen_icons/profile.svg', () {
                        Nav.push(context, const UserProfileScreen());
                      }),
                      tile('Edit Login',
                          'assets/icons/profile_screen_icons/edit_login.svg',
                          () {
                        Nav.push(context, const EditLoginScreen());
                      }),
                      tile('Social Link',
                          'assets/icons/profile_screen_icons/social_link.svg',
                          () {
                        Nav.push(context, const SocialLinkScreen());
                      }),
                      gap(15),
                      Text('Security Settings',
                          style: TextStyle(color: primaryColor)),
                      gap(10),
                      tile('Password Reset',
                          'assets/icons/profile_screen_icons/password_reset.svg',
                          () {
                        Nav.push(context, const PasswordReset());
                      }),
                      tile('Privacy',
                          'assets/icons/profile_screen_icons/privecy.svg', () {
                        Nav.push(context, const PrivacyScreen());
                      }),
                      tile('Blocked Accounts',
                          'assets/icons/profile_screen_icons/blocked_accounts.svg',
                          () {
                        Nav.push(context, const BlockedAccountScreen());
                      }),
                      gap(15),
                      Text('App Settings',
                          style: TextStyle(color: primaryColor)),
                      gap(10),
                      tile('Notifications',
                          'assets/icons/profile_screen_icons/notification.svg',
                          () {
                        Nav.push(context, const NotificationScreen());
                      }),
                      // tile('Accessibility',
                      //     'assets/icons/profile_screen_icons/accessibility.svg',
                      //     () {
                      //   Nav.push(context, const AccessibilityScreen());
                      // }),
                      gap(15),
                      Text('General', style: TextStyle(color: primaryColor)),
                      gap(10),
                      tile('About',
                          'assets/icons/profile_screen_icons/about.svg', () {
                        Nav.push(context, const AboutScreen());
                      }),
                      tile('Help', 'assets/icons/profile_screen_icons/help.svg',
                          () {
                        Nav.push(context, const HelpScreen());
                      }),
                      gap(10),
                      InkWell(
                          onTap: () {
                            Prefs.clearPrefs();
                            Nav.pushAndRemoveAll(context, const LoginScreen());
                            final provider = Provider.of<HomeScreenProvider>(
                                context,
                                listen: false);
                            provider.changeSelectedIndex(2);
                          },
                          child: Text('Sign Out',
                              style: TextStyle(color: errorColor))),
                      gap(20),
                      InkWell(
                          onTap: () {
                            Prefs.getPrefs('userId').then((userId) {
                              _apiServices
                                  .delete(
                                      context: context,
                                      endpoint: 'user/remove/$userId')
                                  .then((value) {
                                if (value['flag'] == true) {
                                  Prefs.clearPrefs();
                                  Nav.pushAndRemoveAll(
                                      context, const LoginScreen());
                                  final provider =
                                      Provider.of<HomeScreenProvider>(context,
                                          listen: false);
                                  provider.changeSelectedIndex(2);
                                } else {
                                  dialog(context,
                                      value['error'] ?? value['message'], () {
                                    Nav.pop(context);
                                  });
                                }
                              });
                            });
                          },
                          child: Text('Deactivate',
                              style: TextStyle(color: errorColor))),
                      gap(10),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tile(String title, String image, void Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              SvgPicture.asset(image, height: 20, width: 20),
              horGap(20),
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      color: primaryTextColor,
                      fontWeight: FontWeight.normal)),
            ]),
            Icon(Icons.keyboard_arrow_right_rounded,
                color: primaryTextColor, size: 36),
          ],
        ),
      ),
    );
  }

  getData() {
    // getPosts();
    // getLikedBars();
    getProfile();
    // getLikedBars();
  }

  getProfile() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    Prefs.getPrefs('userId').then((userId) {
      _apiServices
          .get(context: context, endpoint: 'user/profile/$userId')
          .then((value) {
        profileProvider.chnageProfile(value);
        print('allDataProfile:');

        if(value.toString().contains('instagram')) {
         hasInstagram=true;
        }
        if(value.toString().contains('twitter')) {
          hasTwitter=true;
        }

        profileProvider.chnagePosts(value['data']['posts']);
        // profileProvider.chnageLikedBars(value['data']['likedBars']);
      });

      Prefs.getPrefs('token').then((token) {
        log('userIdhere:'+ userId!);
        log('tokenhere:'+ token!);
      });

      getLikedBars();
    });
  }

  getLikedBars() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    _apiServices.get(context: context, endpoint: 'bar/liked').then((value) {
      provider.clearLikedBars();
      provider.chnageLikedBars(value['data']);
    });
  }

  // getPosts() {
  //   final provider = Provider.of<ProfileProvider>(context, listen: false);
  //   Prefs.getPrefs('userId').then((userId) {
  //     _apiServices
  //         .get(context: context, endpoint: 'user/profile/$userId')
  //         .then((value) {
  //       if (value['flag'] == true) {
  //         provider.chnageProfile(value);
  //         provider.chnagePosts(value['data']['posts']);
  //       } else {
  //         dialog(context, value['error'] ?? value['message'], () {
  //           Nav.pop(context);
  //         });
  //       }
  //     });
  //   });
  // }

  
}
