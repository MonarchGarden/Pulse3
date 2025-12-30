import 'dart:async';
import 'package:Pulse3/feature/gas/domain/chain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/gas_remote_data_source.dart';
import '../domain/gas_info.dart';

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
