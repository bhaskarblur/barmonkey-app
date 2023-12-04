import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app_config/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_config/app_details.dart';
import 'navigator.dart';

Widget gap(double height) {
  return SizedBox(height: height);
}

Widget horGap(double width) {
  return SizedBox(width: width);
}

Widget fullWidthButton(
    {required String buttonName, required void Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
          child: Text(buttonName,
              style: TextStyle(
                  color: backgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
    ),
  );
}

Widget borderedButton(
    {required String buttonName,
    required void Function() onTap,
    double? width}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(buttonName,
                style: TextStyle(color: primaryColor, fontSize: 16)),
          ),
        )),
  );
}

Widget borderedWhiteButton(
    {required String buttonName,
      required void Function() onTap,
      double? width}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
            border: Border.all(color: primaryTextColor),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(buttonName,
                style: TextStyle(color: primaryTextColor, fontSize: 16)),
          ),
        )),
  );
}
Widget customTextField(TextEditingController controller, String hintText,
    {IconData? leading,
    Color fillColor = Colors.black,
    String? Function(String?)? validator,
    Widget suffixIcon = const SizedBox(),
    bool visibility = false,
    Color backgroundColor = Colors.white,
    bool enabled = true,
    TextInputType? textInputType = TextInputType.emailAddress,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), color: Colors.black),
    child: TextFormField(
      controller: controller,
      cursorColor: primaryTextColor,
      style: TextStyle(color: primaryTextColor),
      obscureText: visibility,
      enabled: enabled,
      keyboardType: textInputType,
      decoration: leading != null
          ? InputDecoration(
              filled: true,
              fillColor: fillColor,
              hintText: hintText,
              errorStyle: const TextStyle(fontWeight: FontWeight.bold),
              prefixIcon: Icon(leading, color: primaryColor),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              suffixIcon: suffixIcon,
              contentPadding: padding,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5)))
          : InputDecoration(
              filled: true,
              fillColor: fillColor,
              hintText: hintText,
              suffixIcon: suffixIcon,
              errorStyle: const TextStyle(fontWeight: FontWeight.bold),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              contentPadding: padding,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5))),
      validator: validator,
    ),
  );
}

loader(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(width: 20),
                  Text('Loading...',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor))
                ],
              ),
            ),
          ),
        );
      });
}

dialog(BuildContext context, String message, void Function()? onOk) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          contentPadding: const EdgeInsets.all(15),
          title: Text(appName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(message.toString(),
              maxLines: 5,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            InkWell(
              onTap: onOk,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Ok',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black)),
                ),
              ),
            ),
          ],
        );
      });
}

internetBanner(BuildContext context, String message, void Function()? onOk) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          contentPadding: const EdgeInsets.all(15),
          title: const Text('Alert',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 100, color: Colors.white),
              Text(message,
                  maxLines: 5,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: InkWell(
                onTap: onOk,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryColor),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Ok',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black)),
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

showYesNoButton(BuildContext context, String message, void Function()? onYes,
    void Function()? onNo) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          contentPadding: const EdgeInsets.all(15),
          title: Text(appName, style: TextStyle(color: primaryTextColor)),
          content: Text(message,
              maxLines: 5, style: TextStyle(color: primaryTextColor)),
          actions: [
            InkWell(
              onTap: onYes,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Yes',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: backgroundColor)),
                ),
              ),
            ),
            horGap(10),
            InkWell(
              onTap: onNo,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('No',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: backgroundColor)),
                ),
              ),
            ),
          ],
        );
      });
}

dateFormetterFromString(String date) {
  return DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString();
}

Widget actionButton(Color color, IconData icon, void Function()? onTap) {
  return Expanded(
      child: InkWell(
    onTap: onTap,
    child: Container(
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color)),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(name,
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          // SizedBox(width: 5),
          Icon(icon, color: color, size: 24)
        ],
      )),
    ),
  ));
}

statusBar(context) {
  return SizedBox(height: MediaQuery.of(context).viewPadding.top + 20);
}

Widget tile(String title, String image, void Function()? onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SizedBox(height: 30, width: 30, child: Image.asset(image)),
            horGap(20),
            Text(title,
                style: TextStyle(
                    fontSize: 16,
                    color: primaryTextColor,
                    fontWeight: FontWeight.normal)),
          ]),
          Icon(Icons.keyboard_arrow_right_rounded,
              color: primaryTextColor, size: 36),
        ],
      ),
    ),
  );
}

Widget settingsAppBar(BuildContext context, String title,
    {Widget? actionButton}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
    child: Column(children: [
      statusBar(context),
      Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Nav.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.keyboard_arrow_left,
                        color: primaryColor, size: 24),
                    horGap(3),
                    Text('Settings',
                        style: TextStyle(color: primaryColor, fontSize: 16)),
                  ],
                )),
            actionButton ?? gap(0)
          ],
        ),
        Align(
            alignment: Alignment.center,
            child: Text(title,
                style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
      ]),
      gap(20),
    ]),
  );
}

Widget card(String title, String subtitle, String image, bool border,
    void Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(color: border ? primaryColor : Colors.transparent),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child:
                    SizedBox(height: 40, width: 40, child: Image.asset(image))),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    gap(5),
                    Text(subtitle, style: TextStyle(color: primaryTextColor)),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

Widget logincard(String title, String image, bool border,
    void Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(color: border ? primaryColor : Colors.transparent),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child:
                SizedBox(height: 40, width: 40, child:
                IconButton(icon: SvgPicture.asset(
                    image,
                    semanticsLabel: 'Label'
                ), onPressed: () {  })
                )),

            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal)),
                    gap(5),
                  ],
                ))
            ],
        ),
      ),
    ),
  );
}

Widget friendsTile(dynamic image, String title, String subtitle,
    {String? buttonName, void Function()? onTap, bool sent = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: SizedBox(
              height: 45,
              width: 45,
              child: image == null || image == ''
                  ? Image.asset('assets/images/profile_pic.png',
                      fit: BoxFit.cover)
                  : Image.network(userImageUrl + image,
                      fit: BoxFit.cover)),
        ),
        horGap(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(toBeginningOfSentenceCase(title)!,
                style: TextStyle(color: primaryTextColor)),
            Text(subtitle, style: TextStyle(color: primaryColor))
          ],
        ),
      ]),
      buttonName == null
          ? gap(0)
          : InkWell(
              onTap: onTap,
              child: Container(
                  width: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: sent ? primaryColor : Colors.transparent),
                      color: sent ? backgroundColor : primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(buttonName,
                          style: TextStyle(
                              color: sent ? primaryColor : Colors.black)),
                    ),
                  )),
            )
    ],
  );
}

urlLauncher(String url, BuildContext context) async {
  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print(e);
    dialog(context, 'Cannot launch URL.', () {
      Nav.pop(context);
    });
  }
}

void openCustomDialog(BuildContext context, String image) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
              opacity: a1.value,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.contain)))
                  ],
                ),
              )),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return gap(0);
      });
}
