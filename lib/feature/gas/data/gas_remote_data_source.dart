import 'package:Pulse3/core/config/rpc_config.dart';
import 'package:Pulse3/core/network/dio_client.dart';
import 'package:Pulse3/feature/gas/domain/chain.dart';
import 'package:Pulse3/feature/gas/domain/gas_info.dart';
import 'package:Pulse3/feature/gas/domain/gas_trend.dart';
import 'package:dio/dio.dart';

class GasRemoteDataSource {
  final Dio _dio = DioClient.create();

  Future<GasInfo> fetchGas(Chain chain) async {
    final rpcUrl = RpcConfig.rpcUrls[chain]!;

    final response = await _dio.post(
      rpcUrl,
      data: {
        'jsonrpc': '2.0',
        'method': 'eth_gasPrice',
        'params': [],
        'id': 1,
      },
    );

    final hexGas = response.data['result'] as String;
    final gasWei = int.parse(hexGas.substring(2), radix: 16);
    final gwei = gasWei / 1e9;

    final level = gwei < 20
        ? GasLevel.cheap
        : gwei < 40
            ? GasLevel.normal
            : GasLevel.expensive;

    return GasInfo(
      gwei: gwei,
      level: level,
      trend: GasTrend.flat,
    );
  }
}
