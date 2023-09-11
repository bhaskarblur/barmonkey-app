import 'package:bar_monkey/api_services.dart';
import 'package:bar_monkey/screens/authentication/register_screens/first_name_screen.dart';
import 'package:bar_monkey/widget/sahared_prefs.dart';
import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class SetPassScreen extends StatefulWidget {
  const SetPassScreen({super.key});

  @override
  State<SetPassScreen> createState() => _SetPassScreenState();
}

class _SetPassScreenState extends State<SetPassScreen> {
  final ApiServices _apiServices = ApiServices();

  final GlobalKey<FormState> _passKey = GlobalKey<FormState>();
  bool visibility = false;
  bool visibility2 = false;
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Form(
            key: _passKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Password',
                  style: TextStyle(
                      fontSize: 18,
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold)),
              gap(10),
              Text('No one will know your password, not even us...',
                  style: TextStyle(fontSize: 14, color: primaryTextColor)),
              gap(30),
                  customTextField(password, 'Password',
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password should be of 6 or more characters';
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
              gap(20),
              customTextField(confirmPassword, 'Confirm Password',
                  validator: (value) {
                if (value != confirmPassword.text) {
                  return 'Password doesn\'t match';
                } else {
                  return null;
                }
              },
                  suffixIcon: InkWell(
                  onTap: () {
            setState(() {
              visibility2 = !visibility2;
            });
            },
            child: Icon(
              visibility2
                  ? Icons.visibility
                  : Icons.visibility_off,
              color:
              visibility2 ? primaryColor : Colors.grey,
            )),
          visibility: !visibility2),
              gap(30),
              fullWidthButton(
                  buttonName: 'Next',
                  onTap: () {
                    Prefs.getToken().then((token) {
                      if (_passKey.currentState!.validate()) {
                        _apiServices.post(
                            context: context,
                            endpoint: 'auth/signup/password',
                            body: {"password": password.text}).then((value) {
                          if (value['flag'] == true) {
                            Nav.push(context, const Firstname());
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
          ),
        ]),
      ),
    );
  }
}
