import 'package:Pulse3/app/router/app_router.dart';
import 'package:Pulse3/feature/gas/presentation/gas_screen.dart';
import 'package:Pulse3/feature/onboarding/splash_video_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutePath.splash,
    routes: [
      GoRoute(
        path: AppRoutePath.splash,
        builder: (context, state) => const SplashVideoScreen(),
      ),
      GoRoute(
        path: AppRoutePath.gas,
        builder: (context, state) => const GasScreen(),
      ),
    ],
  );
});
