import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/colors.dart';
import '../theme/type.dart';
import 'grade_face.dart';
import 'pressable.dart';

/// Back, or the dashboard when there is nothing to go back to
/// (same fallback as the prototype's back button).
void goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/dashboard');
  }
}

// ─────────────────────────────────────────────────────────── screen shell ──

/// A full screen: background running under the status bar, content kept
/// clear of it. [bottom] sits at the foot and is padded clear of the home
/// indicator; [nav] is the tab bar.
class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.children,
    this.background = C.bg,
    this.lightStatusIcons = false,
    this.bottom,
    this.bottomPadding = const EdgeInsets.fromLTRB(20, 0, 20, 16),
    this.bottomColor,
    this.nav,
    this.topColor,
  });

  /// Colour behind the status bar when the first band differs from
  /// [background] (a blue header on a light screen).
  final Color? topColor;

  final List<Widget> children;
  final Color background;
  final bool lightStatusIcons;
  final Widget? bottom;
  final EdgeInsets bottomPadding;
  final Color? bottomColor;
  final Widget? nav;

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.viewPaddingOf(context).bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          (lightStatusIcons
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: background,
        bottomNavigationBar: nav,
        body: Container(
          color: topColor,
          child: SafeArea(
            bottom: false,
            child: ColoredBox(
              color: topColor == null ? Colors.transparent : background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...children,
                  if (bottom != null)
                    Container(
                      color: bottomColor,
                      padding: bottomPadding.copyWith(
                        bottom:
                            bottomPadding.bottom + (nav == null ? inset : 0),
                      ),
                      child: bottom,
                    ),
                  if (bottom == null && nav == null) SizedBox(height: inset),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.pad` — the header band: 6 / 18 / 12.
class Pad extends StatelessWidget {
  const Pad({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 6, 18, 12),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Padding(padding: padding, child: child);
}

/// `.body` — the scrolling middle of a screen.
class ScrollBody extends StatelessWidget {
  const ScrollBody({
    super.key,
    required this.children,
    this.gap = 0,
    this.padding = const EdgeInsets.fromLTRB(18, 0, 18, 12),
  });
  final List<Widget> children;
  final double gap;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: gap,
          children: children,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────── buttons ──

/// `.cbtn` — round icon button.
class CBtn extends StatelessWidget {
  const CBtn({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 42,
    this.iconSize = 19,
    this.background = C.neutral,
    this.iconColor = C.ink,
    this.shadow = true,
    this.label,
  });
  final IconData icon;
  final VoidCallback? onTap;
  final double size, iconSize;
  final Color background, iconColor;
  final bool shadow;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        boxShadow: shadow ? Shadows.sh : null,
      ),
      child: Icon(icon, size: iconSize, color: iconColor),
    );
    return onTap == null
        ? circle
        : Pressable(onTap: onTap, label: label, child: circle);
  }
}

/// `.back` — round arrow plus an optional title; goes back on tap.
class BackRow extends StatelessWidget {
  const BackRow({super.key, this.label, this.onTap, this.dark = false});
  final String? label;
  final VoidCallback? onTap;

  /// Translucent white circle for dark screens.
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final btn = CBtn(
      icon: Icons.arrow_back_rounded,
      iconSize: dark ? 19 : 17,
      background: dark ? Colors.white.withValues(alpha: .12) : C.neutral,
      iconColor: dark ? Colors.white : C.ink,
      shadow: !dark,
    );
    return Pressable(
      onTap: onTap ?? () => goBack(context),
      label: 'Back',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            btn,
            if (label != null)
              Text(
                label!,
                style: T.h3.copyWith(fontSize: 17, letterSpacing: -.3),
              ),
          ],
        ),
      ),
    );
  }
}

enum BtnStyle { primary, white, outline }

/// `.btn` — 56px pill.
class Btn extends StatelessWidget {
  const Btn(
    this.label, {
    super.key,
    this.onTap,
    this.style = BtnStyle.primary,
    this.icon,
    this.trailingIcon,
    this.height = 56,
  });
  final String label;
  final VoidCallback? onTap;
  final BtnStyle style;
  final IconData? icon, trailingIcon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, shadow, border) = switch (style) {
      BtnStyle.primary => (C.grad, Colors.white, Shadows.shb, null),
      BtnStyle.white => (Colors.white, C.blue, Shadows.sh, null),
      BtnStyle.outline => (
        Colors.transparent,
        C.blueD,
        Shadows.sh,
        Border.all(color: C.blue, width: 1.8),
      ),
    };
    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: shadow,
          border: border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            if (icon != null) Icon(icon, size: 19, color: fg),
            Text(
              label,
              style: TextStyle(
                fontFamily: kFont,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -.2,
                color: fg,
              ),
            ),
            if (trailingIcon != null) Icon(trailingIcon, size: 19, color: fg),
          ],
        ),
      ),
    );
  }
}

/// `.btn-gh` — quiet text button under a primary one.
class BtnGhost extends StatelessWidget {
  const BtnGhost(
    this.label, {
    super.key,
    this.icon,
    this.onTap,
    this.color = C.ink2,
  });
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            if (icon != null) Icon(icon, size: 17, color: color),
            Text(
              label,
              style: TextStyle(
                fontFamily: kFont,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `.btn-sm` — small pill button.
class BtnSm extends StatelessWidget {
  const BtnSm(
    this.label, {
    super.key,
    required this.background,
    required this.foreground,
    this.onTap,
    this.shadow = true,
  });
  final String label;
  final Color background, foreground;
  final VoidCallback? onTap;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(100),
          boxShadow: shadow ? Shadows.sh : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: kFont,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────── chips & pills ──

enum Tone { b, g, o, w, r }

(Color, Color) toneColors(Tone t) => switch (t) {
  Tone.b => (C.blueT, C.blueD),
  Tone.g => (C.goldT, C.goldD),
  Tone.o => (C.okT, C.okD),
  Tone.w => (C.warnT, C.warnD),
  Tone.r => (C.badT, C.badD),
};

/// `.chip` — small square-ish tag. Verdict words (Healthy, Mild, Attention,
/// Serious) get their grade face in front, as in the prototype.
class AppChip extends StatelessWidget {
  const AppChip(
    this.label, {
    super.key,
    this.tone,
    this.background,
    this.foreground,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
    this.fontSize = 11,
    this.onTap,
  });
  final String label;
  final Tone? tone;
  final Color? background, foreground;
  final Widget? leading;
  final EdgeInsets padding;
  final double fontSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (tb, tf) = tone != null
        ? toneColors(tone!)
        : (Colors.transparent, C.ink);
    final bg = background ?? tb, fg = foreground ?? tf;
    final verdict = verdictGrade[label];
    final chip = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          if (verdict != null)
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Transform.translate(
                offset: const Offset(1, 0),
                child: GradeFace(
                  verdict,
                  size: fontSize * 1.2,
                  color: fg,
                  label: label,
                ),
              ),
            ),
          ?leading,
          Text(
            label,
            style: TextStyle(
              fontFamily: kFont,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
    return onTap == null ? chip : Pressable(onTap: onTap, child: chip);
  }
}

/// `.sel` — selectable pill (filters, symptoms, relationship…).
class Sel extends StatelessWidget {
  const Sel(
    this.label, {
    super.key,
    required this.on,
    this.onTap,
    this.center = false,
  });
  final String label;
  final bool on;
  final VoidCallback? onTap;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        alignment: center ? Alignment.center : null,
        decoration: BoxDecoration(
          color: on ? C.grad : C.neutral,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: on ? C.grad : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: on ? Shadows.sh : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: kFont,
            fontSize: 13,
            fontWeight: on ? FontWeight.w600 : FontWeight.w500,
            color: on ? Colors.white : C.ink2,
          ),
        ),
      ),
    );
  }
}

/// `.rtag` — relationship tag next to a dependent's name.
class RTag extends StatelessWidget {
  const RTag(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: C.blueT,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontFamily: kFont,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: C.blueD,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────── containers ──

/// `.card` — white, 20px corners, hard 3px shadow.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
    this.color = C.card,
    this.gradient,
    this.shadow = Shadows.sh,
    this.border,
    this.radius,
    this.onTap,
    this.clip = false,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Gradient? gradient;
  final List<BoxShadow>? shadow;
  final BoxBorder? border;
  final BorderRadius? radius;
  final VoidCallback? onTap;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? BorderRadius.circular(20);
    Widget box = Container(
      padding: padding,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: r,
        boxShadow: shadow,
        border: border,
      ),
      child: child,
    );
    return onTap == null ? box : Pressable(onTap: onTap, child: box);
  }
}

/// `.sq` — rounded icon tile.
class Sq extends StatelessWidget {
  const Sq({
    super.key,
    required this.size,
    this.radius = 13,
    this.color,
    this.gradient,
    this.border,
    this.shadow,
    this.circle = false,
    this.child,
  });

  /// `.sq-34`, `.sq-40`, `.sq-46`, `.sq-54` with their own corner radius.
  const Sq.s34({
    super.key,
    this.color,
    this.gradient,
    this.border,
    this.shadow,
    this.child,
  }) : size = 34,
       radius = 9,
       circle = false;
  const Sq.s40({
    super.key,
    this.color,
    this.gradient,
    this.border,
    this.shadow,
    this.child,
  }) : size = 40,
       radius = 13,
       circle = false;
  const Sq.s46({
    super.key,
    this.color,
    this.gradient,
    this.border,
    this.shadow,
    this.child,
  }) : size = 46,
       radius = 12,
       circle = false;
  const Sq.s54({
    super.key,
    this.color,
    this.gradient,
    this.border,
    this.shadow,
    this.child,
  }) : size = 54,
       radius = 14,
       circle = false;

  final double size, radius;
  final Color? color;
  final Gradient? gradient;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
  final bool circle;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      gradient: gradient,
      border: border,
      boxShadow: shadow,
      shape: circle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: circle ? null : BorderRadius.circular(radius),
    ),
    child: child,
  );
}

/// A tinted icon tile, the most common `.sq` use.
Widget tile(
  IconData icon,
  Tone tone, {
  double size = 34,
  double iconSize = 17,
}) {
  final (bg, fg) = toneColors(tone);
  final i = Icon(icon, size: iconSize, color: fg);
  return switch (size) {
    34 => Sq.s34(color: bg, child: i),
    40 => Sq.s40(color: bg, child: i),
    46 => Sq.s46(color: bg, child: i),
    _ => Sq.s54(color: bg, child: i),
  };
}

/// `.dv` — 1px rule.
class Dv extends StatelessWidget {
  const Dv({super.key, this.indent = 15});
  final double indent;
  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    margin: EdgeInsets.symmetric(horizontal: indent),
    color: C.line,
  );
}

/// `.dot`
class Dot extends StatelessWidget {
  const Dot({super.key, required this.color, this.size = 8});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

/// A tinted note card: icon on the left, text beside it.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.icon,
    required this.text,
    this.tone = Tone.b,
    this.shadow = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
    this.iconSize = 17,
    this.bold = false,
    this.background,
  });
  final IconData icon;

  /// A plain string or rich spans.
  final Object text;
  final Tone tone;
  final bool shadow;
  final EdgeInsets padding;
  final double iconSize;
  final bool bold;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = toneColors(tone);
    final style = T.pxs.copyWith(
      color: fg,
      fontWeight: bold ? FontWeight.w600 : null,
    );
    return AppCard(
      color: background ?? bg,
      shadow: shadow ? Shadows.sh : null,
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Icon(icon, size: iconSize, color: fg),
          Expanded(
            child: text is String
                ? Text(text as String, style: style)
                : Text.rich(
                    TextSpan(children: text as List<InlineSpan>),
                    style: style,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────── figures ──

final _gradeRe = RegExp(r'^[A-F][+-]?$');

/// `.num` — a figure. Grade letters become their drawn face, 1em square,
/// exactly as the prototype swaps them.
class Num extends StatelessWidget {
  const Num(
    this.text, {
    super.key,
    required this.size,
    required this.color,
    this.weight,
  });
  final String text;
  final double size;
  final Color color;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    if (_gradeRe.hasMatch(text)) {
      return GradeFace(text, size: size, color: color);
    }
    return Text(
      text,
      style: T.num.copyWith(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: 1.2,
      ),
    );
  }
}

/// A numbered step: blue tile with the number, title and description.
class StepItem extends StatelessWidget {
  const StepItem({
    super.key,
    required this.n,
    required this.title,
    required this.body,
  });
  final int n;

  /// A string or rich spans.
  final Object title;
  final Object body;

  @override
  Widget build(BuildContext context) {
    Widget rich(Object o, TextStyle s) => o is String
        ? Text(o, style: s)
        : Text.rich(TextSpan(children: o as List<InlineSpan>), style: s);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        Sq.s40(
          color: C.blueT,
          child: Num('$n', size: 15, color: C.blueD),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rich(title, T.h3),
              const SizedBox(height: 3),
              rich(body, T.pxs),
            ],
          ),
        ),
      ],
    );
  }
}

/// A scan history row: status tile, name and date, grade face.
class ScanRow extends StatelessWidget {
  const ScanRow({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    required this.date,
    required this.grade,
    required this.gradeColor,
    this.onTap,
  });
  final IconData icon;
  final Tone tone;
  final String title, date, grade;
  final Color gradeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => AppCard(
    onTap: onTap,
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
    child: Row(
      spacing: 10,
      children: [
        tile(icon, tone),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: T.h4),
              Text(date, style: T.cap.copyWith(fontSize: 9.5)),
            ],
          ),
        ),
        Num(grade, size: 18, color: gradeColor),
      ],
    ),
  );
}

/// A label-over-value row inside a list card (profile details).
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.tone = Tone.b,
  });
  final IconData icon;
  final String label, value;
  final Tone tone;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
    child: Row(
      spacing: 12,
      children: [
        tile(icon, tone),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: T.cap.copyWith(fontSize: 9.5)),
              Text(value, style: T.h4),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A tappable link row inside a list card.
class LinkRow extends StatelessWidget {
  const LinkRow({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Row(
        spacing: 12,
        children: [
          tile(icon, Tone.b),
          Expanded(child: Text(label, style: T.h4)),
          trailing ??
              const Icon(Icons.chevron_right_rounded, size: 17, color: C.ink3),
        ],
      ),
    );
    return onTap == null
        ? row
        : Pressable(onTap: onTap, scale: .985, child: row);
  }
}

/// White list card with rules between its rows.
class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.rows, this.indent = 15});
  final List<Widget> rows;
  final double indent;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: EdgeInsets.zero,
    clip: true,
    child: Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) Dv(indent: indent),
          rows[i],
        ],
      ],
    ),
  );
}

/// Section label `.lab` (upper case, tracked).
class Lab extends StatelessWidget {
  const Lab(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: T.lab);
}

/// Section label `.eyebrow`.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: T.eyebrow);
}

/// `.card.dash` — dashed outline, no fill.
class DashedCard extends StatelessWidget {
  const DashedCard({
    super.key,
    required this.child,
    this.onTap,
    this.color = C.blueD,
  });
  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final box = CustomPaint(
      foregroundPainter: _DashPainter(color),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
    return onTap == null ? box : Pressable(onTap: onTap, child: box);
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final rr = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(.75),
      const Radius.circular(20),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color;
    for (final m in (Path()..addRRect(rr)).computeMetrics()) {
      for (double d = 0; d < m.length; d += 7) {
        canvas.drawPath(m.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color;
}

/// A dashed ring drawn over a circle (`border:1.5px dashed`).
class DashedRing extends StatelessWidget {
  const DashedRing({
    super.key,
    required this.color,
    required this.child,
    this.width = 1.5,
  });
  final Color color;
  final double width;
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(foregroundPainter: _RingDash(color, width), child: child);
}

class _RingDash extends CustomPainter {
  const _RingDash(this.color, this.width);
  final Color color;
  final double width;
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2 - width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = color;
    final dash = width * 3, gap = width * 2;
    final n = (2 * 3.141592653589793 * r / (dash + gap)).floor();
    final step = 2 * 3.141592653589793 / n;
    for (var i = 0; i < n; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: size.center(Offset.zero), radius: r),
        i * step,
        step * dash / (dash + gap),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingDash old) => old.color != color || old.width != width;
}
