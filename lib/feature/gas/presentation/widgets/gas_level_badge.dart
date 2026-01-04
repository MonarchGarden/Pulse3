import 'package:Pulse3/core/constant/enum/gas_level.dart';
import 'package:flutter/material.dart';

class GasLevelBadge extends StatelessWidget {
  final GasLevel level;

  const GasLevelBadge({super.key, required this.level});

  Color get _color {
    switch (level) {
      case GasLevel.cheap:
        return Colors.greenAccent;
      case GasLevel.normal:
        return Colors.orangeAccent;
      case GasLevel.expensive:
        return Colors.redAccent;
    }
  }

  String get _label {
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          _label,
          key: ValueKey(_label),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
