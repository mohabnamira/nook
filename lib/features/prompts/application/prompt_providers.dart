import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prompt_repository.dart';

final promptRepositoryProvider = Provider<PromptRepository>((ref) {
  return PromptRepository();
});