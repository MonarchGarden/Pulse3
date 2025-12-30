import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Pulse3/feature/alerts/alerts_providers.dart';
import 'package:Pulse3/feature/alerts/triggered_alert_provider.dart';
import 'package:Pulse3/feature/gas/presentation/gas_providers.dart';
import 'domain/gas_alert.dart';

final gasAlertEngineProvider = Provider<void>((ref) {
  final gasAsync = ref.watch(gasStreamProvider);
  final alerts = ref.watch(gasAlertsProvider);
  final selectedChain = ref.watch(selectedChainProvider);

  gasAsync.whenData((gas) {
    for (final alert in alerts) {
      if (alert.triggered) continue;
      if (alert.chain != selectedChain) continue;

      final triggered = switch (alert.condition) {
        AlertCondition.below => gas.gwei < alert.threshold,
        AlertCondition.above => gas.gwei > alert.threshold,
      };

      if (triggered) {
        ref.read(gasAlertsProvider.notifier).markTriggered(alert.id);
        ref.read(triggeredAlertProvider.notifier).state = alert;
      }
    }
  });
});
