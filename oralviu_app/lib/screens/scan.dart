import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../state/forms.dart';
import '../theme/colors.dart';
import '../theme/type.dart';
import '../widgets/brand.dart';
import '../widgets/grade_face.dart';
import '../widgets/inputs.dart';
import '../widgets/pressable.dart';
import '../widgets/ui.dart';

TextStyle _white(double size, FontWeight w, [double alpha = 1]) => TextStyle(
  fontFamily: kFont,
  color: Colors.white.withValues(alpha: alpha),
  fontSize: size,
  fontWeight: w,
);

/// Back arrow, centred title and a right-hand slot, on a dark camera screen.
Widget _darkHeader(String title, {Widget right = const SizedBox(width: 38)}) =>
    Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BackRow(dark: true),
          Text(title, style: _white(13.5, FontWeight.w700)),
          right,
        ],
      ),
    );

// ───────────────────────────────────────────────────────── oral scanning ──

class ScanSelectScreen extends StatelessWidget {
  const ScanSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget option(
      IconData icon,
      Tone tone,
      String title,
      String body, {
      VoidCallback? onTap,
    }) => AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        spacing: 14,
        children: [
          tile(icon, tone, size: 54, iconSize: 26),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: T.h3),
                const SizedBox(height: 3),
                Text(body, style: T.pxs),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 20, color: C.ink3),
        ],
      ),
    );
    return AppScreen(
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackRow(label: 'Oral Scanning'),
              const SizedBox(height: 10),
              Text(
                'Scan one target area, or capture your full smile.',
                style: T.p,
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 12,
          children: [
            option(
              Icons.center_focus_strong_rounded,
              Tone.b,
              'Single Scan',
              'One tooth or one area. Fastest, best for checking a specific spot.',
              onTap: () => context.push('/device-connect'),
            ),
            // Greyed out until it ships (UI/UX spec §4).
            Semantics(
              enabled: false,
              child: Opacity(
                opacity: .45,
                child: option(
                  Icons.panorama_wide_angle_rounded,
                  Tone.o,
                  'Full Scan',
                  'Sweeps both arches, 32 teeth. Produces the complete record.',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────── device connect ──

class DeviceConnectScreen extends StatelessWidget {
  const DeviceConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final body = _white(12, FontWeight.w500, .92).copyWith(height: 1.55);
    return AppScreen(
      bottom: Btn(
        'Connect device',
        onTap: () => context.push('/device-tutorial'),
      ),
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackRow(label: 'Back'),
              const SizedBox(height: 8),
              Text('Device connection', style: T.h1.copyWith(fontSize: 26)),
            ],
          ),
        ),
        ScrollBody(
          gap: 12,
          children: [
            AppCard(
              color: C.grad,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Results displayed by '),
                        brandSpan(13, white: true),
                        const TextSpan(
                          text:
                              ' do not constitute a complete medical diagnosis.',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: _white(13, FontWeight.w700).copyWith(height: 1.5),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Icon(
                      Icons.warning_rounded,
                      size: 30,
                      color: Color(0xFFFFD9A8),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'DO NOT',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(
                          text: ' interpret or take clinical action based on ',
                        ),
                        brandSpan(12, white: true),
                        const TextSpan(
                          text:
                              ' results without first consulting a qualified healthcare professional.',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: body,
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    const TextSpan(
                      children: [
                        TextSpan(text: 'By tapping '),
                        TextSpan(
                          text: 'Connect device',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' you agree to this disclaimer.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: body,
                  ),
                  const SizedBox(height: 10),
                  Pressable(
                    onTap: () => context.push('/conditions'),
                    child: Text(
                      'Conditions of Use',
                      style: _white(12, FontWeight.w700).copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────── device tutorial ──

class DeviceTutorialScreen extends StatelessWidget {
  const DeviceTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      bottom: Btn('Start Scanning', onTap: () => context.push('/live-scanner')),
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackRow(label: 'Connect your scanner'),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Pair the '),
                    brandSpan(14),
                    const TextSpan(
                      text:
                          ' scanner with this phone. It takes about a minute.',
                    ),
                  ],
                ),
                style: T.p,
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 14,
          children: [
            const StepItem(
              n: 1,
              title: 'Power on the scanner',
              body: 'Hold the power button until the ring light turns on.',
            ),
            const StepItem(
              n: 2,
              title: 'Join the scanner’s Wi-Fi',
              body: [
                TextSpan(
                  text:
                      'Open your phone’s Wi-Fi settings and choose the network that starts with ',
                ),
                TextSpan(
                  text: 'ORALVIU-',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: '.'),
              ],
            ),
            StepItem(
              n: 3,
              title: [
                const TextSpan(text: 'Come back to '),
                brandSpan(17),
              ],
              body: 'The app finds the scanner and pairs it on its own.',
            ),
            const StepItem(
              n: 4,
              title: 'Wait for “Connected”',
              body:
                  'Keep the scanner close to your phone until the status turns green.',
            ),
            const NoteCard(
              icon: Icons.info_rounded,
              shadow: false,
              text:
                  'Scanner not showing up? Switch it off and on again, then repeat step 2.',
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────── live scanner ──

/// Everything below the header is plain black: it is not yet known what the
/// scanner backend can show. Tapping the black area stands in for the shutter.
class LiveScannerScreen extends StatelessWidget {
  const LiveScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      background: C.camera,
      lightStatusIcons: true,
      children: [
        _darkHeader(
          'Live Scanner',
          right: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0x382FAE86),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '● LIVE',
              style: const TextStyle(
                fontFamily: kFont,
                color: Color(0xFF4FD1A5),
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(
          child: Semantics(
            button: true,
            label: 'Take photo',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push('/image-capture'),
              child: const ColoredBox(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────── review photo ──

class ImageCaptureScreen extends StatelessWidget {
  const ImageCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      background: C.camera,
      lightStatusIcons: true,
      bottomColor: C.camera,
      bottomPadding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Btn(
            'Analyse with AI',
            icon: Icons.auto_awesome_rounded,
            onTap: () => context.push('/ai-processing'),
          ),
          BtnGhost(
            'Retake photo',
            icon: Icons.replay_rounded,
            color: Colors.white.withValues(alpha: .55),
            onTap: () => goBack(context),
          ),
        ],
      ),
      children: [
        _darkHeader('Review Photo'),
        Expanded(
          child: Container(
            color: C.cameraSoft,
            alignment: Alignment.center,
            child: Container(
              width: 230,
              height: 196,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x2E6EC0FF), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Icon(
                    Icons.image_rounded,
                    size: 44,
                    color: Colors.white.withValues(alpha: .16),
                  ),
                  Text(
                    'Captured image',
                    style: _white(11, FontWeight.w600, .3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────── analysing ──

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({super.key});
  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen>
    with TickerProviderStateMixin {
  late final _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..repeat(reverse: true);
  late final _fill = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();
  late final _dots = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..repeat();

  @override
  void dispose() {
    for (final c in [_spin, _pulse, _fill, _dots]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget step(
      Widget badge,
      String text, {
      bool done = true,
      bool pending = false,
    }) => Row(
      spacing: 10,
      children: [
        badge,
        Text(
          text,
          style: _white(
            12,
            pending ? FontWeight.w500 : FontWeight.w600,
            pending ? .6 : 1,
          ),
        ),
      ],
    );
    const tick = Sq(
      size: 22,
      circle: true,
      color: Colors.white,
      child: Icon(Icons.check_rounded, size: 14, color: C.ok),
    );

    return AppScreen(
      background: C.grad,
      lightStatusIcons: true,
      children: [
        Expanded(
          child: Semantics(
            button: true,
            label: 'Continue',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push('/report-form'),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height - 120,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      const BrandLogo(height: 46, white: true),
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: FadeTransition(
                                opacity: Tween(
                                  begin: 1.0,
                                  end: .35,
                                ).animate(_pulse),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: .16),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: RotationTransition(
                                turns: _spin,
                                child: const CustomPaint(
                                  painter: _RingPainter(),
                                ),
                              ),
                            ),
                            Center(
                              child: SvgPicture.asset(
                                'assets/svg/tooth_mascot.svg',
                                width: 62,
                                height: 68,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        spacing: 5,
                        children: [
                          Text(
                            'Analysing your scan',
                            style: _white(
                              23,
                              FontWeight.w800,
                            ).copyWith(letterSpacing: -.4),
                          ),
                          Text(
                            'This usually takes about 10 seconds',
                            style: _white(12.5, FontWeight.w500, .8),
                          ),
                        ],
                      ),
                      Column(
                        spacing: 6,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 7,
                              color: Colors.white.withValues(alpha: .28),
                              alignment: Alignment.centerLeft,
                              child: AnimatedBuilder(
                                animation: _fill,
                                builder: (_, _) {
                                  final t = const Cubic(
                                    .4,
                                    0,
                                    .2,
                                    1,
                                  ).transform(_fill.value);
                                  final w = t < .55
                                      ? .04 + (.72 - .04) * (t / .55)
                                      : .72 + (.97 - .72) * ((t - .55) / .45);
                                  return FractionallySizedBox(
                                    widthFactor: w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Step 3 of 4',
                                style: _white(10, FontWeight.w700, .8),
                              ),
                              Text('72%', style: _white(10, FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .16),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 10,
                          children: [
                            step(tick, 'Image captured'),
                            step(tick, 'Pre-processing complete'),
                            step(
                              Sq(
                                size: 22,
                                circle: true,
                                color: Colors.white.withValues(alpha: .32),
                                child: _BouncingDots(_dots),
                              ),
                              'Detecting tooth conditions…',
                            ),
                            step(
                              Sq(
                                size: 22,
                                circle: true,
                                color: Colors.white.withValues(alpha: .16),
                                child: Icon(
                                  Icons.more_horiz_rounded,
                                  size: 13,
                                  color: Colors.white.withValues(alpha: .6),
                                ),
                              ),
                              'Generating report',
                              pending: true,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 6,
                        children: [
                          Icon(
                            Icons.lightbulb_rounded,
                            size: 14,
                            color: Colors.white.withValues(alpha: .7),
                          ),
                          Flexible(
                            child: Text(
                              'Did you know? Flossing reaches 40% of your tooth surface.',
                              textAlign: TextAlign.center,
                              style: _white(10.5, FontWeight.w500, .8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 130;
    canvas.scale(s);
    const c = Offset(65, 65);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Colors.white.withValues(alpha: .24);
    canvas.drawCircle(c, 56, track);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    // dash 88 of a 351.9 circumference
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: 56),
      0,
      88 / 56,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BouncingDots extends StatelessWidget {
  const _BouncingDots(this.anim);
  final Animation<double> anim;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, _) => Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2.5,
      children: [
        for (var i = 0; i < 3; i++)
          Builder(
            builder: (_) {
              final t = (anim.value - i * .147) % 1;
              final k = t < .3 ? t / .3 : (t < .6 ? 1 - (t - .3) / .3 : 0.0);
              return Transform.translate(
                offset: Offset(0, -9 * .4 * k),
                child: Container(
                  width: 3.5,
                  height: 3.5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .55 + .45 * k),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────── symptom form ──

class ReportFormScreen extends ConsumerWidget {
  const ReportFormScreen({super.key});

  static const _symptoms = [
    'Toothache',
    'Bleeding gums',
    'Cold sensitivity',
    'Bad breath',
  ];
  static const _durations = ['< 1 day', '1–7 days', '> 1 week'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picked = ref.watch(symptomsProvider);
    final duration = ref.watch(durationProvider);
    Widget group(String label, Widget child) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 7,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(label, style: T.cap),
        ),
        child,
      ],
    );
    return AppScreen(
      bottomPadding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      bottom: Btn(
        'Generate report',
        icon: Icons.auto_awesome_rounded,
        onTap: () => context.push('/scan-result'),
      ),
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackRow(label: 'Back'),
              const SizedBox(height: 8),
              Text('Symptom report', style: T.h1.copyWith(fontSize: 22)),
              const SizedBox(height: 3),
              Text('Tell us what you feel', style: T.p),
            ],
          ),
        ),
        ScrollBody(
          gap: 11,
          children: [
            group(
              'What are you experiencing? (select all)',
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final s in _symptoms)
                    Sel(
                      s,
                      on: picked.contains(s),
                      onTap: () =>
                          ref.read(symptomsProvider.notifier).toggle(s),
                    ),
                ],
              ),
            ),
            group('Pain level', const _PainCard()),
            group(
              'How long has it lasted?',
              Row(
                spacing: 6,
                children: [
                  for (final d in _durations)
                    Expanded(
                      child: Sel(
                        d,
                        center: true,
                        on: d == duration,
                        onTap: () => ref.read(durationProvider.notifier).set(d),
                      ),
                    ),
                ],
              ),
            ),
            group(
              'Additional notes',
              const AppInput(
                icon: Icons.edit_note_rounded,
                hint: 'e.g. hurts when eating sweets…',
                height: 56,
                multiline: true,
              ),
            ),
            Row(
              spacing: 6,
              children: [
                const Icon(Icons.lock_rounded, size: 14, color: C.ink3),
                Text('Used only to generate your report.', style: T.cap),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Pain level 1–5: drag or tap along the green→red track.
class _PainCard extends ConsumerWidget {
  const _PainCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(painProvider);
    final frac = (level - .1) / 5;
    return AppCard(
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, box) {
              void set(double x) => ref
                  .read(painProvider.notifier)
                  .set((x / box.maxWidth * 5 + .5).round());
              return Semantics(
                slider: true,
                label: 'Pain level',
                value: '$level of 5',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (d) => set(d.localPosition.dx),
                  onHorizontalDragUpdate: (d) => set(d.localPosition.dx),
                  child: SizedBox(
                    height: 26,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: C.bg,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 8,
                          width: box.maxWidth * frac,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              colors: const [C.ok, C.gold, C.bad],
                              // the gradient spans the filled part, as in the prototype
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 150),
                          left: box.maxWidth * frac - 11,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: C.card,
                              shape: BoxShape.circle,
                              border: Border.all(color: C.bad, width: 3),
                              boxShadow: Shadows.sh2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mild', style: T.cap),
              AppChip('Level $level of 5', tone: Tone.r),
              Text('Severe', style: T.cap),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────── report ──

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget finding(Color dot, String name, String note, Color grade) => AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        spacing: 12,
        children: [
          Dot(color: dot, size: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: T.h4),
                Text(note, style: T.cap),
              ],
            ),
          ),
          GradeFace('B', size: 20, color: grade),
        ],
      ),
    );
    return AppScreen(
      // Download PDF has no destination yet.
      bottom: const Btn('Download PDF', icon: Icons.picture_as_pdf_rounded),
      children: [
        Pad(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackRow(label: 'Report'),
              const AppChip('Single scan', tone: Tone.b),
            ],
          ),
        ),
        ScrollBody(
          gap: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 190,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(.04, -.08),
                          radius: 1.1,
                          colors: [
                            Color(0xFF6E4B42),
                            Color(0xFF2A1A16),
                            Color(0xFF0E1620),
                          ],
                          stops: [0, .62, 1],
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/svg/scan_photo.svg',
                      fit: BoxFit.contain,
                    ),
                    const Positioned(
                      left: 10,
                      bottom: 8,
                      child: AppChip(
                        '2 detections',
                        background: Color(0x8C000000),
                        foreground: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Lab('Oral health score'),
                  const SizedBox(height: 2),
                  Row(
                    spacing: 8,
                    children: [
                      const GradeFace('C', size: 34, color: C.warnD),
                      Text('Fair', style: T.h4.copyWith(color: C.warnD)),
                    ],
                  ),
                ],
              ),
            ),
            const Lab('Detected'),
            finding(
              C.gold,
              'Calculus',
              'Hardened plaque on the crown',
              C.goldD,
            ),
            finding(C.blue, 'Stain', 'Surface discolouration', C.blueD),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────── perfect teeth ──

class PerfectScreen extends StatelessWidget {
  const PerfectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget stat(String n, String label, {Color? color}) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Text(n, style: T.h3.copyWith(color: color)),
            Text(label, style: T.cap),
          ],
        ),
      ),
    );
    const rule = SizedBox(width: 1, child: ColoredBox(color: C.brd));
    return AppScreen(
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          Btn('View full report', onTap: () => context.push('/scan-result')),
          // Share has no destination yet.
          const BtnGhost('Share result', icon: Icons.ios_share_rounded),
        ],
      ),
      children: [
        Pad(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackRow(),
              const AppChip('Scan complete', tone: Tone.o),
            ],
          ),
        ),
        ScrollBody(
          gap: 8,
          children: [
            Column(
              spacing: 6,
              children: [
                tile(Icons.verified_rounded, Tone.o, size: 54, iconSize: 29),
                const SizedBox(height: 2),
                Text('Perfect teeth', style: T.h1.copyWith(fontSize: 26)),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 236),
                  child: Text(
                    'No decay, no plaque or gum inflammation found.',
                    textAlign: TextAlign.center,
                    style: T.p.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 6,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: GradeFace('A+', size: 36, color: C.okD),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('/ 100', style: T.cap),
                ),
              ],
            ),
            SizedBox(
              height: 134,
              child: SvgPicture.asset('assets/svg/arch_allclear.svg'),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: C.brd),
                  bottom: BorderSide(color: C.brd),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    stat('32', 'Teeth clear'),
                    rule,
                    stat('0', 'Findings'),
                    rule,
                    stat('+1', 'Streak', color: C.okD),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────── how to scan ──

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      bottom: Btn(
        'Start scanning',
        onTap: () => context.push('/device-connect'),
      ),
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackRow(label: 'How to scan'),
              const SizedBox(height: 10),
              Text(
                'Four steps, about a minute. Works best in a well-lit room.',
                style: T.p,
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 12,
          children: [
            const StepItem(
              n: 1,
              title: 'Power on the scanner',
              body:
                  'Hold the button until the ring lights up, then connect over Wi-Fi.',
            ),
            const StepItem(
              n: 2,
              title: 'Open wide',
              body:
                  "Line your teeth up inside the frame. The guide corners turn blue when you're aligned.",
            ),
            const StepItem(
              n: 3,
              title: 'Hold steady',
              body:
                  'Stay still for three seconds while the scanner sweeps each arch.',
            ),
            const StepItem(
              n: 4,
              title: 'Read your report',
              body:
                  'The AI returns a score, a tooth-by-tooth map and what to do next.',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: AppCard(
                child: Row(
                  spacing: 12,
                  children: [
                    tile(
                      Icons.play_circle_rounded,
                      Tone.b,
                      size: 40,
                      iconSize: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Watch the usage video', style: T.h4),
                          Text('2 minutes', style: T.cap),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: C.ink3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────── system states ──

class StatesScreen extends StatelessWidget {
  const StatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System states', style: T.h2),
              const SizedBox(height: 3),
              Text('Skeleton · error · empty', style: T.cap),
            ],
          ),
        ),
        ScrollBody(
          gap: 8,
          children: [
            const Eyebrow('Loading (skeleton)'),
            const AppCard(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              child: Row(
                spacing: 10,
                children: [
                  Skeleton(width: 40, height: 40, radius: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        FractionallySizedBox(
                          widthFactor: .72,
                          child: Skeleton(height: 11),
                        ),
                        FractionallySizedBox(
                          widthFactor: .44,
                          child: Skeleton(height: 9),
                        ),
                      ],
                    ),
                  ),
                  Skeleton(width: 34, height: 20, radius: 100),
                ],
              ),
            ),
            const SizedBox(height: 2),
            const Eyebrow('Connection error'),
            AppCard(
              color: C.badT,
              shadow: null,
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                children: [
                  const Sq.s46(
                    color: C.card,
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 24,
                      color: C.badD,
                    ),
                  ),
                  Text('Connection lost', style: T.h4.copyWith(color: C.badD)),
                  Text(
                    'The scanner lost signal. Your scan data is safely stored.',
                    textAlign: TextAlign.center,
                    style: T.pxs,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: BtnSm(
                            'Later',
                            background: C.card,
                            foreground: C.badD,
                            onTap: () => context.go('/dashboard'),
                          ),
                        ),
                        Expanded(
                          child: BtnSm(
                            'Try again',
                            background: C.bad,
                            foreground: Colors.white,
                            onTap: () => context.push('/device-connect'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            const Eyebrow('No data'),
            AppCard(
              padding: const EdgeInsets.all(17),
              child: Column(
                spacing: 8,
                children: [
                  tile(
                    Icons.auto_awesome_rounded,
                    Tone.b,
                    size: 46,
                    iconSize: 24,
                  ),
                  Text('No scans yet', style: T.h4),
                  Text(
                    'Run your first scan to see your oral health score.',
                    textAlign: TextAlign.center,
                    style: T.pxs,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: BtnSm(
                      'Start scanning',
                      background: C.blueT,
                      foreground: C.blueD,
                      onTap: () => context.push('/live-scanner'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Shimmering placeholder block.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    required this.height,
    this.radius = 9,
  });
  final double? width;
  final double height, radius;
  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, _) {
      final x = -1.5 + 3 * _c.value;
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(x - 1, 0),
            end: Alignment(x + 1, 0),
            colors: const [C.skel1, C.skel2, C.skel1],
            stops: const [.25, .5, .75],
          ),
        ),
      );
    },
  );
}
