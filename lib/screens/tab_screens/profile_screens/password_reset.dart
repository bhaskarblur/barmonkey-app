import '/api_services.dart';
import '/widget/navigator.dart';
import 'package:flutter/material.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final ApiServices _apiServices = ApiServices();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController rewritePassword = TextEditingController();

  bool visibility1 = false;
  bool visibility2 = false;
  bool visibility3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            settingsAppBar(context, 'Password Reset'),
            gap(30),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _key,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Want to change your password?',
                              style: TextStyle(
                                  color: primaryTextColor, fontSize: 16)),
                          gap(30),
                          tf(
                              currentPassword,
                              'Current Password',
                              (value) {
                                if (value!.isEmpty) {
                                  return 'Enter current password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters.';
                                } else {
                                  return null;
                                }
                              },
                              visibility1,
                              () {
                                visibility1 = !visibility1;
                                setState(() {});
                              }),
                          gap(20),
                          tf(
                              newPassword,
                              'New Password',
                              (value) {
                                if (value!.isEmpty) {
                                  return 'Enter new password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters.';
                                } else {
                                  return null;
                                }
                              },
                              visibility2,
                              () {
                                visibility2 = !visibility2;
                                setState(() {});
                              }),
                          gap(20),
                          tf(
                              rewritePassword,
                              'New Password',
                              (value) {
                                if (value != newPassword.text) {
                                  return 'Password does not match';
                                } else {
                                  return null;
                                }
                              },
                              visibility3,
                              () {
                                visibility3 = !visibility3;
                                setState(() {});
                              }),
                          gap(30),
                          fullWidthButton(
                              buttonName: 'Save Password',
                              onTap: () {
                                _apiServices.post(
                                    context: context,
                                    endpoint: 'auth/change-password',
                                    body: {
                                      "currentPassword": currentPassword.text,
                                      "newPassword": newPassword.text
                                    }).then((value) {
                                  if (value['flag'] == true) {
                                    dialog(context, value['message'], () {
                                      Nav.pop(context);
                                    });
                                  } else {
                                    dialog(context, value['error'], () {
                                      Nav.pop(context);
                                    });
                                  }
                                });
                              })
                        ]),
                  ),
                )),
          ],
        ));
  }

  Widget tf(
      TextEditingController controller,
      String hintText,
      String? Function(String?)? validator,
      bool visibility,
      void Function()? onTap) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        controller: controller,
        cursorColor: primaryTextColor,
        style: TextStyle(color: primaryTextColor),
        obscureText: !visibility,
        decoration: InputDecoration(
            filled: true,
            fillColor: textFieldColor,
            hintText: hintText,
            prefixIcon: Icon(Icons.lock, color: primaryColor),
            suffixIcon: InkWell(
                onTap: onTap,
                child: Icon(
                    visibility ? Icons.visibility : Icons.visibility_off,
                    color: visibility ? primaryColor : Colors.grey)),
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            )),
        validator: validator,
      ),
    );
  }
}
