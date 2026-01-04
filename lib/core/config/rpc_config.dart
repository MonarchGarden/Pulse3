import 'package:Pulse3/features/gas/domain/chain.dart';

class RpcConfig {
  static const Map<Chain, String> rpcUrls = {
    Chain.ethereum: 'https://ethereum.publicnode.com',
    Chain.arbitrum: 'https://arbitrum.publicnode.com',
    Chain.base: 'https://base.publicnode.com',
    Chain.polygon: 'https://polygon.publicnode.com',
    Chain.optimism: 'https://optimism.publicnode.com',
  };
}
