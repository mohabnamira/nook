import 'package:flutter/material.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({
    super.key,
    required this.title,
    required this.onPin,
    this.canCancel = false,
  });

  final String title;

  final Future<String?> Function(String pin) onPin;

  final bool canCancel;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  static const _length = 4;
  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '<'], 
  ];

  String _pin = '';
  String? _message;
  int _failures = 0;
  bool _busy = false; 

  Future<void> _tap(String digit) async {
    if (_busy || _pin.length >= _length) return;
    setState(() {
      _pin += digit;
      _message = null;
    });
    if (_pin.length < _length) return;

    _busy = true;
    final error = await widget.onPin(_pin);
  
    if (!mounted) return;

    if (error != null) {
      _failures++;
      var message = error;

      if (_failures % 5 == 0) {
        message = 'Too many attempts. Try again in 30 seconds.';
        setState(() => _message = message);
        await Future.delayed(const Duration(seconds: 30));
        if (!mounted) return;
      }
      setState(() => _message = message);
    }

    setState(() {
      _pin = '';
      _busy = false;
    });
  }

  void _back() {
    if (_busy || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Widget _key(String k) {
    return SizedBox(
      width: 80,
      height: 64,
      child: k.isEmpty
          ? null
          : TextButton(
              onPressed: () => k == '<' ? _back() : _tap(k),
              child: k == '<'
                  ? const Icon(Icons.backspace_outlined)
                  : Text(k, style: Theme.of(context).textTheme.headlineMedium),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.canCancel ? AppBar() : null,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < _length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        i < _pin.length ? Icons.circle : Icons.circle_outlined,
                        size: 16,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _message ?? ' ',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              for (final row in _rows)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [for (final k in row) _key(k)],
                ),
            ],
          ),
        ),
      ),
    );
  }
}