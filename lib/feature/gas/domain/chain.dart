import 'package:Pulse3/core/constant/enum/chain.dart';

extension ChainX on Chain {
  String get label {
    switch (this) {
      case Chain.ethereum:
        return 'Ethereum';
      case Chain.arbitrum:
        return 'Arbitrum';
      case Chain.base:
        return 'Base';
      case Chain.polygon:
        return 'Polygon';
      case Chain.optimism:
        return 'Optimism';
    }
  }
}
