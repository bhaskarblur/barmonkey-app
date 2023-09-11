import '/api_services.dart';
import '/widget/navigator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../app_config/colors.dart';
import '../../../providers/profile_provider.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';



class SocialLinkScreen extends StatefulWidget {
  const SocialLinkScreen({super.key});

  @override
  State<SocialLinkScreen> createState() => _SocialLinkScreenState();
}

class _SocialLinkScreenState extends State<SocialLinkScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _twitter = TextEditingController();
  final TextEditingController _instagram = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          settingsAppBar(context, 'Social Link'),
          gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black87),
                        child: Icon(FontAwesomeIcons.twitter,
                            size: 20, color: primaryTextColor),
                      ),
                    ),
                  ),
                  horGap(10),
                  Expanded(
                    flex: 4,
                    child: customTextField(_twitter, 'Twitter Link (https://twitter.com/...)'),
                  ),
                ]),
                gap(40),
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black87),
                        child: Icon(FontAwesomeIcons.instagram,
                            color: primaryTextColor),
                      ),
                    ),
                  ),
                  horGap(10),
                  Expanded(
                    flex: 4,
                    child:
                        customTextField(_instagram, 'Instagram Link (https://instagram.com/...)'),
                    //     InkWell(
                    //     onTap: () async {
                    //     // Nav.push(context, const InstagramView());

                    //     // FlutterInsta flutterInsta = FlutterInsta();
                    //     // await flutterInsta.getProfileData("");

                    //     // print("Username : ${flutterInsta.username}");
                    //     // print("Followers : ${flutterInsta.followers}");
                    //     // print("Folowing : ${flutterInsta.following}");
                    //     // print("Bio : ${flutterInsta.bio}");
                    //     // print("Website : ${flutterInsta.website}");
                    //     // print("Profile Image : ${flutterInsta.imgurl}");
                    //     // print("Feed images:${flutterInsta.feedImagesUrl}");
                    //   },
                    //   child: Container(
                    //     height: 50,
                    //     width: 300,
                    //     color: Colors.grey,
                    //   ),
                    // )
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: fullWidthButton(
            buttonName: 'Link',
            onTap: () {
              // instagram
              if (_instagram.text.isNotEmpty) {
                _apiServices.post(
                    context: context,
                    endpoint: 'user/social-links',
                    body: {
                      "name": "instagram",
                      "link": _instagram.text
                    }).then((value) {
                  if (value['flag']) {
                    getData();
                    dialog(context, 'Successfully saved links', () {
                      Nav.pop(context);
                    });
                  } else {
                    dialog(context, value['message'] ?? value['error'], () {
                      Nav.pop(context);
                    });
                  }
                });
              }

              // twitter
              if (_twitter.text.isNotEmpty) {
                _apiServices.post(
                    context: context,
                    endpoint: 'user/social-links',
                    body: {
                      "name": "twitter",
                      "link": _twitter.text
                    }).then((value) {
                  if (value['flag']) {
                    getData();
                    dialog(context, 'Successfully saved links', () {
                      Nav.pop(context);
                    });
                  } else {
                    dialog(context, value['message'] ?? value['error'], () {
                      Nav.pop(context);
                    });
                  }
                });
              }
            }),
      ),
    );
  }

  getData() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 100), () {
      Prefs.getPrefs('userId').then((userId) {
        _apiServices
            .get(context: context, endpoint: 'user/profile/$userId')
            .then((value) {
          if (value['flag'] == true) {
            provider.chnageProfile(value);
            provider.chnagePosts(value['data']['posts']);
          }
        });
      });
    });
  }
}
