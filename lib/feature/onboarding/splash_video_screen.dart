import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:Pulse3/feature/gas/presentation/gas_screen.dart';

class SplashVideoScreen extends StatefulWidget {
  const SplashVideoScreen({super.key});

  @override
  State<SplashVideoScreen> createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> {
  late final VideoPlayerController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/splash/intro.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      });

    _controller.addListener(_onVideoUpdate);
  }

  void _onVideoUpdate() async {
    final v = _controller.value;
    if (!v.isInitialized) return;

    if (v.position >= v.duration && !_navigated) {
      _navigated = true;
      await _requestNotificationPermission();
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GasScreen()),
      );
    }
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await Permission.notification.request();

      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = _controller.value;
    final initialized = v.isInitialized;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            opacity: initialized ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            child: initialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: v.size.width,
                      height: v.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
