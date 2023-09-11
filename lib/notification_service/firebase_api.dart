import '/notification_service/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseAPI {
  final _firebaeMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    NotificationService().initNotification();
    await _firebaeMessaging.requestPermission();
    final fcmToken = await _firebaeMessaging.getToken();
    print(fcmToken);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      NotificationService().showNotification(
        title: message.notification!.title,
        body: message.notification!.body,
      );
    });
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.notification!.title);
  print(message.notification!.body);
  print(message.data);
}
