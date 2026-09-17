import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/journal_entry.dart';

void main() async {
  // Required when doing async work before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Hive and finds the right storage folder for this platform
  await Hive.initFlutter();

  // Registers our JournalEntry adapter so Hive knows how to save/load it
  Hive.registerAdapter(JournalEntryAdapter());

  // Opens the "box" — think of a box as a table in a traditional database
  await Hive.openBox<JournalEntry>('journalEntries');

  runApp(
    // Wraps the whole app so Riverpod's providers work everywhere
    const ProviderScope(
      child: NookApp(),
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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Text('Hello Nook'),
        ),
      ),
    );
  }
}