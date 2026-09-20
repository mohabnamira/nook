// lib/screens/new_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/journal_providers.dart';
import '../models/journal_entry.dart';

class NewEntryScreen extends ConsumerStatefulWidget {
  const NewEntryScreen({super.key, this.entry});

  final JournalEntry? entry;

  @override
  ConsumerState<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends ConsumerState<NewEntryScreen> {
  late final TextEditingController _controller;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry?.content);
  }

  Future<void> _saveEntry() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final repository = ref.read(journalRepositoryProvider);
    if (_isEditing) {
      await repository.updateEntry(widget.entry!.id, text);
    } else {
      await repository.addEntry(content: text);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Entry' : 'New Entry'),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _saveEntry)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          autofocus: true,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(hintText: "What's on your mind?", border: InputBorder.none),
        ),
      ),
    );
  }
}