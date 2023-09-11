import 'package:bar_monkey/api_services.dart';
import 'package:bar_monkey/screens/tab_screens/tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class LocationService extends StatefulWidget {
  const LocationService({super.key});

  @override
  State<LocationService> createState() => _LocationServiceState();
}

class _LocationServiceState extends State<LocationService> {
  final ApiServices _apiServices = ApiServices();

  String? lat;
  String? lon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Text('Enable location services',
              style: TextStyle(
                  fontSize: 18,
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold)),
          gap(10),
          Text(
              'Your feed will populate bars and venues relevant to you based on your location. We value your privacy.',
              style: TextStyle(fontSize: 14, color: primaryTextColor),
              textAlign: TextAlign.center),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            fullWidthButton(
                buttonName: 'Turn On',
                onTap: () {
                  turnOnLocation();
                }),
            gap(20),
            borderedButton(
                buttonName: 'Skip',
                onTap: () {
                  if (lat != null && lon != null) {
                    Nav.pushAndRemoveAll(context, const TabScreen());
                  } else {
                    dialog(context, 'Cannot locate you.', () {
                      Nav.pop(context);
                    });
                  }
                })
          ],
        ),
      ),
    );
  }

  turnOnLocation() async {
    Location location = Location();

    bool _serviceEnabled;

    _serviceEnabled = await location.serviceEnabled();
    print(_serviceEnabled);

    if (_serviceEnabled == true) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const TabScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ));
    } else {
      // ignore: use_build_context_synchronously
      showYesNoButton(context, 'Want to enable location service?', () {
        Nav.pop(context);
        Geolocator.openLocationSettings().then((value) async {
          _apiServices.getLocation().then((value) {
            lat = value.latitude.toString();
            lon = value.longitude.toString();

            if (lat != null && lon != null) {
              _apiServices.patch(
                context: context,
                endpoint: 'user/location',
                body: {
                  "location": {"latitude": lat, "longitude": lon}
                },
              ).then((value) {
                if (value['flag'] == true) {
                  Nav.pushAndRemoveAll(context, const TabScreen());
                } else {
                  dialog(context, value['error'] ?? value['message'], () {
                    Nav.pop(context);
                  });
                }
              });
            } else {
              dialog(context, 'Cannot locate you.', () {
                Nav.pop(context);
              });
            }
          });
        });
      }, () {
        Nav.pop(context);
      });
    }
  }
}
