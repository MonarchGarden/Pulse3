import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Pulse3/features/gas/domain/chain.dart';

final activeChainProvider = StateProvider<Chain>((ref) {
  return Chain.ethereum;
});
