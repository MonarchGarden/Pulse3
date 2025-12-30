import 'package:Pulse3/feature/alerts/domain/gas_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gasAlertsProvider =
    StateNotifierProvider<GasAlertsNotifier, List<GasAlert>>(
  (ref) => GasAlertsNotifier(),
);

class GasAlertsNotifier extends StateNotifier<List<GasAlert>> {
  GasAlertsNotifier() : super([]);

  void add(GasAlert alert) {
    state = [...state, alert];
  }

  void markTriggered(String id) {
    state = [
      for (final a in state)
        if (a.id == id) a.copyWith(triggered: true) else a
    ];
  }
}
