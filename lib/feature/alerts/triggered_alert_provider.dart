import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'domain/gas_alert.dart';

final triggeredAlertProvider = StateProvider<GasAlert?>((_) => null);
