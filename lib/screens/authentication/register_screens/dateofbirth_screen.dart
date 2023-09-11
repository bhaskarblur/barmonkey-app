import '/screens/authentication/register_screens/fav_drink_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class DateOfBirthScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  const DateOfBirthScreen(
      {super.key, required this.firstName, required this.lastName});

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(backgroundColor: backgroundColor),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Confirm your date of birth',
                  style: TextStyle(
                      fontSize: 18,
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold)),
              gap(10),
              Text(
                  'This won’t be a part of your profile. We need to verify if you are old enough for this app.',
                  style: TextStyle(fontSize: 14, color: primaryTextColor)),
              gap(30),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: InkWell(
                  onTap: () async {
                    _date = await showDatePicker(
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary:
                                    primaryColor, // header background color
                                onPrimary: Colors.black, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.blue, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1923, 8),
                        lastDate: DateTime.now());
                    setState(() {});
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: textFieldColor),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(
                              _date == null
                                  ? 'MM-DD-YYY'
                                  : DateFormat('MM-dd-yyyy').format(_date!),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            gap(30),
            fullWidthButton(
                buttonName: 'Next',
                onTap: () {
                  Nav.push(
                      context,
                      FavDrinkScreen(
                          firstName: widget.firstName,
                          lastName: widget.lastName,
                          date: _date.toString()));
                }),
          ]),
        ));
  }
}
