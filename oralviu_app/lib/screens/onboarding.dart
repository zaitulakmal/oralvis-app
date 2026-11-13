import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../theme/colors.dart';
import '../theme/type.dart';
import '../widgets/brand.dart';
import '../widgets/grade_face.dart';
import '../widgets/pressable.dart';
import '../widgets/ui.dart';

// ───────────────────────────────────────────────────────────────── splash ──

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return AppScreen(
      background: C.grad,
      lightStatusIcons: true,
      bottomPadding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      bottom: Row(
        spacing: 12,
        children: [
          Icon(
            Icons.chevron_left_rounded,
            size: 20,
            color: Colors.white.withValues(alpha: .4),
          ),
          Expanded(
            child: Btn(
              'Get Started',
              style: BtnStyle.white,
              height: 54,
              trailingIcon: Icons.arrow_forward_rounded,
              onTap: () => context.go('/onboarding'),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: Colors.white.withValues(alpha: .4),
          ),
        ],
      ),
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLogo(height: 58, white: true),
                const SizedBox(height: 28),
                const Text(
                  'Feel Amazing\nAbout Your\nOral Health',
                  style: TextStyle(
                    fontFamily: kFont,
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.26,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    'Clinical-grade oral scanning in your pocket. Scan, understand, and act — in under a minute.',
                    style: TextStyle(
                      fontFamily: kFont,
                      color: Colors.white.withValues(alpha: .78),
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: SplashTooth(width: math.min(w * .64, 262)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// White 2D tooth with a teal orbit: the bright head runs behind the tooth
/// and back out in front. The whole thing floats gently.
class SplashTooth extends StatefulWidget {
  const SplashTooth({super.key, required this.width});
  final double width;
  @override
  State<SplashTooth> createState() => _SplashToothState();
}

class _SplashToothState extends State<SplashTooth>
    with TickerProviderStateMixin {
  late final _orbit = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3400),
  )..repeat();
  late final _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _orbit.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final h = widget.width * 134 / 164;
    return Semantics(
      label: 'ORALVIU tooth',
      image: true,
      child: AnimatedBuilder(
        animation: Listenable.merge([_orbit, _float]),
        builder: (_, _) {
          final t = reduce ? 0.0 : _orbit.value;
          final dy = reduce
              ? 0.0
              : -8 * Curves.easeInOut.transform(_float.value);
          return Transform.translate(
            offset: Offset(0, dy),
            child: SizedBox(
              width: widget.width,
              height: h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _OrbitPainter(t, front: false)),
                  ),
                  Positioned.fill(
                    child: SvgPicture.asset('assets/svg/tooth_splash.svg'),
                  ),
                  Positioned.fill(
                    child: CustomPaint(painter: _OrbitPainter(t, front: true)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter(this.t, {required this.front});
  final double t;
  final bool front;

  @override
  void paint(Canvas canvas, Size size) {
    // viewBox -22 0 164 134
    final s = size.width / 164;
    canvas.save();
    canvas.scale(s);
    canvas.translate(22, 0);
    // rotate(-20 60 74)
    canvas.translate(60, 74);
    canvas.rotate(-20 * math.pi / 180);
    canvas.translate(-60, -74);
    if (front) canvas.clipRect(const Rect.fromLTWH(-40, 74, 200, 60));

    final oval = Rect.fromCenter(
      center: const Offset(60, 74),
      width: 152,
      height: 42,
    );
    canvas.drawOval(
      oval,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = const Color(0x477CF2D0),
    );

    // dash 34 of 100, moving forward round the ellipse
    final metric = (Path()..addOval(oval)).computeMetrics().first;
    final len = metric.length;
    final start = (t * 100) % 100, end = start + 34;
    final head = Path()
      ..addPath(
        metric.extractPath(start / 100 * len, math.min(end, 100) / 100 * len),
        Offset.zero,
      );
    if (end > 100) {
      head.addPath(metric.extractPath(0, (end - 100) / 100 * len), Offset.zero);
    }
    canvas.drawPath(
      head,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(
          colors: [Color(0xFF7CF2D0), Color(0xFF3EE0B5)],
        ).createShader(Rect.fromLTRB(oval.left, 0, oval.right, 1)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.t != t;
}

// ─────────────────────────────────────────────────────── feature carousel ──

class _Slide {
  const _Slide(this.title, this.body, this.hero, this.b1, this.b2);
  final String title;
  final Object body;
  final Widget hero;
  final IconData b1, b2;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pages = PageController();
  int _i = 0;

  static final _slides = <_Slide>[
    _Slide(
      'Scan. Understand.\nSmile.',
      [
        const TextSpan(text: 'Point the '),
        brandSpan(14),
        const TextSpan(
          text:
              ' camera inside your mouth. Our AI reads the image and returns a clear oral health score in seconds.',
        ),
      ],
      SvgPicture.asset('assets/svg/tooth_mascot.svg', width: 96, height: 104),
      Icons.photo_camera_rounded,
      Icons.auto_awesome_rounded,
    ),
    const _Slide(
      'Oral Health Score',
      'Get immediate feedback on your condition. Every scan returns a clear grade you can act on.',
      GradeFace('A', size: 96, color: C.blue),
      Icons.bolt_rounded,
      Icons.auto_awesome_rounded,
    ),
    const _Slide(
      'My Reports',
      'Track your AI assessment history and see how your oral health changes over time.',
      Icon(Icons.description_rounded, size: 84, color: C.blue),
      Icons.insights_rounded,
      Icons.history_rounded,
    ),
    const _Slide(
      'My Dependents',
      'Monitor your family’s hygiene progress, with a separate record for each member.',
      Icon(Icons.family_restroom_rounded, size: 84, color: C.blue),
      Icons.child_care_rounded,
      Icons.favorite_rounded,
    ),
    const _Slide(
      'Find Clinic & Chat',
      'Locate dental clinics near you and get instant support whenever you need it.',
      Icon(Icons.place_rounded, size: 84, color: C.blue),
      Icons.forum_rounded,
      Icons.medical_services_rounded,
    ),
    const _Slide(
      'Store & Learn',
      'Shop oral care products and explore healthy habits for the whole family.',
      Icon(Icons.shopping_bag_rounded, size: 84, color: C.blue),
      Icons.menu_book_rounded,
      Icons.auto_awesome_rounded,
    ),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    if (_i < _slides.length - 1) {
      _pages.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = _i == _slides.length - 1;
    return AppScreen(
      bottomPadding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              for (var n = 0; n < _slides.length; n++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: n == _i ? 24 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: n == _i ? C.blue : C.blueT,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
          Btn(
            last ? 'Get started' : 'Continue',
            trailingIcon: Icons.arrow_forward_rounded,
            onTap: _next,
          ),
        ],
      ),
      children: [
        Pad(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('STEP ${_i + 1} OF ${_slides.length}', style: T.cap),
              Pressable(
                onTap: () => context.go('/sign-in'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Text('SKIP', style: T.cap.copyWith(color: C.blueD)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pages,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _i = i),
            itemBuilder: (_, i) => _SlideView(_slides[i]),
          ),
        ),
      ],
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView(this.s);
  final _Slide s;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          SizedBox(
            width: 190,
            height: 190,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: C.blueT,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: _SpinningDashes(),
                  ),
                ),
                Positioned.fill(child: Center(child: s.hero)),
                Positioned(
                  right: 6,
                  top: 26,
                  child: CBtn(
                    icon: s.b1,
                    size: 42,
                    iconSize: 21,
                    background: C.grad,
                    iconColor: Colors.white,
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 34,
                  child: CBtn(
                    icon: s.b2,
                    size: 38,
                    iconSize: 19,
                    iconColor: C.goldD,
                  ),
                ),
              ],
            ),
          ),
          Column(
            spacing: 8,
            children: [
              Text(s.title, textAlign: TextAlign.center, style: T.h1),
              s.body is String
                  ? Text(
                      s.body as String,
                      textAlign: TextAlign.center,
                      style: T.p,
                    )
                  : Text.rich(
                      TextSpan(children: s.body as List<InlineSpan>),
                      textAlign: TextAlign.center,
                      style: T.p,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The slowly turning dashed ring behind each feature picture.
class _SpinningDashes extends StatefulWidget {
  const _SpinningDashes();
  @override
  State<_SpinningDashes> createState() => _SpinningDashesState();
}

class _SpinningDashesState extends State<_SpinningDashes>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 26),
  )..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RotationTransition(
    turns: _c,
    child: const CustomPaint(painter: _DashedCircle()),
  );
}

class _DashedCircle extends CustomPainter {
  const _DashedCircle();
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - 1;
    final c = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x522E7DD2);
    const dash = 6.0, gap = 4.0;
    final n = (2 * math.pi * r / (dash + gap)).floor();
    final step = 2 * math.pi / n, sweep = step * dash / (dash + gap);
    for (var i = 0; i < n; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        i * step,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
