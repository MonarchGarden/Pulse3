import 'package:Pulse3/core/constant/enum/chain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeChainProvider = StateProvider<Chain>((ref) {
  return Chain.ethereum;
});
