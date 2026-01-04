import 'package:Pulse3/core/constant/enum/alert_condition.dart';
import 'package:Pulse3/feature/alerts/alerts_providers.dart';
import 'package:Pulse3/feature/alerts/triggered_alert_provider.dart';
import 'package:Pulse3/feature/gas/presentation/gas_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gasAlertEngineProvider = Provider<void>((ref) {
  ref.listen(
    gasStreamProvider,
    (prev, next) {
      next.whenData((gas) {
        final alerts = ref.read(gasAlertsProvider);
        final chain = ref.read(selectedChainProvider);

        for (final alert in alerts) {
          if (alert.triggered) continue;
          if (alert.chain != chain) continue;

          final triggered = switch (alert.condition) {
            AlertCondition.below =>
              (gas.gwei * 100).round() < (alert.threshold * 100).round(),
            AlertCondition.above =>
              (gas.gwei * 100).round() > (alert.threshold * 100).round(),
          };

          if (triggered) {
            ref.read(gasAlertsProvider.notifier).markTriggered(alert.id);

            ref.read(triggeredAlertProvider.notifier).state = alert;
          }
        }
      });
    },
  );
});
