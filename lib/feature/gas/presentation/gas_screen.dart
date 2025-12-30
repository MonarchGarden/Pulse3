import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'gas_providers.dart';
import 'gas_card.dart';
import 'gas_skeleton.dart';

class GasScreen extends ConsumerWidget {
  const GasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
