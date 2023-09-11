import 'package:bar_monkey/api_services.dart';
import 'package:bar_monkey/screens/authentication/register_screens/confirm_code_screen.dart';
import 'package:bar_monkey/widget/navigator.dart';
import 'package:flutter/material.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final ApiServices _apiServices = ApiServices();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  late FocusNode myFocusNode = FocusNode();

  bool phone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(phone ? 'What is your phone number?' : 'What is your email?',
                style: TextStyle(
                    fontSize: 18,
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold)),
            gap(10),
            Text(
                phone
                    ? 'You may receive SMS from us for security and login purposes. No one else will see your number.'
                    : 'You may receive email from us for security and login purposes. No one else will see your email.',
                style: TextStyle(fontSize: 14, color: primaryTextColor)),
            gap(30),
            Form(
                key: _key,
                child: Column(
                  children: [
                    if (!phone)
                      customTextField(_email, 'Email',
                          textInputType: TextInputType.emailAddress,
                          fillColor: Colors.grey.shade900, validator: (value) {
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)) {
                          return 'Enter a valid email.';
                        } else {
                          return null;
                        }
                      }),
                    if (phone)
                      customTextField(_phone, 'Phone number',
                          textInputType: TextInputType.phone,
                          fillColor: Colors.grey.shade900, validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a Phone no';
                        } else {
                          return null;
                        }
                      }),
                  ],
                )),
            gap(30),
            fullWidthButton(
              buttonName: 'Next',
              onTap: () async {
                // if (_key.currentState!.validate()) {
                _apiServices.post(
                    context: context,
                    endpoint: 'auth/signup/send-otp',
                    body: {
                      "loginType": phone ? 'mobile' : 'email',
                      "loginId": phone ? _phone.text : _email.text
                    }).then((value) {
                  if (value['flag'] == false) {
                    dialog(
                        context, value['error'] ?? value['message'].toString(),
                        () {
                      Nav.pop(context);
                    });
                  } else {
                    Nav.push(
                        context,
                        ConfirmCodeScreen(
                            loginType: phone ? 'mobile' : 'email',
                            loginId: phone ? _phone.text : _email.text));
                  }
                });
                // }
              },
            ),
            gap(30),
            borderedButton(
                buttonName:
                    phone ? 'Sign up with email' : 'Sign up with phone number',
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Future.delayed(const Duration(milliseconds: 150))
                      .then((value) {
                    FocusScope.of(context).requestFocus();
                  });

                  _email.clear();
                  _phone.clear();
                  _key.currentState!.reset();

                  setState(() {
                    phone = !phone;
                  });
                })
          ]),
        ),
      ),
    );
  }
}
