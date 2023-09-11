import 'package:bar_monkey/app_config/colors.dart';
import 'package:bar_monkey/screens/authentication/login_screen.dart';
import 'package:bar_monkey/screens/tab_screens/tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      getToken().then((value) {
        if (value == null) {
          Nav.pushAndRemoveAll(context, const LoginScreen());
        } else {
          Nav.pushAndRemoveAll(context, const TabScreen());
        }
      });
    });
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
          child: Image.asset('assets/icons/BarMonkey-Logo-PNG.png')),
    );
  }
}
