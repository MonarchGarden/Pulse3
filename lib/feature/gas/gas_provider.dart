import 'dart:async';
import 'package:Pulse3/feature/gas/data/gas_remote_data_source.dart';
import 'package:Pulse3/feature/gas/domain/gas_info.dart';
import 'package:Pulse3/feature/gas/domain/gas_trend.dart';
import 'package:Pulse3/feature/gas/presentation/gas_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gasRemoteDataSourceProvider = Provider((ref) => GasRemoteDataSource());

final _previousGasProvider = StateProvider<double?>((_) => null);
final lastUpdatedAtProvider = StateProvider<DateTime?>((ref) => null);

final gasStreamProvider = StreamProvider<GasInfo>((ref) {
  final remote = ref.read(gasRemoteDataSourceProvider);
  final chain = ref.watch(selectedChainProvider);

  return Stream.periodic(const Duration(seconds: 15)).asyncMap((_) async {
    final gas = await remote.fetchGas(chain);
    final prev = ref.read(_previousGasProvider);

    GasTrend trend = GasTrend.flat;

    if (prev != null) {
      if (gas.gwei > prev) {
        trend = GasTrend.up;
      } else if (gas.gwei < prev) {
        trend = GasTrend.down;
      }
    }

    ref.read(_previousGasProvider.notifier).state = gas.gwei;
    ref.read(lastUpdatedAtProvider.notifier).state = DateTime.now();

    return GasInfo(
      gwei: gas.gwei,
      level: gas.level,
      trend: trend,
    );
  });
});
