enum Chain {
  ethereum,
  arbitrum,
  base,
  polygon,
  optimism,
}

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
