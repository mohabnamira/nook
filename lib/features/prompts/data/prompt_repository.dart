import 'dart:math';

import 'prompt.dart';
import 'prompt_category.dart';
import 'prompt_data.dart';

class PromptRepository {

  PromptRepository({Random? random}) : _random = random ?? Random();

  final Random _random;

  Prompt randomPrompt({PromptCategory? category, String? exclude}) {

    final pool = category == null
        ? allPrompts
        : allPrompts.where((p) => p.category == category).toList();


    final candidates = pool.where((p) => p.text != exclude).toList();

    final source = candidates.isEmpty ? pool : candidates;

    return source[_random.nextInt(source.length)];
  }
}