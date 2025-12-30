import 'gas_trend.dart';

enum GasLevel { cheap, normal, expensive }

class GasInfo {
  final double gwei;
  final GasLevel level;
  final GasTrend trend;

  GasInfo({
    required this.gwei,
    required this.level,
    required this.trend,
  });
}
