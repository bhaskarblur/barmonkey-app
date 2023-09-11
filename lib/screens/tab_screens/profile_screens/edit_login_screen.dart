import 'package:bar_monkey/screens/tab_screens/profile_screens/edit_login_confirm_otp.dart';

import '/api_services.dart';
import '/providers/profile_provider.dart';
import '/widget/navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_config/colors.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';
import 'edit_login_change_details.dart';

class EditLoginScreen extends StatefulWidget {
  const EditLoginScreen({super.key});

  @override
  State<EditLoginScreen> createState() => _EditLoginScreenState();
}

class _EditLoginScreenState extends State<EditLoginScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  late FocusNode myFocusNode = FocusNode();
  bool public = true;
  bool visibility = false;
  bool phone = true;
  String type = 'phone';

  @override
  void initState() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    // emailValid = RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(provider.profile['data']['loginId']);

    if (provider.profile['data']['emailId'] != null) {
      _email.text = provider.profile['data']['emailId'];
      // emailEnabled = false;
    }
    if (provider.profile['data']['phoneId'] != null) {
      _phone.text = provider.profile['data']['phoneId'];
      // phoneEnabled = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              settingsAppBar(context, 'Edit Login'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Want to change your email or phone number?',
                          style:
                              TextStyle(color: primaryTextColor, fontSize: 16)),
                      gap(20),
                      customTextField(_pass, 'Enter Current Password',
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          fillColor: Colors.grey.shade900,
                          leading: Icons.lock_outline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter password';
                            } else {
                              return null;
                            }
                          },
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  visibility = !visibility;
                                });
                              },
                              child: Icon(
                                visibility
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color:
                                visibility ? primaryColor : Colors.grey,
                              )),
                          visibility: !visibility),
                      gap(15),
                      Column(
                        children: [
                          gap(0),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Select Contact to be Changed',
                                        style:
                                        TextStyle(color: primaryTextColor, fontSize: 16)),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          gap(25),
                                          logincard(
                                              'Phone Number',
                                              'assets/icons/telephone.svg',
                                              public, () {
                                            setState(() {
                                              public=true;
                                              type = 'phone';
                                            });
                                          }),
                                          gap(20),
                                          logincard(
                                              'Email',
                                              'assets/icons/email.svg',
                                              !public, () {
                                            setState(() {
                                              public=false;
                                              type = 'email';
                                            });
                                          }),
                                          gap(30),
                                        ]),
                                  ])),
                        ],
                      ),
                      gap(0),

                      fullWidthButton(
                          buttonName: 'Verify',
                          onTap: () {
                            Nav.push(
                                context,
                                EditLoginChangeDetails(
                                    loginType: type,
                                  password: _pass.text,
                                )
                            );
                          //  Nav.pop(context);
                          }
                    ),
              ]),
              )],
          ),
        ));
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

            if (provider.profile['data']['emailId'] != null) {
              _email.text = provider.profile['data']['emailId'];
              // emailEnabled = false;
            }
            if (provider.profile['data']['phoneId'] != null) {
              _phone.text = provider.profile['data']['phoneId'];
              // phoneEnabled = false;
            }
          } else {
            dialog(context, value['error'] ?? value['message'], () {
              Nav.pop(context);
            });
          }
        });
      });
    });
  }
}
