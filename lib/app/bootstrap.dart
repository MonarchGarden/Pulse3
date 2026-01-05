import 'dart:async';

import 'package:Pulse3/feature/pulse3_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> bootstrap() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);

      if (kDebugMode) {
        debugPrint('FlutterError: ${details.exceptionAsString()}');
        debugPrintStack(stackTrace: details.stack);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('Uncaught (PlatformDispatcher): $error');
        debugPrintStack(stackTrace: stack);
      }
      return true;
    };

    runApp(const ProviderScope(child: Pulse3App()));
  }, (error, stack) {
    if (kDebugMode) {
      debugPrint('Uncaught (Zone): $error');
      debugPrintStack(stackTrace: stack);
    }
  });
}
