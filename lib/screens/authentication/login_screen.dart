import 'package:bar_monkey/app_config/colors.dart';
import 'package:bar_monkey/screens/authentication/forgot_password.dart';
import 'package:bar_monkey/screens/authentication/register_screens/phone_number_screen.dart';
import 'package:bar_monkey/screens/tab_screens/tab_screen.dart';
import 'package:bar_monkey/widget/navigator.dart';
import 'package:bar_monkey/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api_services.dart';
import '../../widget/sahared_prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiServices _apiServices = ApiServices();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool visibility = false;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showYesNoButton(context, 'Are you sure you want to exit?', () {
          SystemNavigator.pop();
        }, () {
          Nav.pop(context);
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              statusBar(context),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Image.asset('assets/icons/BarMonkey-Logo-PNG.png')),
              gap(50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome 👋',
                          style: TextStyle(
                              fontSize: 26,
                              color: primaryTextColor,
                              fontWeight: FontWeight.w400)),
                      gap(10),
                      Text('You are about to enter the ultimate bar companion',
                          style: TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.w400)),
                      gap(25),
                      Form(
                        key: _key,
                        child: Column(children: [
                          customTextField(
                              _email, 'Email, phone number, or username',
                              validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter valid Email, Phone or Username';
                            } else {
                              return null;
                            }
                          }),
                          gap(25),
                          customTextField(_password, 'Password',
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
                        ]),
                      ),
                      gap(25),
                      fullWidthButton(
                          buttonName: 'Login',
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              _apiServices.post(
                                  context: context,
                                  endpoint: 'auth/login',
                                  body: {
                                    "loginId": _email.text,
                                    "password": _password.text
                                  }).then((value) {
                                if (value['flag'] == true) {
                                  Prefs.setPrefs('token', value['token']);
                                  Prefs.setPrefs(
                                      'userId', value['data']['_id']);
                                  Prefs.setPrefs(
                                      'firstName', value['data']['firstName']);
                                  Prefs.setPrefs(
                                      'lastName', value['data']['lastName']);
                                  Nav.pushAndRemoveAll(
                                      context, const TabScreen());
                                } else {
                                  dialog(context,
                                      value['error'] ?? value['message'], () {
                                    Nav.pop(context);
                                  });
                                }

                                _apiServices.sendFCMToken(context);
                              });
                            }
                          }),
                      gap(15),
                      Row(
                        children: [
                          Text('Forgot Password? ',
                              style: TextStyle(color: primaryTextColor)),
                          InkWell(
                              onTap: () {
                                Nav.push(context, const ForgotPasswordScreen());
                              },
                              child: Text('Recover Here',
                                  style: TextStyle(color: primaryColor))),
                        ],
                      ),
                    ]),
              ),
            ]),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0.0
            ? gap(0)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: borderedButton(
                    buttonName: 'Create Account',
                    onTap: () {
                      Nav.push(context, const PhoneNumberScreen());
                    }),
              ),
      ),
    );
  }
}
