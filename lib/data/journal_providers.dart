import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry.dart';
import 'journal_repository.dart';

final journalBoxProvider = Provider<Box<JournalEntry>>((ref) {
  return Hive.box<JournalEntry>('journalEntries');
});


final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final box = ref.watch(journalBoxProvider);
  return JournalRepository(box);
});