import 'package:Pulse3/features/alerts/domain/gas_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final triggeredAlertProvider = StateProvider<GasAlert?>((_) => null);
