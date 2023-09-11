import '/api_services.dart';
import '/app_config/colors.dart';
import '/widget/navigator.dart';
import '/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/friend_provider.dart';
import 'friends_profile_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _search = TextEditingController();

  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    final provider = Provider.of<FriendProvider>(context, listen: false);
    _apiServices
        .get(context: context, endpoint: 'user/friend-list')
        .then((value) {
      provider.changeAllFriends(value['data']);
    });

    mutualFriends();

    super.initState();
  }

  mutualFriends() {
    final profileProvider = Provider.of<FriendProvider>(context, listen: false);

    _apiServices
        .get(context: context, endpoint: 'user/mutual-friends')
        .then((value) {
      profileProvider.changemutualFriends(value['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor, title: const Text('My Friends')),
      body: Consumer<FriendProvider>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              color: Colors.white,
              child: TextFormField(
                controller: _search,
                style: TextStyle(color: primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Search Friends',
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
            gap(10),
            const Divider(color: Colors.grey, height: 2),
            gap(10),
            Text('Mutual',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryTextColor)),
            gap(10),
            provider.mutualFriends == null
                ? gap(0)
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: provider.mutualFriends.length,
                    separatorBuilder: (context, index) {
                      return gap(10);
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          final provider = Provider.of<FriendProvider>(context,
                              listen: false);
                          provider.clearLikedBars();
                          provider.clearPosts();
                          
                          Nav.push(
                              context,
                              FriendsProfileScreen(
                                  userId: provider.mutualFriends[index]
                                      ['_id'],
                              source: 'search',));
                        },
                        child: friendsTile(
                            'assets/images/profile_pic.png',
                            provider.mutualFriends[index]['firstName'] +
                                provider.mutualFriends[index]['lastName'],
                            provider.mutualFriends[index]['username']),
                      );
                    },
                  ),
            gap(10),
            Text('All Friends',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryTextColor)),
            gap(10),
            provider.allFriends == null
                ? gap(0)
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: provider.allFriends.length,
                    separatorBuilder: (context, index) {
                      return gap(10);
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          final provider = Provider.of<FriendProvider>(context,
                              listen: false);
                          provider.clearLikedBars();
                          provider.clearPosts();

                          Nav.push(
                              context,
                              FriendsProfileScreen(
                                  userId: provider.allFriends[index]['_id'],
                              source: 'contacts',));
                        },
                        child: friendsTile(
                            'assets/images/profile_pic.png',
                            provider.allFriends[index]['firstName'] +
                                provider.allFriends[index]['lastName'],
                            provider.allFriends[index]['username']),
                      );
                    },
                  )
          ]),
        );
      }),
    );
  }
}
