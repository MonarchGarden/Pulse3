import 'dart:async';
import 'package:Pulse3/core/constant/enum/chain.dart';
import 'package:Pulse3/feature/gas/data/gas_remote_data_source.dart';
import 'package:Pulse3/feature/gas/domain/gas_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gasRemoteDataSourceProvider = Provider((ref) => GasRemoteDataSource());
final selectedChainProvider = StateProvider<Chain>((ref) => Chain.ethereum);

final gasStreamProvider = StreamProvider<GasInfo>((ref) {
  final remote = ref.read(gasRemoteDataSourceProvider);
  final chain = ref.watch(selectedChainProvider);

  return Stream.periodic(
    const Duration(seconds: 15),
    (_) => remote.fetchGas(chain),
  ).asyncMap((event) => event);
});
