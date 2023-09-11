import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/providers/friend_provider.dart';
import '/screens/tab_screens/home_screens/club_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../api_services.dart';
import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class FriendsProfileScreen extends StatefulWidget {
  final String? userId;
  final String? source;
  const FriendsProfileScreen({super.key, this.userId, required this.source});

  @override
  State<FriendsProfileScreen> createState() => _FriendsProfileScreenState();
}

class _FriendsProfileScreenState extends State<FriendsProfileScreen>
    with TickerProviderStateMixin {
  final ApiServices _apiServices = ApiServices();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _tabController!.addListener(_handleTabSelection);

    getData();
    //addViewToUser();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            backgroundColor: backgroundColor, title: const Text('Profile')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<FriendProvider>(builder: (context, provider, _) {
            dynamic data;
            if (provider.profile != null) {
              data = provider.profile['data'];
            }
            return provider.profile == null || provider.posts == null
                // ||
                // provider.likedBars == null
                ? gap(0)
                : Column(
                    children: [
                      Expanded(
                        child: Column(children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (data['image'] != null) {
                                      openCustomDialog(context,
                                          userImageUrl + data['image']);
                                    }
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: data['image'] == null
                                        ? const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/profile_pic.png'),
                                                fit: BoxFit.cover))
                                        : BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
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
                                        Text(data['username'],
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
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Fav Drink',
                                                          style: TextStyle(
                                                              color:
                                                                  primaryColor,
                                                              fontSize: 12)),
                                                      Text(
                                                          data[
                                                              'favouriteDrink'],
                                                          style: TextStyle(
                                                              color:
                                                                  primaryTextColor)),
                                                    ]),
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
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
                                                      ]
                                                      ,
                                                    ),


                                                  ))
                                            ]),
                                        gap(15),
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
                                ),
                              ]),
                          gap(20),

                          Text(data['bio'],
                              style: TextStyle(color: primaryTextColor)),
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
                          gap(10),
                          Expanded(
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  provider.posts.length < 1
                                      ? Center(
                                          child: Text(
                                            'No Posts Yet!',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: primaryTextColor),
                                          ),
                                        )
                                      : GridView.builder(
                                          itemCount: provider.posts.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: .8),
                                          itemBuilder: (context, index) {
                                            dynamic post =
                                                provider.posts[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: primaryTextColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Image.network(
                                                postImageUrl + post['image'],
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }),
                                  provider.likedBars.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No Bars Yet!',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: primaryTextColor),
                                          ),
                                        )
                                      : GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: provider.likedBars.length,
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
                                                            .likedBars[index]));
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      flex: 7,
                                                      child: SizedBox(
                                                          width:
                                                              double.infinity,
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
                                                                fontSize: 16)),
                                                        const SizedBox(
                                                            height: 3),
                                                        Text(
                                                            'Night Club - RnB, pop',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColor,
                                                                fontSize: 12)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                ]),
                          ),
                          gap(10),
                        ]),
                      ),
                    ],
                  );
          }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10),
          child: fullWidthButton(
              buttonName: 'Send Request',
              onTap: () {
                final provider =
                    Provider.of<FriendProvider>(context, listen: false);
                _apiServices.post(
                    context: context,
                    endpoint: 'user/send-request',
                    body: {
                      "userId": provider.profile['data']['_id'],
                      "source": widget.source
                    }).then((value) {
                  dialog(context, value['message'] ?? value['data'], () {
                    Nav.pop(context);
                  });
                });
              }),
        ),
      ),
    );
  }

  getData() {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    _apiServices
        .get(context: context, endpoint: 'user/profile/${widget.userId}')
        .then((value) {
      if (value['flag'] == true) {
        provider.changeProfile(value);
        provider.changePosts(value['data']['posts']);

        for (int i = 0; i < provider.profile['data']['likedBars'].length; i++) {
          _apiServices
              .get(
                  context: context,
                  endpoint:
                      'bar/details/${provider.profile['data']['likedBars'][i]}',
                  progressBar: false)
              .then((value) {
            provider.clearLikedBars();
            provider.addToLikedBars(value['data']);
          });
        }
      } else {
        dialog(context, value['error'] ?? value['message'], () {
          Nav.pop(context);
        });
      }
    });
  }

   addViewToUser() {
     _apiServices
         .post(context: context, endpoint: 'user/view'
     , body: {
           "userId":widget.userId
         })
         .then((value) {
           print(value);

     });
   }
}
