import 'package:Pulse3/feature/gas/presentation/providers/chain_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Pulse3/feature/gas/domain/chain.dart';

class ChainSelectorSheet extends ConsumerWidget {
  const ChainSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChain = ref.watch(activeChainProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Network',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...Chain.values.map((chain) {
            final isSelected = chain == activeChain;
            return ListTile(
              title: Text(chain.label),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                ref.read(activeChainProvider.notifier).state = chain;
                Navigator.of(context).pop();
              },
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
