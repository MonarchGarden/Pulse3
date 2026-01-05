import 'package:Pulse3/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Pulse3App extends ConsumerWidget {
  const Pulse3App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pulse3',
      theme: ThemeData.dark(),
      routerConfig: router,
    );
  }
}
