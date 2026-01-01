import 'package:Pulse3/core/firebase/firebase_auth_provider.dart';
import 'package:Pulse3/feature/Pulse3App.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (_, next) {
      next.whenData((user) {
        if (user == null) {
          FirebaseAuth.instance.signInAnonymously();
        }
      });
    });

    return const Pulse3App();
  }
}
