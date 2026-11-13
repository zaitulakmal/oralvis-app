import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Grades are shown as drawn line faces, not letters or emoji: one mouth per
/// grade, from a broad smile (A+) to a frown (F). Same drawing as the
/// prototype's `faceFor()`.
const _mouth = {
  'A+': 'M7.4 13.3c1.1 2.6 2.8 3.7 4.6 3.7s3.5-1.1 4.6-3.7',
  'A': 'M8 13.8c.9 1.9 2.3 2.8 4 2.8s3.1-.9 4-2.8',
  'B': 'M8.6 14.4c.8 1.2 2 1.8 3.4 1.8s2.6-.6 3.4-1.8',
  'C': 'M8.4 15h7.2',
  'D': 'M8.6 16.2c.8-1.2 2-1.8 3.4-1.8s2.6.6 3.4 1.8',
  'E': 'M8 16.6c.9-1.9 2.3-2.8 4-2.8s3.1.9 4 2.8',
  'F': 'M7.4 17c1.1-2.6 2.8-3.7 4.6-3.7s3.5 1.1 4.6 3.7',
};

/// Verdict chips reuse the grade faces.
const verdictGrade = {
  'Healthy': 'A',
  'Mild': 'B',
  'Attention': 'D',
  'Serious': 'F',
};

String _svg(String grade) {
  final mouth = _mouth[grade] ?? _mouth['C']!;
  final sparkle = grade == 'A+'
      ? '<path d="M20.4 3.1l.62 1.68 1.68.62-1.68.62-.62 1.68-.62-1.68-1.68-.62 1.68-.62z" fill="currentColor"/>'
      : '';
  return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
      '<circle cx="12" cy="12" r="9.2" fill="none" stroke="currentColor" stroke-width="1.6"/>'
      '<circle cx="8.8" cy="10" r="1.15" fill="currentColor"/>'
      '<circle cx="15.2" cy="10" r="1.15" fill="currentColor"/>'
      '<path d="$mouth" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>'
      '$sparkle</svg>';
}

class GradeFace extends StatelessWidget {
  const GradeFace(
    this.grade, {
    super.key,
    required this.size,
    required this.color,
    this.label,
  });

  final String grade;
  final double size;
  final Color color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label ?? 'Grade $grade',
      image: true,
      child: SvgPicture.string(
        _svg(grade),
        width: size,
        height: size,
        theme: SvgTheme(currentColor: color),
      ),
    );
  }
}
