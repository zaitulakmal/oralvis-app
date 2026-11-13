import 'package:flutter/material.dart';

/// Anything tappable. Shrinks a touch while held, like the prototype's
/// `.is-press` (scale .962), and springs back on release.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.962,
    this.label,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  /// Accessibility label, for targets with no readable text.
  final String? label;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _set(true),
          onTapUp: (_) => _set(false),
          onTapCancel: () => _set(false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _down ? widget.scale : 1,
            duration: Duration(milliseconds: _down ? 70 : 170),
            curve: _down ? Curves.easeOut : const Cubic(.34, 1.4, .64, 1),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
