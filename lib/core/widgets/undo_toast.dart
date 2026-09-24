import 'package:flutter/material.dart';

void showUndoToast(
  OverlayState overlayState, {
  required String message,
  required VoidCallback onUndo,
}) {
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _UndoToast(
      message: message,
      onUndo: () {
        entry.remove();
        onUndo();
      },
      onDismiss: () => entry.remove(),
    ),
  );

  overlayState.insert(entry);
}

class _UndoToast extends StatefulWidget {
  const _UndoToast({
    required this.message,
    required this.onUndo,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onUndo;
  final VoidCallback onDismiss;

  @override
  State<_UndoToast> createState() => _UndoToastState();
}

class _UndoToastState extends State<_UndoToast> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) _dismiss();
    });
  }

  void _dismiss() {
    if (!mounted) return;
    setState(() => _visible = false);
    Future.delayed(const Duration(milliseconds: 200), widget.onDismiss);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.white);

    return Positioned(
      left: 24,
      right: 24,
      bottom: 32,
      child: IgnorePointer(
        ignoring: !_visible,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          offset: _visible ? Offset.zero : const Offset(0, 0.4),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _visible ? 1 : 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.message, style: textStyle),
                      const SizedBox(width: 16),
                       GestureDetector(
                        onTap: widget.onUndo,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'Undo',
                            style: textStyle?.copyWith(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}