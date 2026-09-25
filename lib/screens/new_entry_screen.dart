
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/journal_providers.dart';
import '../models/journal_entry.dart';
import '../features/prompts/application/prompt_providers.dart';
import '../features/prompts/data/prompt.dart';
import '../features/prompts/data/prompt_category.dart';
import 'package:satr/core/text_direction.dart';

class NewEntryScreen extends ConsumerStatefulWidget {
  const NewEntryScreen({super.key, this.entry, this.initialPrompt});

  final JournalEntry? entry;

  final Prompt? initialPrompt;

  @override
  ConsumerState<NewEntryScreen> createState() => _NewEntryScreenState();
}


class _NewEntryScreenState extends ConsumerState<NewEntryScreen> {
  TextDirection _direction = TextDirection.ltr;
  late final TextEditingController _controller;
  PromptCategory? _category;
  Prompt? _prompt;
  bool _showCategories = false;

  void _pick(PromptCategory? category) {
    setState(() {
      _category = category;
      _prompt = ref.read(promptRepositoryProvider).randomPrompt(
        category: category,
        exclude: _prompt?.text,
      );
    });
  }
  void _startPrompt() {
      setState(() {
        _showCategories = true;
        _prompt = ref.read(promptRepositoryProvider).randomPrompt();
      });
    }
  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry?.content);
    _prompt = widget.initialPrompt;
    _showCategories = _prompt != null;
    _direction = isRtl(_controller.text) ? TextDirection.rtl : TextDirection.ltr;
    _controller.addListener(() {
      final next = isRtl(_controller.text) ? TextDirection.rtl : TextDirection.ltr;
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
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _saveEntry)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!_isEditing) ...[
              if (!_showCategories)
                GestureDetector(
                  onTap: _startPrompt,
                  child: Text(
                    "I don't know what to write",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else ...[
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    for (final c in PromptCategory.values)
                      GestureDetector(
                        // Tapping the selected word again goes back to "any".
                        onTap: () => _pick(_category == c ? null : c),
                        child: Text(
                          c.label,
                          style: TextStyle(
                            color: _category == c
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight:
                                _category == c ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
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
              ],
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