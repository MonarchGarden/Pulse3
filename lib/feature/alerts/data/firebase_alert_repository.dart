import 'package:Pulse3/feature/alerts/domain/gas_alert.dart';
import 'package:Pulse3/feature/gas/domain/chain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAlertRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('alerts');

  Future<void> saveAlert(String uid, GasAlert alert) {
    return _col(uid).doc(alert.id).set({
      'chain': alert.chain.name,
      'condition': alert.condition.name,
      'threshold': alert.threshold,
      'triggered': alert.triggered,
    });
  }

  Stream<List<GasAlert>> watchAlerts(String uid) {
    return _col(uid).snapshots().map(
          (snap) => snap.docs.map((d) {
            final data = d.data();
            return GasAlert(
              id: d.id,
              chain: Chain.values.byName(data['chain']),
              condition: AlertCondition.values.byName(data['condition']),
              threshold: (data['threshold'] as num).toDouble(),
              triggered: data['triggered'] ?? false,
            );
          }).toList(),
        );
  }
}
