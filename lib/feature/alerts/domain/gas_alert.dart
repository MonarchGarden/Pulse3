import 'package:Pulse3/core/constant/enum/alert_condition.dart';
import 'package:Pulse3/core/constant/enum/chain.dart';

class GasAlert {
  final String id;
  final Chain chain;
  final AlertCondition condition;
  final double threshold;
  final bool triggered;

  GasAlert({
    required this.id,
    required this.chain,
    required this.condition,
    required this.threshold,
    this.triggered = false,
  });

  GasAlert copyWith({
    bool? triggered,
  }) {
    return GasAlert(
      id: id,
      chain: chain,
      condition: condition,
      threshold: threshold,
      triggered: triggered ?? this.triggered,
    );
  }
}
