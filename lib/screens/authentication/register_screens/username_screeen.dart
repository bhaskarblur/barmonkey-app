import 'package:bar_monkey/api_services.dart';
import 'package:bar_monkey/screens/authentication/register_screens/set_pass_screen.dart';
import 'package:bar_monkey/widget/navigator.dart';
import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';

class UsernameScreen extends StatefulWidget {
  final String loginType;
  final String loginId;

  const UsernameScreen(
      {super.key, required this.loginType, required this.loginId});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final ApiServices _apiServices = ApiServices();

  final GlobalKey<FormState> _usernameKey = GlobalKey<FormState>();

  final TextEditingController userName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(backgroundColor: backgroundColor),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Form(
              key: _usernameKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Username',
                        style: TextStyle(
                            fontSize: 18,
                            color: primaryTextColor,
                            fontWeight: FontWeight.bold)),
                    gap(10),
                    Text(
                        'Your username will be public on our app. You will not be able to change it at this time.',
                        style:
                            TextStyle(fontSize: 14, color: primaryTextColor)),
                    gap(30),
                    customTextField(userName, '@username', validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username.';
                      } else {
                        return null;
                      }
                    }),
                  ]),
            ),
            gap(30),
            fullWidthButton(
                buttonName: 'Next',
                onTap: () {
                  Prefs.getToken().then((token) {
                    if (_usernameKey.currentState!.validate()) {
                      _apiServices.post(
                        context: context,
                        endpoint: 'auth/signup/username',
                        body: {"username": userName.text},
                      ).then((value) {
                        if (value['flag'] == true) {
                          Prefs.setPrefs('userId', value['data']['_id']);
                          Nav.push(context, const SetPassScreen());
                        } else {
                          dialog(context, value['error'] ?? value['message'],
                              () {
                            Nav.pop(context);
                          });
                        }
                      });
                    }
                  });
                })
          ]),
        ));
  }
}
