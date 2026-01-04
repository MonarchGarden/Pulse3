import 'package:Pulse3/core/constant/enum/alert_condition.dart';
import 'package:Pulse3/core/constant/enum/chain.dart';
import 'package:Pulse3/feature/alerts/alerts_engine.dart';
import 'package:Pulse3/feature/alerts/domain/gas_alert.dart';
import 'package:Pulse3/feature/alerts/triggered_alert_provider.dart';
import 'package:Pulse3/feature/gas/domain/chain.dart';
import 'package:Pulse3/feature/gas/gas_provider.dart';
import 'package:Pulse3/feature/gas/presentation/gas_card.dart';
import 'package:Pulse3/feature/gas/presentation/gas_skeleton.dart';
import 'package:Pulse3/feature/gas/presentation/providers/chain_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GasScreen extends ConsumerStatefulWidget {
  const GasScreen({super.key});

  @override
  ConsumerState<GasScreen> createState() => _GasScreenState();
}

class _GasScreenState extends ConsumerState<GasScreen> {
  late final ProviderSubscription<GasAlert?> _alertSub;
  late final PageController _pageController;

  int _indexOf(Chain chain) => Chain.values.indexOf(chain);

  @override
  void initState() {
    super.initState();

    final initialChain = ref.read(activeChainProvider);
    _pageController = PageController(initialPage: _indexOf(initialChain));

    _alertSub = ref.listenManual<GasAlert?>(
      triggeredAlertProvider,
      (prev, next) {
        if (next == null) return;
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Gas Alert Triggered'),
            content: Text(
              'Gas is now ${next.condition == AlertCondition.below ? 'below' : 'above'} '
              '${next.threshold} GWEI on ${next.chain.label}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(triggeredAlertProvider.notifier).state = null;
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _alertSub.close();
    _pageController.dispose();
    super.dispose();
  }

  void _selectChain(Chain chain) {
    ref.read(activeChainProvider.notifier).state = chain;
    _pageController.animateToPage(
      _indexOf(chain),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeChain = ref.watch(activeChainProvider);

    ref.watch(gasAlertEngineProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: Chain.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final chain = Chain.values[i];
                  final selected = chain == activeChain;

                  return ChoiceChip(
                    showCheckmark: false,
                    label: Text(chain.label),
                    selected: selected,
                    onSelected: (_) => _selectChain(chain),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: Chain.values.length,
                onPageChanged: (index) {
                  ref.read(activeChainProvider.notifier).state =
                      Chain.values[index];
                },
                itemBuilder: (context, index) {
                  final chain = Chain.values[index];
                  final gasAsync = ref.watch(gasStreamProvider(chain));

                  return gasAsync.when(
                    loading: () => const GasSkeleton(),
                    error: (e, _) => Center(child: Text(e.toString())),
                    data: (gas) =>
                        Center(child: GasCard(gas: gas, chain: chain)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
