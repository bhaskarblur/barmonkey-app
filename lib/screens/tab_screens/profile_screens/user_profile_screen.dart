import '/api_services.dart';
import '/providers/profile_provider.dart';
import '/screens/tab_screens/profile_screens/change_profile.dart';
import '/widget/navigator.dart';
import '/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/sahared_prefs.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _favDrink = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  DateTime? _date;

  @override
  void initState() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    _firstName.text = provider.profile['data']['firstName'];
    _lastName.text = provider.profile['data']['lastName'];
    _favDrink.text = provider.profile['data']['favouriteDrink'];
    _bio.text = provider.profile['data']['bio'];

    _date = DateTime.parse(provider.profile['data']['dob']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<ProfileProvider>(builder: (context, provider, _) {
        return Column(
          children: [
            settingsAppBar(context, 'Profile'),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        gap(20),
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: provider.profile['data']['image'] == null
                                  ? const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/profile_pic.png'),
                                      fit: BoxFit.cover)
                                  : DecorationImage(
                                      image: NetworkImage(userImageUrl +
                                          provider.profile['data']['image']),
                                      fit: BoxFit.cover)),
                        ),
                        gap(30),
                        InkWell(
                          onTap: () {
                            Nav.push(context, const ChangeProfilePic());
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: primaryColor)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text('Change Profile Picture',
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 16)),
                              )),
                        ),
                        gap(30),
                        customTile(
                            title: 'First Name',
                            subtitle: provider.profile['data']['firstName'],
                            controller: _firstName),
                        gap(20),
                        customTile(
                            title: 'Last Name',
                            subtitle: provider.profile['data']['lastName'],
                            controller: _lastName),
                        gap(20),
                        customTile(
                            title: 'Favorite Drink',
                            subtitle: provider.profile['data']
                                ['favouriteDrink'],
                            controller: _favDrink),
                        gap(20),
                        customTile(
                            title: 'Bio',
                            subtitle: provider.profile['data']['bio'],
                            controller: _bio),
                        gap(20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(5)),
                            child: InkWell(
                              onTap: () async {
                                await showDatePicker(
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary:
                                                    primaryColor, // header background color
                                                onPrimary: Colors
                                                    .black, // header text color
                                                onSurface: Colors
                                                    .black, // body text color
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors
                                                      .blue, // button text color
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1923, 8),
                                        lastDate: DateTime.now())
                                    .then((value) {
                                  if (value != null) {
                                    _date = value;
                                    setState(() {});
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(children: []),
                                      Text('Date of Birth',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 18)),
                                      gap(7),
                                      Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(_date!),
                                          style: TextStyle(
                                              color: primaryTextColor))
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        gap(20),
                        fullWidthButton(
                            buttonName: 'Save Changes',
                            onTap: () {
                              _apiServices.patch(
                                  context: context,
                                  endpoint: 'user',
                                  body: {
                                    "firstName": _firstName.text,
                                    "lastName": _lastName.text,
                                    "dob": _date.toString(),
                                    "favouriteDrink": _favDrink.text,
                                    "bio": _bio.text
                                  }).then((value) {
                                if (value['flag'] == true) {
                                  getData();
                                } else {
                                  dialog(context,
                                      value['message'] ?? value['error'], () {
                                    Nav.pop(context);
                                  });
                                }
                              });
                            })
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget customTile(
      {String? image,
      String? title,
      String? subtitle,
      void Function()? onTap,
      TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              if (image != null)
                SizedBox(height: 20, width: 20, child: SvgPicture.asset(image)),
              if (image != null) horGap(20),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title!,
                          style: TextStyle(color: primaryColor, fontSize: 16)),
                      SizedBox(
                        height: 30,
                        child: customTextField(controller!, title,
                            fillColor: Colors.grey.shade900,
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.grey.shade900),
                      )
                    ]),
              )
            ]),
          ),
        ),
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
          } else {
            dialog(context, value['error'] ?? value['message'], () {
              Nav.pop(context);
            });
          }
        });

        _apiServices.get(context: context, endpoint: 'bar/liked').then((value) {
          provider.clearLikedBars();
          provider.chnageLikedBars(value['data']);
        });
      });
    });
  }
}
