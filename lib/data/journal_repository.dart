// lib/data/journal_repository.dart
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  static const String _boxName = 'journal_entries';
  late Box<JournalEntry> _box;
  final _uuid = const Uuid();

  Future<void> init() async {
    Hive.registerAdapter(JournalEntryAdapter());
    _box = await Hive.openBox<JournalEntry>(_boxName);
  }

  List<JournalEntry> getAllEntries() {
    final entries = _box.values.toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<JournalEntry> addEntry({
    required String content,
    String? promptUsed,
    String? promptCategory,
  }) async {
    final entry = JournalEntry(
      id: _uuid.v4(),
      content: content,
      createdAt: DateTime.now(),
      promptUsed: promptUsed,
      promptCategory: promptCategory,
    );
    await _box.put(entry.id, entry);
    return entry;
  }

  Future<void> updateEntry(String id, String newContent) async {
    final entry = _box.get(id);
    if (entry == null) return;
    entry.content = newContent;
    entry.updatedAt = DateTime.now();
    await entry.save();
  }

  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }

  ValueListenable<Box<JournalEntry>> listenable() => _box.listenable();
}