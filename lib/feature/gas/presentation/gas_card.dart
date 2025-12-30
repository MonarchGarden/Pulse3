import 'package:Pulse3/feature/gas/domain/gas_info.dart';
import 'package:Pulse3/feature/gas/presentation/gas_level_badge.dart';
import 'package:flutter/material.dart';
import 'gas_animated_value.dart';

class GasCard extends StatelessWidget {
  final GasInfo gas;

  const GasCard({super.key, required this.gas});

  Color _levelColor(GasLevel level) {
    switch (level) {
      case GasLevel.cheap:
        return Colors.greenAccent;
      case GasLevel.normal:
        return Colors.orangeAccent;
      case GasLevel.expensive:
        return Colors.redAccent;
    }
  }

  String _levelLabel(GasLevel level) {
    switch (level) {
      case GasLevel.cheap:
        return 'CHEAP';
      case GasLevel.normal:
        return 'NORMAL';
      case GasLevel.expensive:
        return 'EXPENSIVE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Gas Price',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            GasAnimatedValue(gas: gas),
            const SizedBox(height: 20),
            GasLevelBadge(level: gas.level),
            const SizedBox(height: 20),
            const Text(
              'Read-only • No wallet • No signing',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
