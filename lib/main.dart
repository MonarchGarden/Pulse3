import 'package:Pulse3/feature/Pulse3App.dart';
import 'package:Pulse3/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();
  await messaging.subscribeToTopic("gas-alerts");

  runApp(const ProviderScope(child: Pulse3App()));
}
