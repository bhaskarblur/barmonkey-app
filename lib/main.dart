import '/notification_service/firebase_api.dart';
import '/providers/bars_provider.dart';
import '/providers/friend_provider.dart';
import '/providers/home_screen_provider.dart';
import '/providers/map_provider.dart';
import '/providers/profile_provider.dart';
import '/providers/serch_provider.dart';
import '/screens/authentication/splash_screen.dart';
import '/widget/sahared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAPI().initNotification();

  Prefs.getToken().then((value) {
    debugPrint('token: $value');
  });
  Prefs.getPrefs('userId').then((value) {
    debugPrint('userId: $value');
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SearchProvider()),
    ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => BarsProvider()),
    ChangeNotifierProvider(create: (_) => FriendProvider()),
    ChangeNotifierProvider(create: (_) => MapProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar Monkey',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const SplashScreen(),
    );
  }
}
