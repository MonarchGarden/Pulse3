import 'package:Pulse3/feature/gas/domain/gas_info.dart';
import 'package:Pulse3/feature/gas/presentation/gas_trend_indicator.dart';
import 'package:flutter/material.dart';

class GasAnimatedValue extends StatelessWidget {
  final GasInfo gas;

  const GasAnimatedValue({super.key, required this.gas});

  @override
  Widget build(BuildContext context) {
    final value = gas.gwei.toStringAsFixed(3);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Row(
        key: ValueKey(value),
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value GWEI',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          GasTrendIndicator(trend: gas.trend),
        ],
      ),
    );
  }
}
