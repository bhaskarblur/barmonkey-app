import 'dart:async';

import 'package:bar_monkey/api_calls.dart';
import 'package:bar_monkey/widget/navigator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../api_services.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class EditLoginConfirmCodeScreen extends StatefulWidget {
  final String loginType;
  final String loginId;
  const EditLoginConfirmCodeScreen(
      {super.key, required this.loginType, required this.loginId});

  @override
  State<EditLoginConfirmCodeScreen> createState() =>
      _EditLoginConfirmCodeScreenState();
}

class _EditLoginConfirmCodeScreenState
    extends State<EditLoginConfirmCodeScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController one = TextEditingController();
  final TextEditingController two = TextEditingController();
  final TextEditingController three = TextEditingController();
  final TextEditingController four = TextEditingController();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  int seconds = 60;

  Timer? _timer;



  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        _timer!.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Confirm Code',
              style: TextStyle(
                  fontSize: 18,
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold)),
          gap(10),
          Text('This code helps us verify your identity.',
              style: TextStyle(fontSize: 14, color: primaryTextColor)),
          gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(children: [
              Expanded(
                  child: TextField(
                controller: one,
                cursorColor: Colors.grey,
                keyboardType: TextInputType.number,
                style: TextStyle(color: primaryTextColor),
                decoration: inputDecoration(),
                textAlign: TextAlign.center,
                autofocus: true,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).requestFocus(focus);
                  }
                },
              )),
              horGap(20),
              Expanded(
                  child: TextField(
                controller: two,
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey,
                style: TextStyle(color: primaryTextColor),
                decoration: inputDecoration(),
                textAlign: TextAlign.center,
                autofocus: true,
                focusNode: focus,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).requestFocus(focus1);
                  }
                },
              )),
              horGap(20),
              Expanded(
                  child: TextField(
                controller: three,
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey,
                style: TextStyle(color: primaryTextColor),
                decoration: inputDecoration(),
                textAlign: TextAlign.center,
                autofocus: true,
                focusNode: focus1,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).requestFocus(focus2);
                  }
                },
              )),
              horGap(20),
              Expanded(
                  child: TextField(
                controller: four,
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey,
                style: TextStyle(color: primaryTextColor),
                decoration: inputDecoration(),
                textAlign: TextAlign.center,
                autofocus: true,
                focusNode: focus2,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).unfocus();
                  }
                },
              )),
            ]),
          ),
          gap(30),
          Row(
            children: [
              if (seconds != 0)
                Text('Resend: ', style: TextStyle(color: primaryTextColor)),
              if (seconds != 0)
                Text(seconds.toString(), style: TextStyle(color: primaryColor)),
              if (seconds == 0)
                InkWell(
                  onTap: () {
                    seconds = 60;
                    setState(() {});
                    _timer =
                        Timer.periodic(const Duration(seconds: 1), (timer) {
                      if (seconds == 0) {
                        _timer!.cancel();
                      } else {
                        setState(() {
                          seconds--;
                        });
                      }
                    });

                    _apiServices.post(
                      context: context,
                      endpoint: 'auth/signup/send-otp',
                      body: {
                        "loginType": widget.loginType,
                        "loginId": widget.loginId
                      },
                    );
                  },
                  child: Text('Resend',
                      style: TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          decoration: TextDecoration.underline)),
                ),
            ],
          ),
          gap(30),
          fullWidthButton(
              buttonName: 'Confirm',
              onTap: () {
                if (one.text.isNotEmpty &&
                    two.text.isNotEmpty &&
                    three.text.isNotEmpty &&
                    four.text.isNotEmpty) {
                  String otp = one.text + two.text + three.text + four.text;
                  _apiServices.post(
                      context: context,
                      endpoint: 'auth/signup/confirm-otp',
                      body: {
                        "loginType": widget.loginType,
                        "loginId": widget.loginId,
                        "otp": otp
                      }).then((value) {
                    if (value['flag'] == true) {
                      ApiCalls().profile(context).then((value) {
                        Nav.pop(context);
                        Nav.pop(context);
                      });
                    } else {
                      dialog(context, value['error'] ?? value['message'], () {
                        Nav.pop(context);
                      });
                    }
                  });
                } else {
                  dialog(context, 'Enter 4 digit otp', () {
                    Nav.pop(context);
                  });
                }
              }),
        ]),
      ),
    );
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
