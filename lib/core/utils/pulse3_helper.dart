import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class Pulse3Helper {
  static Future<void> requestNotificationPermission() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await Permission.notification.request();

      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
}
