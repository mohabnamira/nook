
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/journal_providers.dart';
import '../models/journal_entry.dart';
import '../features/prompts/application/prompt_providers.dart';
import '../features/prompts/data/prompt.dart';
import '../features/prompts/data/prompt_category.dart';
import 'package:characters/characters.dart';

class NewEntryScreen extends ConsumerStatefulWidget {
  const NewEntryScreen({super.key, this.entry, this.initialPrompt});

  final JournalEntry? entry;

  final Prompt? initialPrompt;

  @override
  ConsumerState<NewEntryScreen> createState() => _NewEntryScreenState();
}

bool _isRtl(String text) {
  final rtl = RegExp(
      r'[\u0591-\u07FF\u200F\u202B\u202E\uFB1D-\uFDFD\uFE70-\uFEFC]');
  for (final char in text.characters) {
    if (rtl.hasMatch(char)) return true;
    if (RegExp(r'[A-Za-z]').hasMatch(char)) return false;
  }
  return false; 
}

class _NewEntryScreenState extends ConsumerState<NewEntryScreen> {
  TextDirection _direction = TextDirection.ltr;
  late final TextEditingController _controller;
  PromptCategory? _category;
  Prompt? _prompt;

  void _pick(PromptCategory? category) {
    setState(() {
      _category = category;
      _prompt = ref.read(promptRepositoryProvider).randomPrompt(
        category: category,
        exclude: _prompt?.text,
      );
    });
  }

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry?.content);
    _prompt = widget.initialPrompt;
    _direction = _isRtl(_controller.text) ? TextDirection.rtl : TextDirection.ltr;
    _controller.addListener(() {
      final next = _isRtl(_controller.text) ? TextDirection.rtl : TextDirection.ltr;
      if (next != _direction) setState(() => _direction = next);
    });
  }

  Future<void> _saveEntry() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final repository = ref.read(journalRepositoryProvider);
    if (_isEditing) {
      await repository.updateEntry(widget.entry!.id, text);
    } else {
      await repository.addEntry(
        content: text,
        promptUsed: _prompt?.text,
        promptCategory: _prompt?.category.name,
      );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Prompts only when creating; showing a saved prompt in edit mode is 5.4.
            if (!_isEditing) ...[
              Wrap(
                spacing: 8,
                children: [
                  for (final c in PromptCategory.values)
                    ChoiceChip(
                      label: Text(c.label),
                      selected: _category == c,
                      // Tapping the selected chip again goes back to "any".
                      onSelected: (selected) => _pick(selected ? c : null),
                    ),
                ],
              ),
              if (_prompt != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _prompt!.text,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.shuffle),
                      onPressed: () => _pick(_category),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
            ],
            if (_isEditing && widget.entry!.promptUsed != null) ...[
              Text(
                widget.entry!.promptUsed!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
            ],
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLines: null,
                expands: true,
                textDirection: _direction,
                textAlign: _direction == TextDirection.rtl
                    ? TextAlign.right
                    : TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}