import 'package:flutter/material.dart';

/// Colour tokens, one for one with the prototype's `:root` variables
/// (index.html). Names drop the leading `--`; `-d` is "dark", `-t` is "tint".
abstract final class C {
  static const bg = Color(0xFFF1F7FC);
  static const card = Color(0xFFFFFFFF);

  static const blue = Color(0xFF0678B8);
  static const blueD = Color(0xFF0A6497);
  static const blueL = Color(0xFF8FCBEE);
  static const blueT = Color(0xFFDFF0FB);
  static const blueT2 = Color(0xFFEFF8FE);

  /// `--grad` and `--grad-s` are both flat blue in this build.
  static const grad = blue;

  static const pink = Color(0xFFBA4A78);
  static const gold = Color(0xFFB0842A);
  static const goldD = Color(0xFF8A6317);
  static const goldT = Color(0xFFFBF0D3);
  static const ok = Color(0xFF1F8A63);
  static const okD = Color(0xFF1F7A55);
  static const okT = Color(0xFFE0F5EA);
  static const warn = Color(0xFFBE6A2A);
  static const warnD = Color(0xFF96551F);
  static const warnT = Color(0xFFFDEEDC);
  static const bad = Color(0xFFC24F58);
  static const badD = Color(0xFFA83F49);
  static const badT = Color(0xFFFCDFE3);

  static const ink = Color(0xFF17323F);
  static const ink2 = Color(0xFF4A6472);
  static const ink3 = Color(0xFF5C7382);
  static const line = Color(0xFFDCE9F2);
  static const brd = Color(0xFFDCE9F2);
  static const brd2 = Color(0xFFC7DCE9);
  static const barBg = Color(0xFFC7DCE9);
  static const neutral = Color(0xFFEAF3FA);

  static const mapBg = Color(0xFFE4EFF8);
  static const mapRoad = Color(0xFFFFFFFF);
  static const mapPark = Color(0xFFDDF1E4);

  static const skel1 = Color(0xFFE3EEF6);
  static const skel2 = Color(0xFFF1F7FC);

  /// Dark camera screens.
  static const camera = Color(0xFF0A0A0B);
  static const cameraSoft = Color(0xFF1C1C1E);
}

/// The prototype's three shadows.
abstract final class Shadows {
  /// `--sh`: a hard 3px drop, no blur.
  static const sh = [BoxShadow(color: Color(0x1A17323F), offset: Offset(0, 3))];

  /// `--shb`: the soft blue glow under primary buttons.
  static const shb = [
    BoxShadow(color: Color(0x420678B8), offset: Offset(0, 4), blurRadius: 14),
  ];

  /// `--sh2`: a 1px line above.
  static const sh2 = [BoxShadow(color: C.line, offset: Offset(0, -1))];
}
