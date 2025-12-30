import 'package:Pulse3/feature/gas/gas_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'last_updated_provider.dart';

class LastUpdatedText extends ConsumerWidget {
  const LastUpdatedText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(lastUpdatedTickerProvider);

    final lastUpdated = ref.watch(lastUpdatedAtProvider);

    if (lastUpdated == null) return const SizedBox.shrink();

    final seconds = DateTime.now().difference(lastUpdated).inSeconds;

    return Text(
      'Last updated ${_format(seconds)} ago',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  String _format(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    return '${minutes}m';
  }
}
