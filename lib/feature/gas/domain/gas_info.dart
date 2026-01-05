import 'package:Pulse3/core/constant/enum/gas_level.dart';

import 'gas_trend.dart';

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
