import 'package:bar_monkey/api_services.dart';
import 'package:bar_monkey/app_config/colors.dart';
import 'package:bar_monkey/widget/navigator.dart';
import 'package:bar_monkey/widget/widgets.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Forgot Password?',
              style: TextStyle(fontSize: 18, color: primaryTextColor)),
          gap(10),
          Text('Don’t worry, we can help you recover it.',
              style: TextStyle(fontSize: 12, color: primaryTextColor)),
          gap(30),
          customTextField(_email, 'Email or Phone Number'),
          gap(30),
          fullWidthButton(
              buttonName: 'Send Recovery Link',
              onTap: () {
                _apiServices.post(
                    context: context,
                    endpoint: 'auth/recovery-link',
                    body: {"loginId": _email.text}).then((value) {
                  if (value['flag'] == true) {
                    dialog(context, value['message'], () {
                      Nav.pop(context);
                      Nav.pop(context);
                    });
                  } else {
                    dialog(context, value['error'] ?? value['message'], () {
                      Nav.pop(context);
                      Nav.pop(context);
                    });
                  }
                });
              })
        ]),
      ),
    );
  }
}
