import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Pulse3/features/gas/data/gas_remote_data_source.dart';
import 'package:Pulse3/features/gas/domain/chain.dart';
import 'package:Pulse3/features/gas/domain/gas_info.dart';
import 'package:Pulse3/features/gas/domain/gas_trend.dart';

final gasRemoteDataSourceProvider = Provider((ref) => GasRemoteDataSource());

final previousGasByChainProvider =
    StateProvider.family<double?, Chain>((ref, chain) => null);

final lastUpdatedAtByChainProvider =
    StateProvider.family<DateTime?, Chain>((ref, chain) => null);

final gasStreamProvider = StreamProvider.family<GasInfo, Chain>((ref, chain) {
  final remote = ref.read(gasRemoteDataSourceProvider);

  return Stream.periodic(const Duration(seconds: 15)).asyncMap((_) async {
    final gas = await remote.fetchGas(chain);

    final prev = ref.read(previousGasByChainProvider(chain));

    GasTrend trend = GasTrend.flat;
    if (prev != null) {
      if (gas.gwei > prev) {
        trend = GasTrend.up;
      } else if (gas.gwei < prev) {
        trend = GasTrend.down;
      }
    }

    ref.read(previousGasByChainProvider(chain).notifier).state = gas.gwei;
    ref.read(lastUpdatedAtByChainProvider(chain).notifier).state =
        DateTime.now();

    return GasInfo(
      gwei: gas.gwei,
      level: gas.level,
      trend: trend,
    );
  });
});
