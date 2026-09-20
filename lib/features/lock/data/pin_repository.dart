import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class PinRepository {
  final _storage = const FlutterSecureStorage();
  static const _key = 'nook_pin';

  Future<bool> hasPin() async => await _storage.read(key: _key) != null;

  Future<void> setPin(String pin) => _storage.write(key: _key, value: pin);

  Future<bool> verify(String pin) async => await _storage.read(key: _key) == pin;

  Future<void> clearPin() => _storage.delete(key: _key);
}