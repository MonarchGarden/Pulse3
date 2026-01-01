import 'package:Pulse3/core/firebase/firebase_auth_provider.dart';
import 'package:Pulse3/feature/alerts/alerts_engine.dart';
import 'package:Pulse3/feature/alerts/domain/gas_alert.dart';
import 'package:Pulse3/feature/alerts/presentation/add_gas_alert_sheet.dart';
import 'package:Pulse3/feature/alerts/triggered_alert_provider.dart';
import 'package:Pulse3/feature/gas/gas_provider.dart';
import 'package:Pulse3/feature/gas/presentation/gas_card.dart';
import 'package:Pulse3/feature/gas/presentation/gas_skeleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GasScreen extends ConsumerStatefulWidget {
  const GasScreen({super.key});

  @override
  ConsumerState<GasScreen> createState() => _GasScreenState();
}

class _GasScreenState extends ConsumerState<GasScreen> {
  late final ProviderSubscription<GasAlert?> _alertSub;

  @override
  void initState() {
    super.initState();

    _alertSub = ref.listenManual<GasAlert?>(
      triggeredAlertProvider,
      (prev, next) {
        if (next == null) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Gas Alert Triggered'),
            content: Text(
              'Gas is now ${next.condition == AlertCondition.below ? 'below' : 'above'} '
              '${next.threshold} GWEI on ${next.chain.name}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(triggeredAlertProvider.notifier).state = null;
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _alertSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gasAsync = ref.watch(gasStreamProvider);
    ref.watch(gasAlertEngineProvider);

    ref.listen(authStateProvider, (_, next) {
      next.whenData((user) {
        if (user == null) {
          FirebaseAuth.instance.signInAnonymously();
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulse3 • Gas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const AddGasAlertSheet(),
              );
            },
          ),
        ],
      ),
      body: gasAsync.when(
        loading: () => const GasSkeleton(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (gas) => Center(child: GasCard(gas: gas)),
      ),
    );
  }
}
