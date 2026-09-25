import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satr/screens/home_screen.dart';
import '../application/lock_providers.dart';
import 'lock_screen.dart';
class LockGate extends ConsumerWidget {
  const LockGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(unlockedProvider);
    if (unlocked) return const HomeScreen();

    return LockScreen(
      title: 'Enter PIN',
      onPin: (pin) async {
        final ok = await ref.read(pinRepositoryProvider).verify(pin);
        if (!ok) return 'Wrong PIN';
        ref.read(unlockedProvider.notifier).state = true;
        return null;
      },
    );
  }
}