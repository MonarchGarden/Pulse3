import 'package:Pulse3/core/config/rpc_config.dart';
import 'package:Pulse3/core/constant/enum/chain.dart';
import 'package:Pulse3/core/constant/enum/gas_level.dart';
import 'package:Pulse3/core/network/dio_client.dart';
import 'package:Pulse3/feature/gas/domain/gas_info.dart';
import 'package:Pulse3/feature/gas/domain/gas_trend.dart';
import 'package:dio/dio.dart';

class GasRemoteDataSource {
  final Dio _dio = DioClient.create();

  BigInt _hexToBigInt(String hex) {
    final cleaned = hex.startsWith('0x') ? hex.substring(2) : hex;
    return BigInt.parse(cleaned, radix: 16);
  }

  double _weiToGwei(BigInt wei) => wei.toDouble() / 1e9;

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

    final wei = _hexToBigInt(hexGas);
    final gwei = _weiToGwei(wei);

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
