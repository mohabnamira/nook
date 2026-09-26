
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinStorageException implements Exception {
  PinStorageException(this.message);
  final String message;
}

class PinRepository {
  final _storage = const FlutterSecureStorage();
  static const _key = 'nook_pin';

  Future<bool> hasPin() async {
    try {
      return await _storage.read(key: _key) != null;
    } catch (e) {
      debugPrint('PinRepository.hasPin failed: $e');
      return false;
    }
  }

  Future<void> setPin(String pin) async {
    try {
      await _storage.write(key: _key, value: pin);
    } catch (e) {
      debugPrint('PinRepository.setPin failed: $e');
      throw PinStorageException("Couldn't save your PIN. Please try again.");
    }
  }

  Future<bool> verify(String pin) async {
    try {
      return await _storage.read(key: _key) == pin;
    } catch (e) {
      debugPrint('PinRepository.verify failed: $e');
      throw PinStorageException("Couldn't check your PIN. Please try again.");
    }
  }

  Future<void> clearPin() async {
    try {
      await _storage.delete(key: _key);
    } catch (e) {
      debugPrint('PinRepository.clearPin failed: $e');
      throw PinStorageException("Couldn't remove your PIN. Please try again.");
    }
  }
}