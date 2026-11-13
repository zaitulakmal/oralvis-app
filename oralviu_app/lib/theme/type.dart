import 'package:flutter/material.dart';

import 'colors.dart';

const kFont = 'PlusJakartaSans';

/// Text styles, one for one with the prototype's type classes.
///
/// Weights are the ones the prototype actually renders: it asks for 300 on
/// headings and 200 on numbers, but only loads 400-800, so the browser draws
/// both at 400. The same weights are used here so the app matches what was
/// signed off.
abstract final class T {
  static const _base = TextStyle(fontFamily: kFont, color: C.ink);

  static final h1 = _base.copyWith(
    fontSize: 33,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.1,
    height: 1.14,
  );
  static final h2 = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );
  static final h3 = _base.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );
  static final h4 = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );
  static final p = _base.copyWith(
    fontSize: 14,
    color: C.ink2,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );
  static final pxs = _base.copyWith(
    fontSize: 12.5,
    color: C.ink2,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );
  static final cap = _base.copyWith(
    fontSize: 12,
    color: C.ink3,
    fontWeight: FontWeight.w400,
  );

  /// `.eyebrow` — callers pass upper-case text.
  static final eyebrow = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: C.ink3,
  );

  /// The small upper-case section label (`.lab`) — callers pass upper-case text.
  static final lab = _base.copyWith(
    fontSize: 9.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
    color: C.ink3,
  );

  static final lnk = TextStyle(color: C.blueD, fontWeight: FontWeight.w500);

  /// `.num` — numbers and figures.
  static final num = _base.copyWith(
    fontWeight: FontWeight.w400,
    letterSpacing: -2,
  );
}
