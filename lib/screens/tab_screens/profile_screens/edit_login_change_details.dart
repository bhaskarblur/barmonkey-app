import 'dart:async';

import 'package:bar_monkey/api_calls.dart';
import 'package:bar_monkey/screens/tab_screens/profile_screens/edit_login_confirm_otp.dart';
import 'package:bar_monkey/widget/navigator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../api_services.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class EditLoginChangeDetails extends StatefulWidget {
  final String loginType;
  final String password;
  const EditLoginChangeDetails(
      {super.key, required this.loginType, required this
      .password});

  @override
  State<EditLoginChangeDetails> createState() =>
      _EditLoginChangeDetails();
}

class _EditLoginChangeDetails
    extends State<EditLoginChangeDetails> {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _detail = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            child:   Text((widget.loginType == 'phone') ? 'Phone Number': 'Email',
                style: TextStyle(
                    fontSize: 18,
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold)),
          ),

          gap(10),
          Text((widget.loginType == 'phone') ?
          'Enter the new phone number you want to set': 'Enter the new email you want to set',
              style: TextStyle(fontSize: 14, color: primaryTextColor)),
          gap(30)
      ,
    Column(children: [
    customTextField(
        leading:(widget.loginType == 'phone') ? Icons.phone: Icons.email ,
        fillColor: Colors.grey.shade900,
    _detail, (widget.loginType == 'phone') ? 'Phone Number': 'Email',
    validator: (value) {
    if (value!.isEmpty) {
    return 'Enter valid details';
    } else {
    return null;
    }
    })
    ])
    ,
          gap(30),
          fullWidthButton(
              buttonName: 'Confirm',
              onTap: () {

                _apiServices
                    .post(
                    context: context,
                    endpoint: 'auth/change-login',
                    body: widget.loginType =='phone'
                        ? {
                      "password": widget.password,
                      "phoneId": _detail.text,
                    }
                        : {
                      "password": widget.password,
                      "emailId": _detail.text,
                    })
                    .then((value) {
                  if (value['flag'] == true) {
                    print('correct!');
                    Nav.push(
                        context,
                        EditLoginConfirmCodeScreen(
                            loginType: widget.loginType =='phone' ? 'mobile' : 'email',
                            loginId: _detail.text ));
                  } else {
                    print('incorrect!');
                    dialog(
                        context, value['message'] ?? value['error'],
                            () {
                          Nav.pop(context);
                        });
                  }
                });

              }),
        ]),
      ),
    );
  }

  sendOTP() {

  }

  getToken() {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      print(token);
      _apiServices.patch(
          context: context, endpoint: 'user', body: {"fcm_token": token});
    });
  }

  InputDecoration inputDecoration() {
    return const InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      disabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    );
  }
}
