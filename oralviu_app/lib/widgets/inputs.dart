import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/type.dart';
import 'pressable.dart';
import 'ui.dart';

const _fieldText = TextStyle(
  fontFamily: kFont,
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: C.ink,
);
const _hintText = TextStyle(
  fontFamily: kFont,
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: C.ink3,
);

/// `.if` — filled field with an icon on the left. The border turns ink while
/// the field has focus (the prototype's `.if.on`).
class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    this.icon,
    required this.hint,
    this.height = 54,
    this.initial,
    this.password = false,
    this.keyboard,
    this.multiline = false,
    this.plain = false,
    this.showToggle = true,
  });
  final IconData? icon;
  final String hint;
  final double height;
  final String? initial;
  final bool password;
  final TextInputType? keyboard;

  /// Text area (notes); the icon sits at the top.
  final bool multiline;

  /// The bordered text area used on the medical history screens.
  final bool plain;

  /// Show the eye button on a password field.
  final bool showToggle;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  final _focus = FocusNode();
  late final _ctl = TextEditingController(text: widget.initial);
  late bool _hidden = widget.password;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.plain
        ? Border.all(color: _focus.hasFocus ? C.ink : C.brd2, width: 1)
        : Border.all(
            color: _focus.hasFocus ? C.ink : Colors.transparent,
            width: 1.5,
          );
    final field = TextField(
      controller: _ctl,
      focusNode: _focus,
      obscureText: _hidden,
      keyboardType: widget.multiline
          ? TextInputType.multiline
          : widget.keyboard,
      maxLines: widget.multiline ? null : 1,
      style: _fieldText,
      cursorColor: C.blue,
      decoration: InputDecoration.collapsed(
        hintText: widget.hint,
        hintStyle: _hintText,
      ),
    );
    return GestureDetector(
      onTap: _focus.requestFocus,
      child: Container(
        constraints: BoxConstraints(minHeight: widget.height),
        padding: EdgeInsets.only(
          left: widget.plain ? 12 : (widget.icon == null ? 16 : 0),
          right: 14,
          top: widget.multiline ? 15 : 0,
          bottom: widget.multiline ? 10 : 0,
        ),
        decoration: BoxDecoration(
          color: C.neutral,
          borderRadius: BorderRadius.circular(widget.plain ? 14 : 15),
          border: border,
        ),
        child: Row(
          crossAxisAlignment: widget.multiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (widget.icon != null)
              SizedBox(
                width: 46,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(widget.icon, size: 20, color: C.ink3),
                  ),
                ),
              ),
            Expanded(child: field),
            if (widget.password && widget.showToggle)
              Pressable(
                onTap: () => setState(() => _hidden = !_hidden),
                label: _hidden ? 'Show password' : 'Hide password',
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    _hidden
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    size: 19,
                    color: C.ink3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A field that opens a bottom-sheet list (prototype `data-dd`).
/// [options] null means it is locked (City before a State is picked).
class DropField extends StatelessWidget {
  const DropField({
    super.key,
    required this.icon,
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.height = 48,
  });
  final IconData icon;
  final String title;
  final List<String>? options;
  final String? value;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final double height;

  @override
  Widget build(BuildContext context) {
    final locked = options == null;
    return Pressable(
      onTap: locked
          ? null
          : () async {
              final v = await showOptionSheet(
                context,
                title: title,
                options: options!,
                value: value,
              );
              if (v != null) onChanged(v);
            },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: C.neutral,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(icon, size: 20, color: C.ink3),
                ),
              ),
            ),
            Expanded(
              child: Text(
                value ?? placeholder ?? title,
                overflow: TextOverflow.ellipsis,
                style: value == null ? _hintText : _fieldText,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 8),
              child: Opacity(
                opacity: locked ? .4 : 1,
                child: const Icon(
                  Icons.expand_more_rounded,
                  size: 19,
                  color: C.ink3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The option list sheet: grab handle, "Select …" title, scrolling list with
/// a tick on the current value.
Future<String?> showOptionSheet(
  BuildContext context, {
  required String title,
  required List<String> options,
  String? value,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: C.card,
    barrierColor: const Color(0x61132B44),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * .78,
    ),
    builder: (ctx) {
      final selected = options.indexOf(value ?? '');
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          22 + MediaQuery.viewPaddingOf(ctx).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: C.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Select ${title.toLowerCase()}', style: T.h3),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                controller: ScrollController(
                  initialScrollOffset: selected > 4 ? (selected - 3) * 50.0 : 0,
                ),
                itemBuilder: (_, i) {
                  final on = i == selected;
                  return Pressable(
                    scale: .985,
                    onTap: () => Navigator.of(ctx).pop(options[i]),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 50),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: C.line)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              options[i],
                              style: TextStyle(
                                fontFamily: kFont,
                                fontSize: 15,
                                color: on ? C.blueD : C.ink,
                                fontWeight: on
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (on)
                            const Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: C.blueD,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// "Profile picture" row with the dashed camera disc.
class PhotoRow extends StatelessWidget {
  const PhotoRow({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Pressable(
    onTap: onTap,
    scale: .985,
    child: Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 4),
      child: Row(
        spacing: 12,
        children: [
          DashedRing(
            color: C.blueD,
            child: Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: C.blueT,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_rounded,
                size: 25,
                color: C.blueD,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile picture', style: T.h4),
                Text('Take a photo or upload one', style: T.cap),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 19, color: C.ink3),
        ],
      ),
    ),
  );
}

/// A tick-box row card (medical history).
class CheckRow extends StatelessWidget {
  const CheckRow({
    super.key,
    required this.label,
    required this.on,
    required this.onTap,
  });
  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Pressable(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: C.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: Shadows.sh,
      ),
      child: Row(
        spacing: 12,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: on ? C.blue : null,
              borderRadius: BorderRadius.circular(6),
              border: on ? null : Border.all(color: C.brd2, width: 1.5),
            ),
            child: on
                ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                : null,
          ),
          Expanded(child: Text(label, style: T.h4)),
        ],
      ),
    ),
  );
}
