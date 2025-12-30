import 'package:flutter_riverpod/flutter_riverpod.dart';

final lastUpdatedTickerProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (i) => i);
});
