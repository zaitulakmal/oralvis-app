import 'package:flutter/material.dart';

/// The ORALVIU logo supplied by the client (908 × 377).
/// [white] is the version for blue grounds, with the tagline knocked out.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.height, this.white = false});

  final double height;
  final bool white;

  static const aspect = 908 / 377;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'ORALVIU · Smart Scan, Sparkling Smile',
      image: true,
      child: Image.asset(
        white
            ? 'assets/images/logo_white.png'
            : 'assets/images/logo_colour.png',
        height: height,
        width: height * aspect,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

/// The logo sitting inside a sentence in place of the word ORALVIU
/// (prototype `.brand.in`: 2em tall, nudged down to sit on the line).
InlineSpan brandSpan(double fontSize, {bool white = false}) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: fontSize * .08),
      child: Semantics(
        label: 'ORALVIU',
        child: ExcludeSemantics(
          child: BrandLogo(height: fontSize * 2, white: white),
        ),
      ),
    ),
  );
}
