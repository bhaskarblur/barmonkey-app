import 'package:bar_monkey/api_services.dart';
import 'package:bar_monkey/providers/profile_provider.dart';
import 'package:bar_monkey/widget/navigator.dart';
import 'package:bar_monkey/widget/sahared_prefs.dart';
import 'package:bar_monkey/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApiCalls {
  ApiServices apiServices = ApiServices();

  profile(BuildContext context, {bool progressBar = true}) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    loader(context);
    Prefs.getPrefs('userId').then((userId) {
      apiServices
          .get(
              context: context,
              endpoint: 'user/profile/$userId',
              progressBar: false)
          .then((value) {
        profileProvider.chnageProfile(value);
        profileProvider.chnagePosts(value['data']['posts']);
        profileProvider.chnageLikedBars(value['data']['likedBars']);
      });
    });
    Nav.pop(context);
  }

  // profile(BuildContext context, {bool progressBar = true}) {
  //   final profileProvider =
  //       Provider.of<ProfileProvider>(context, listen: false);

  //   Prefs.getPrefs('userId').then((userId) {
  //     apiServices
  //         .get(
  //             context: context,
  //             endpoint: 'user/profile/$userId',
  //             progressBar: progressBar)
  //         .then((value) {
  //       profileProvider.chnageProfile(value);
  //       profileProvider.chnagePosts(value['data']['posts']);
  //     });
  //   });
  // }

  // mutualFriends(BuildContext context, {bool progressBar = true}) {
  //   final profileProvider = Provider.of<FriendProvider>(context, listen: false);
  //   loader(context);
  //   apiServices
  //       .get(
  //           context: context,
  //           endpoint: 'user/mutual-friends',
  //           progressBar: progressBar)
  //       .then((value) {
  //     profileProvider.changemutualFriends(value['data']);
  //   });
  //   Nav.pop(context);
  // }
}
