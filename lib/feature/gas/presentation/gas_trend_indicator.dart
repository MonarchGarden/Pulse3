import 'package:Pulse3/feature/gas/domain/gas_trend.dart';
import 'package:flutter/material.dart';

class GasTrendIndicator extends StatelessWidget {
  final GasTrend trend;

  const GasTrendIndicator({super.key, required this.trend});

  IconData get _icon {
    switch (trend) {
      case GasTrend.up:
        return Icons.arrow_upward;
      case GasTrend.down:
        return Icons.arrow_downward;
      case GasTrend.flat:
        return Icons.remove;
    }
  }

  Color get _color {
    switch (trend) {
      case GasTrend.up:
        return Colors.redAccent;
      case GasTrend.down:
        return Colors.greenAccent;
      case GasTrend.flat:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: Icon(
        _icon,
        key: ValueKey(trend),
        size: 20,
        color: _color,
      ),
    );
  }
}
