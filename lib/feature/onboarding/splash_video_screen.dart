import 'dart:async';

import 'package:Pulse3/app/router/app_router.dart';
import 'package:Pulse3/core/constant/asset/assets.dart';
import 'package:Pulse3/core/utils/pulse3_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

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

    _controller = VideoPlayerController.asset(AppAssets.splashIntroVideo)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      });

    _controller.addListener(_onVideoUpdate);
  }

  void _onVideoUpdate() {
    final v = _controller.value;
    if (!v.isInitialized || _navigated) return;

    final isFinished = v.duration != Duration.zero &&
        v.position >= (v.duration - const Duration(milliseconds: 200));

    if (!isFinished) return;

    _navigated = true;

    if (!mounted) return;
    context.go(AppRoutePath.gas);

    unawaited(Pulse3Helper.requestNotificationPermission());
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
