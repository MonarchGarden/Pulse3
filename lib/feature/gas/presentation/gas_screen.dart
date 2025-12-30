import 'package:Pulse3/feature/alerts/domain/gas_alert.dart';
import 'package:Pulse3/feature/alerts/triggered_alert_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'gas_providers.dart';
import 'gas_card.dart';
import 'gas_skeleton.dart';

class GasScreen extends ConsumerStatefulWidget {
  const GasScreen({super.key});

  @override
  ConsumerState<GasScreen> createState() => _GasScreenState();
}

class _GasScreenState extends ConsumerState<GasScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<GasAlert?>(
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final gasAsync = ref.watch(gasStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulse3 • Gas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(gasStreamProvider),
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
