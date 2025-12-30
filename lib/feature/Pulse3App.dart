import 'package:Pulse3/feature/gas/presentation/gas_screen.dart';
import 'package:flutter/material.dart';

class Pulse3App extends StatelessWidget {
  const Pulse3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pulse3',
      theme: ThemeData.dark(),
      home: const GasScreen(),
    );
  }
}
