import 'package:Pulse3/feature/alerts/firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'domain/gas_alert.dart';

final gasAlertsProvider =
    StateNotifierProvider<GasAlertsNotifier, List<GasAlert>>(
  (ref) => GasAlertsNotifier(ref.read(firestoreProvider)),
);

class GasAlertsNotifier extends StateNotifier<List<GasAlert>> {
  GasAlertsNotifier(this._firestore) : super([]);

  final FirebaseFirestore _firestore;

  Future<void> add(GasAlert alert) async {
    state = [...state, alert];

    await _firestore.collection('gasAlerts').doc(alert.id).set({
      'chain': alert.chain.name,
      'condition': alert.condition.name,
      'threshold': alert.threshold,
      'enabled': true,
      'createdAt': FieldValue.serverTimestamp(),
      'lastTriggeredAt': null,
    });
  }

  void markTriggered(String alertId) {
    state = [
      for (final alert in state)
        if (alert.id == alertId) alert.copyWith(triggered: true) else alert,
    ];
  }
}
