import 'package:Pulse3/core/firebase/firebase_auth_provider.dart';
import 'package:Pulse3/feature/alerts/data/firebase_alert_repository.dart';
import 'package:Pulse3/feature/alerts/domain/gas_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAlertRepoProvider = Provider((_) => FirebaseAlertRepository());

final gasAlertsProvider =
    StateNotifierProvider<GasAlertsNotifier, List<GasAlert>>(
  (ref) => GasAlertsNotifier(ref),
);

class GasAlertsNotifier extends StateNotifier<List<GasAlert>> {
  final Ref ref;

  GasAlertsNotifier(this.ref) : super([]) {
    ref.listen(authStateProvider, (_, next) {
      next.whenData((user) {
        if (user == null) return;
        ref
            .read(firebaseAlertRepoProvider)
            .watchAlerts(user.uid)
            .listen((alerts) => state = alerts);
      });
    });
  }

  void add(GasAlert alert) {
    final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
    ref.read(firebaseAlertRepoProvider).saveAlert(uid, alert);
  }

  void markTriggered(String id) {
    state = [
      for (final a in state)
        if (a.id == id) a.copyWith(triggered: true) else a
    ];
  }
}
