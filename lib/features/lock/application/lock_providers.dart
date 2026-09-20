import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/pin_repository.dart';

final pinRepositoryProvider = Provider<PinRepository>((ref) {
  return PinRepository();
});
final unlockedProvider = StateProvider<bool>((ref) {
  throw UnimplementedError('Override unlockedProvider in main.dart');
});