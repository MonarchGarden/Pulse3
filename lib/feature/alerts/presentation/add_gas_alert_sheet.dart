import 'package:Pulse3/feature/alerts/alerts_providers.dart';
import 'package:Pulse3/feature/alerts/domain/gas_alert.dart';
import 'package:Pulse3/feature/gas/presentation/gas_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddGasAlertSheet extends ConsumerStatefulWidget {
  const AddGasAlertSheet({super.key});

  @override
  ConsumerState<AddGasAlertSheet> createState() => _AddGasAlertSheetState();
}

class _AddGasAlertSheetState extends ConsumerState<AddGasAlertSheet> {
  AlertCondition _condition = AlertCondition.below;
  double _threshold = 10;

  @override
  Widget build(BuildContext context) {
    final chain = ref.watch(selectedChainProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add Gas Alert',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ToggleButtons(
            isSelected: [
              _condition == AlertCondition.below,
              _condition == AlertCondition.above,
            ],
            onPressed: (index) {
              setState(() {
                _condition =
                    index == 0 ? AlertCondition.below : AlertCondition.above;
              });
            },
            borderRadius: BorderRadius.circular(8),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Below'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Above'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Gas Threshold (GWEI)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null && parsed > 0) {
                _threshold = parsed;
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ref.read(gasAlertsProvider.notifier).add(
                    GasAlert(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      chain: chain,
                      condition: _condition,
                      threshold: _threshold,
                    ),
                  );

              Navigator.pop(context);
            },
            child: const Text('Save Alert'),
          ),
        ],
      ),
    );
  }
}
