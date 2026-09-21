import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nook/features/lock/application/lock_providers.dart';
import 'package:nook/features/lock/data/pin_repository.dart';
import 'models/journal_entry.dart';
import 'package:nook/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter());
  await Hive.openBox<JournalEntry>('journalEntries');

  final hasPin = await PinRepository().hasPin();

  runApp(
    ProviderScope(
      // Gives unlockedProvider its real starting value (see 6.2).
      overrides: [unlockedProvider.overrideWith((ref) => !hasPin)],
      child: const NookApp(),
    ),
  );
}

class NookApp extends StatelessWidget {
  const NookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}