import 'dart:convert';
import 'dart:io';
import '/providers/map_provider.dart';
import '/widget/navigator.dart';
import '/widget/sahared_prefs.dart';
import '/widget/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:label_marker/label_marker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config/app_details.dart';

class ApiServices {
  Future<dynamic> get(
      {required BuildContext context,
      required String endpoint,
      bool progressBar = true}) async {
    var response = 'null';
    bool connected = await connectedOrNot(context);
    debugPrint(endpoint);

    String? token = await Prefs.getToken();
    debugPrint(token);

    if (connected) {
      if (progressBar) {
        loader(context);
      }
      var res = await http.get(
        Uri.parse(baseUrl + endpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (progressBar) {
        Nav.pop(context);
      }
      debugPrint(endpoint + res.body);
      response = res.body;
    }
    return jsonDecode(response);
  }

  Future<dynamic> post(
      {required BuildContext context,
      required String endpoint,
      var body,
      bool progressBar = true}) async {
    var response = 'null';
    bool connected = await connectedOrNot(context);
    String? token = await Prefs.getToken();

    debugPrint(endpoint + body.toString());
    debugPrint(token);

    if (connected) {
      if (progressBar) {
        loader(context);
      }
      var res = await http.post(Uri.parse(baseUrl + endpoint),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(body));
      if (progressBar) {
        Nav.pop(context);
      }

      debugPrint(endpoint + res.body);
      response = res.body;
    }
    return jsonDecode(response);
  }

  Future<dynamic> patch(
      {required BuildContext context,
      required String endpoint,
      var body,
      bool progressBar = true}) async {
    var response = 'null';

    bool connected = await connectedOrNot(context);

    String? token = await Prefs.getToken();

    debugPrint(body.toString());

    if (connected) {
      if (progressBar) {
        loader(context);
      }
      var res = await http.patch(Uri.parse(baseUrl + endpoint),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(body));
      if (progressBar) {
        Nav.pop(context);
      }

      debugPrint(res.body);

      response = res.body;
    }

    return jsonDecode(response);
  }

  Future<dynamic> delete(
      {required BuildContext context,
      required String endpoint,
      bool progressBar = true}) async {
    var response = 'null';

    bool connected = await connectedOrNot(context);
    String? token = await Prefs.getToken();

    print(endpoint);
    print(token);

    if (connected) {
      if (progressBar) {
        loader(context);
      }
      var res = await http.delete(Uri.parse(baseUrl + endpoint),
          headers: {"Authorization": "Bearer $token"});
      if (progressBar) {
        Nav.pop(context);
      }

      debugPrint(res.body);

      response = res.body;
    }

    return jsonDecode(response);
  }

  Future<bool> connectedOrNot(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        internetBanner(context, 'No Internet Connection!', () {
          Nav.pop(context);
        });

        return false;
      }
    } on SocketException catch (_) {
      internetBanner(context, 'No Internet Connection!', () {
        Nav.pop(context);
      });
      return false;
    }
  }

  Future<bool> imageUpload(BuildContext context, File file, String uploadUrl,
      {bool update = false}) async {
    loader(context);
    print(uploadUrl);
    final prefs = await SharedPreferences.getInstance();
    debugPrint(file.path.split('/')[file.path.split('/').length - 1]);

    bool ck = false;
    final url = Uri.parse(uploadUrl);
    var request = http.MultipartRequest(update ? 'PATCH' : 'POST', url);
    var pic = await http.MultipartFile.fromPath("image", file.path);
    request.headers['Authorization'] = 'Bearer ${prefs.getString('token')!}';

    request.files.add(pic);
    var response = await request.send();

    debugPrint(response.stream.toString());
    debugPrint(response.statusCode.toString());

    var dt = await response.stream.bytesToString();

    debugPrint(dt);

    if (response.statusCode == 200) {
      ck = true;
    } else {
      ck = false;
    }
    Nav.pop(context);
    return ck;
  }

  getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location Service are Disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Service are Disabled.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are permanently denied, We cannot request ');
    }

    return await Geolocator.getCurrentPosition();
  }

  getCurrentLocation(BuildContext context) {
    getLocation().then((value1) {
      // final provider = Provider.of<MapProvider>(context, listen: false);

      // provider.changeCurrentPosition(LabelMarker(
      //     label: 'You',
      //     markerId: const MarkerId('You'),
      //     position: LatLng(value1.latitude, value1.longitude)));

      patch(
        progressBar: false,
        context: context,
        endpoint: 'user/location',
        body: {
          "location": {
            "latitude": value1.latitude.toString(),
            "longitude": value1.longitude.toString()
          }
        },
      ).then((value) {
        // provider.removeMarker('You');
        // provider.addMarker(LabelMarker(
        //     label: 'You',
        //     markerId: const MarkerId('You'),
        //     position: LatLng(value1.latitude, value1.longitude)));
      });
    });
  }

  sendFCMToken(BuildContext context) {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      print(token);
      patch(
          context: context,
          endpoint: 'user',
          body: {"fcm_token": token},
          progressBar: false);
    });
  }
}
