import 'package:Pulse3/features/gas/domain/gas_info.dart';
import 'package:Pulse3/features/gas/presentation/gas_trend_indicator.dart';
import 'package:flutter/material.dart';

class GasAnimatedValue extends StatelessWidget {
  final GasInfo gas;

  const GasAnimatedValue({super.key, required this.gas});

  @override
  Widget build(BuildContext context) {
    final wei = BigInt.from((gas.gwei * 1e9).round());
    final displayText = _formatGasLikeTrackers(wei);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Row(
        key: ValueKey(displayText),
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                displayText,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GasTrendIndicator(trend: gas.trend),
        ],
      ),
    );
  }

  static const _units = <_EthUnit>[
    _EthUnit('WEI', 0),
    _EthUnit('KWEI', 3),
    _EthUnit('MWEI', 6),
    _EthUnit('GWEI', 9),
    _EthUnit('TWEI', 12),
    _EthUnit('PWEI', 15),
    _EthUnit('ETH', 18),
  ];

  String _formatGasLikeTrackers(BigInt wei) {
    final gwei = wei.toDouble() / 1e9;

    if (gwei >= 1000) {
      return '${_formatDecimalFromWei(wei, 12, maxFractionDigits: 3)} TWEI';
    }

    if (gwei < 0.001) {
      return '${_formatDecimalFromWei(wei, 6, maxFractionDigits: 3)} MWEI';
    }

    return '${_formatDecimalFromWei(wei, 9, maxFractionDigits: 3)} GWEI';
  }

  String _formatBestUnitFromWei(BigInt wei) {
    if (wei == BigInt.zero) return '0 WEI';

    _EthUnit chosen = _units.first;
    for (final u in _units) {
      final oneUnitWei = BigInt.from(10).pow(u.exp);
      if (wei >= oneUnitWei) chosen = u;
    }

    final value = _formatDecimalFromWei(wei, chosen.exp, maxFractionDigits: 3);

    return '$value ${chosen.symbol}';
  }

  String _formatDecimalFromWei(
    BigInt wei,
    int decimals, {
    int maxFractionDigits = 3,
  }) {
    final s = wei.toString();
    final isNeg = s.startsWith('-');
    final digits = isNeg ? s.substring(1) : s;

    if (decimals == 0) {
      return (isNeg ? '-' : '') + _withCommas(digits);
    }

    final padded = digits.padLeft(decimals + 1, '0');
    final whole = padded.substring(0, padded.length - decimals);
    var frac = padded.substring(padded.length - decimals);

    if (frac.length > maxFractionDigits) {
      frac = frac.substring(0, maxFractionDigits);
    }

    frac = frac.replaceFirst(RegExp(r'0+$'), '');
    final wholeWithCommas = _withCommas(whole);

    if (frac.isEmpty) return '${isNeg ? '-' : ''}$wholeWithCommas';
    return '${isNeg ? '-' : ''}$wholeWithCommas.$frac';
  }

  String _withCommas(String digits) {
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buf.write(digits[i]);
      final left = digits.length - i - 1;
      if (left > 0 && left % 3 == 0) buf.write(',');
    }
    return buf.toString();
  }
}

class _EthUnit {
  final String symbol;
  final int exp;

  const _EthUnit(this.symbol, this.exp);
}
