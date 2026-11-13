import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/cities.dart';
import '../state/forms.dart';
import '../theme/colors.dart';
import '../theme/type.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/brand.dart';
import '../widgets/inputs.dart';
import '../widgets/ui.dart';

// ──────────────────────────────────────────────────────── nearby clinics ──

class NearClinicScreen extends StatelessWidget {
  const NearClinicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget clinic(
      String name,
      String kind,
      Color kindColor,
      Tone tone,
      String rating,
      String place,
      String km, {
      required bool primary,
    }) => AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      child: Row(
        spacing: 10,
        children: [
          tile(Icons.local_hospital_rounded, tone, size: 46, iconSize: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: T.h4.copyWith(fontSize: 12)),
                const SizedBox(height: 1),
                Text(
                  kind,
                  style: TextStyle(
                    fontFamily: kFont,
                    fontSize: 9.5,
                    color: kindColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  spacing: 4,
                  children: [
                    const Icon(Icons.star_rounded, size: 11, color: C.goldD),
                    Text(
                      rating,
                      style: T.cap.copyWith(
                        color: C.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text('· $place', style: T.cap.copyWith(fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            spacing: 4,
            children: [
              Num(km, size: 12, color: C.blueD),
              BtnSm(
                'Book',
                background: primary ? C.grad : C.blueT,
                foreground: primary ? Colors.white : C.blueD,
              ),
            ],
          ),
        ],
      ),
    );

    return AppScreen(
      nav: const BottomNav(active: NavTab.reports),
      children: [
        Pad(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackRow(),
              Text('Nearby Clinics', style: T.h3.copyWith(fontSize: 14)),
              const SizedBox(width: 38),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: _MapCard(),
        ),
        ScrollBody(
          gap: 9,
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('2 clinics nearby', style: T.h4),
                const AppChip('Nearest first', tone: Tone.b),
              ],
            ),
            clinic(
              'Sejahtera Dental Clinic',
              'General & Cosmetic',
              C.blueD,
              Tone.b,
              '4.8',
              'Jalan Utama, KL',
              '0.8 km',
              primary: true,
            ),
            clinic(
              'SmileCare Dental',
              'Orthodontics',
              C.okD,
              Tone.o,
              '4.6',
              'Taman Maju, PJ',
              '1.2 km',
              primary: false,
            ),
          ],
        ),
      ],
    );
  }
}

/// Sample map: grid, two roads, two parks, you-are-here and two clinics.
class _MapCard extends StatefulWidget {
  const _MapCard();
  @override
  State<_MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<_MapCard>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);
  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget pin() => Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: C.bad,
        borderRadius: BorderRadius.circular(11),
        boxShadow: Shadows.sh,
      ),
      child: const Icon(
        Icons.local_hospital_rounded,
        size: 16,
        color: Colors.white,
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 172,
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth, h = box.maxHeight;
            return Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(painter: _GridPainter()),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: h * .38,
                  height: 10,
                  child: const ColoredBox(color: C.mapRoad),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: w * .30,
                  width: 10,
                  child: const ColoredBox(color: C.mapRoad),
                ),
                Positioned(
                  top: h * .2,
                  left: w * .1,
                  child: Container(
                    width: 44,
                    height: 30,
                    decoration: BoxDecoration(
                      color: C.mapPark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  bottom: h * .08,
                  right: w * .12,
                  child: Container(
                    width: 50,
                    height: 28,
                    decoration: BoxDecoration(
                      color: C.mapPark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  top: h * .30 - 9,
                  left: w * .24 - 9,
                  child: SizedBox(
                    width: 33,
                    height: 33,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        FadeTransition(
                          opacity: Tween(begin: 1.0, end: .35).animate(_pulse),
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0x3D2E7DD2),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox.expand(),
                          ),
                        ),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: C.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: Shadows.sh,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(top: h * .14, left: w * .56, child: pin()),
                Positioned(top: h * .56, left: w * .62, child: pin()),
                Positioned(
                  bottom: 9,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: C.card,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: Shadows.sh,
                      ),
                      child: const Text(
                        'You are here',
                        style: TextStyle(
                          fontFamily: kFont,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: C.blueD,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = C.mapBg);
    final p = Paint()..color = const Color(0x242E7DD2);
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 1.5, size.height), p);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1.5), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────── learn ──

class DiseaseLibraryScreen extends ConsumerWidget {
  const DiseaseLibraryScreen({super.key});

  static const _filters = ['All', 'Gums', 'Teeth', 'Tongue'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(libraryFilterProvider);
    void open() => context.push('/disease-detail');
    Widget condition(
      IconData icon,
      Tone tone,
      String name,
      String note,
      String tag,
      Tone tagTone,
    ) => AppCard(
      onTap: open,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        spacing: 10,
        children: [
          tile(icon, tone, iconSize: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: T.h4),
                Text(note, style: T.cap.copyWith(fontSize: 9.5)),
              ],
            ),
          ),
          AppChip(tag, tone: tagTone),
        ],
      ),
    );
    return AppScreen(
      nav: const BottomNav(active: NavTab.learn),
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Learn', style: T.h2),
              const SizedBox(height: 3),
              Text('Understand your oral conditions', style: T.cap),
            ],
          ),
        ),
        ScrollBody(
          gap: 9,
          children: [
            const AppInput(
              icon: Icons.search_rounded,
              hint: 'Search conditions…',
              height: 44,
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final f in _filters)
                  Sel(
                    f,
                    on: f == filter,
                    onTap: () =>
                        ref.read(libraryFilterProvider.notifier).set(f),
                  ),
              ],
            ),
            AppCard(
              onTap: open,
              color: C.grad,
              shadow: Shadows.shb,
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppChip(
                    'Found in your scan',
                    background: Colors.white.withValues(alpha: .24),
                    foreground: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    spacing: 10,
                    children: [
                      Sq.s40(
                        color: Colors.white.withValues(alpha: .22),
                        child: const Icon(
                          Icons.coronavirus_rounded,
                          size: 21,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dental Caries',
                              style: T.h4.copyWith(color: Colors.white),
                            ),
                            Text(
                              'Cavity caused by bacterial acid',
                              style: TextStyle(
                                fontFamily: kFont,
                                fontSize: 9.5,
                                color: Colors.white.withValues(alpha: .75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Eyebrow('All conditions'),
            condition(
              Icons.healing_rounded,
              Tone.w,
              'Gingivitis',
              'Early gum inflammation',
              'Common',
              Tone.w,
            ),
            condition(
              Icons.bloodtype_rounded,
              Tone.r,
              'Periodontitis',
              'Advanced gum infection',
              'Serious',
              Tone.r,
            ),
            condition(
              Icons.grain_rounded,
              Tone.g,
              'Plaque & Calculus',
              'Hardened bacterial film',
              'Preventable',
              Tone.b,
            ),
          ],
        ),
      ],
    );
  }
}

class DiseaseDetailScreen extends StatelessWidget {
  const DiseaseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final glass = Colors.white.withValues(alpha: .2);
    final chipBg = Colors.white.withValues(alpha: .24);
    Widget head(IconData icon, String title, {Color color = C.blueD}) => Row(
      spacing: 6,
      children: [
        Icon(icon, size: 16, color: color),
        Text(
          title,
          style: T.h4.copyWith(color: color == C.blueD ? null : color),
        ),
      ],
    );
    Widget sign(String t) => Row(
      spacing: 8,
      children: [
        const Dot(color: C.blue, size: 5),
        Expanded(child: Text(t, style: T.pxs)),
      ],
    );
    return AppScreen(
      topColor: C.grad,
      lightStatusIcons: true,
      bottomPadding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      bottom: Btn(
        'Find a dentist',
        icon: Icons.place_rounded,
        height: 48,
        onTap: () => context.push('/near-clinic'),
      ),
      children: [
        // The blue header runs up under the status bar.
        Container(
          color: C.grad,
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackRow(dark: true),
                  CBtn(
                    icon: Icons.bookmark_border_rounded,
                    background: glass,
                    iconColor: Colors.white,
                    shadow: false,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                spacing: 12,
                children: [
                  Sq.s46(
                    color: Colors.white.withValues(alpha: .22),
                    child: const Icon(
                      Icons.coronavirus_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dental Caries',
                          style: TextStyle(
                            fontFamily: kFont,
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.3,
                          ),
                        ),
                        Text(
                          'Tooth decay / cavity',
                          style: TextStyle(
                            fontFamily: kFont,
                            color: Colors.white.withValues(alpha: .78),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                spacing: 6,
                children: [
                  AppChip(
                    'Found in your scan',
                    background: chipBg,
                    foreground: Colors.white,
                  ),
                  AppChip(
                    'Treatable',
                    background: chipBg,
                    foreground: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 6,
          padding: const EdgeInsets.fromLTRB(18, 9, 18, 12),
          children: [
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  head(Icons.help_rounded, 'What is it?'),
                  const SizedBox(height: 4),
                  Text(
                    'Bacteria in plaque turn sugar into acid that erodes enamel until a hole forms.',
                    style: T.pxs,
                  ),
                ],
              ),
            ),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  head(Icons.monitor_heart_rounded, 'Signs to watch'),
                  const SizedBox(height: 6),
                  Column(
                    spacing: 5,
                    children: [
                      sign('Sharp pain with sweet or cold food'),
                      sign('Brown or black spots on the tooth'),
                    ],
                  ),
                ],
              ),
            ),
            AppCard(
              color: C.okT,
              shadow: null,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  head(Icons.shield_rounded, 'Prevention', color: C.okD),
                  const SizedBox(height: 7),
                  const Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      AppChip(
                        'Brush twice daily',
                        background: C.card,
                        foreground: C.okD,
                      ),
                      AppChip('Floss', background: C.card, foreground: C.okD),
                      AppChip(
                        'Less sugar',
                        background: C.card,
                        foreground: C.okD,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const NoteCard(
              icon: Icons.warning_rounded,
              tone: Tone.r,
              shadow: false,
              bold: true,
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              text:
                  'See a dentist if pain lasts more than 2 days or gums swell.',
            ),
            Text(
              'Educational information only — not a medical diagnosis.',
              style: T.cap.copyWith(fontSize: 9.5),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────── store ──

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget product({
      required Color band,
      required IconData icon,
      required Color iconColor,
      required Widget title,
      required String sub,
      required String rating,
      required String count,
      required Widget price,
      required Widget action,
      BoxBorder? border,
    }) => AppCard(
      padding: EdgeInsets.zero,
      clip: true,
      border: border,
      child: Column(
        children: [
          Container(
            height: 88,
            color: band,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              spacing: 12,
              children: [
                Sq.s54(
                  color: C.card,
                  shadow: Shadows.sh,
                  child: Icon(icon, size: 27, color: iconColor),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      const SizedBox(height: 2),
                      Text(sub, style: T.cap.copyWith(fontSize: 9.5)),
                      const SizedBox(height: 4),
                      Row(
                        spacing: 3,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 11,
                            color: C.goldD,
                          ),
                          Text(
                            rating,
                            style: T.cap.copyWith(
                              color: C.ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text('($count)', style: T.cap.copyWith(fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [price, action],
            ),
          ),
        ],
      ),
    );
    Widget named(String name) => Text.rich(
      TextSpan(
        children: [
          brandSpan(15),
          TextSpan(text: ' $name'),
        ],
      ),
      style: T.h4,
    );

    return AppScreen(
      children: [
        Pad(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackRow(),
              Text('Store', style: T.h2),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CBtn(icon: Icons.shopping_bag_rounded, label: 'Cart'),
                  Positioned(
                    top: -2,
                    right: -3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: C.bad,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
                          fontFamily: kFont,
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 10,
          children: [
            product(
              band: C.blueT,
              icon: Icons.sensors_rounded,
              iconColor: C.blueD,
              title: named('Scanner Pro'),
              sub: 'HD intraoral camera with Wi-Fi',
              rating: '4.9',
              count: '128',
              price: const Num('RM 499', size: 18, color: C.blueD),
              action: const BtnSm(
                'Buy now',
                background: C.grad,
                foreground: Colors.white,
              ),
            ),
            product(
              band: C.okT,
              icon: Icons.science_rounded,
              iconColor: C.okD,
              title: named('Gel Kit'),
              sub: 'Scanning gel refill pack',
              rating: '4.6',
              count: '64',
              price: const Num('RM 49', size: 18, color: C.okD),
              action: const BtnSm(
                'Add to cart',
                background: C.okT,
                foreground: C.okD,
              ),
            ),
            product(
              band: C.goldT,
              border: Border.all(color: C.gold, width: 2),
              icon: Icons.inventory_2_rounded,
              iconColor: C.goldD,
              title: Row(
                spacing: 6,
                children: [
                  Text('Starter Bundle', style: T.h4),
                  const AppChip(
                    'SAVE 12%',
                    background: C.bad,
                    foreground: Colors.white,
                    fontSize: 8.5,
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  ),
                ],
              ),
              sub: 'Scanner + Gel + Case',
              rating: '4.8',
              count: '92',
              price: Row(
                spacing: 6,
                children: [
                  const Num('RM 529', size: 18, color: C.goldD),
                  Text(
                    'RM 599',
                    style: T.cap.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              action: const BtnSm(
                'Buy now',
                background: C.goldD,
                foreground: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────── chat ──

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A reply bubble is at most 80% of the row, as in the prototype.
    Widget bot(String text) => LayoutBuilder(
      builder: (context, box) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          tile(Icons.smart_toy_rounded, Tone.b),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: box.maxWidth * .8),
            child: AppCard(
              radius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              child: Text(text, style: T.pxs.copyWith(color: C.ink)),
            ),
          ),
        ],
      ),
    );
    return AppScreen(
      bottomPadding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      bottom: Row(
        spacing: 10,
        children: [
          const Expanded(child: AppInput(hint: 'Ask anything…', height: 46)),
          Sq(
            size: 46,
            color: C.blue,
            child: const Icon(
              Icons.send_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      children: [
        Pad(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackRow(label: 'Assistant'),
              const AppChip(
                'Online',
                tone: Tone.o,
                leading: Dot(color: C.ok),
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 12,
          children: [
            bot(
              'Hi Alex. I read your last scan — grade B, with calculus on the lower molars. Want to know what that means?',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 70),
                Flexible(
                  child: AppCard(
                    color: C.blue,
                    radius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(6),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    child: Text(
                      'Yes, and is it serious?',
                      style: T.pxs.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            bot(
              'Not urgent. Calculus is hardened plaque — a dentist removes it in a routine cleaning. Brushing alone won’t shift it.',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: const [
                  Sel('What is stain?', on: false),
                  Sel('Book a clinic', on: false),
                  Sel('Improve my grade', on: false),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────── dependents ──

class _Dep {
  const _Dep(
    this.name,
    this.rel,
    this.note,
    this.icon,
    this.colors, {
    this.grade,
    this.gradeColor,
  });
  final String name, rel, note;
  final IconData icon;
  final List<Color> colors;
  final String? grade;
  final Color? gradeColor;
}

const _deps = [
  _Dep(
    'Aiman',
    'Son',
    '9 years old · last scan 3 days ago',
    Icons.face_rounded,
    [Color(0xFFBFDCF5), Color(0xFF7FB6E8)],
    grade: 'A',
    gradeColor: C.okD,
  ),
  _Dep(
    'Nadia',
    'Daughter',
    '14 years old · last scan 2 weeks ago',
    Icons.face_3_rounded,
    [Color(0xFFFBD9B8), Color(0xFFF0AE63)],
    grade: 'B',
    gradeColor: C.goldD,
  ),
  _Dep(
    'Aminah',
    'Elderly',
    '68 years old · last scan 1 month ago',
    Icons.face_4_rounded,
    [Color(0xFFE3D3F3), Color(0xFFB596DD)],
    grade: 'A',
    gradeColor: C.okD,
  ),
];
const _danish = _Dep(
  'Danish Haziq',
  'Son',
  '8 years old · no scans yet',
  Icons.child_care_rounded,
  [Color(0xFFC9E6D8), Color(0xFF7FC9A8)],
);

/// The list of dependents. [added] is the view right after saving
/// Danish Haziq: a confirmation on top and his card at the end.
class DependentsScreen extends StatelessWidget {
  const DependentsScreen({super.key, this.added = false});
  final bool added;

  @override
  Widget build(BuildContext context) {
    Widget card(_Dep d) => AppCard(
      onTap: () => context.push('/dependent-profile'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        spacing: 12,
        children: [
          Sq.s46(
            gradient: LinearGradient(
              colors: d.colors,
              begin: const Alignment(-.5, -1),
              end: const Alignment(.5, 1),
            ),
            child: Icon(d.icon, size: 22, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    Text(d.name, style: T.h4),
                    RTag(d.rel),
                  ],
                ),
                Text(d.note, style: T.cap),
              ],
            ),
          ),
          if (d.grade != null)
            Num(d.grade!, size: 19, color: d.gradeColor!)
          else
            AppChip(
              'Scan now',
              tone: Tone.b,
              onTap: () => context.push('/scan-select'),
            ),
        ],
      ),
    );
    return AppScreen(
      nav: const BottomNav(active: NavTab.profile),
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackRow(label: 'Dependents'),
              const SizedBox(height: 10),
              Text('Manage the oral health of your loved ones.', style: T.p),
            ],
          ),
        ),
        ScrollBody(
          gap: 10,
          children: [
            added
                ? const NoteCard(
                    icon: Icons.check_circle_rounded,
                    tone: Tone.o,
                    text:
                        'Danish Haziq was added. Run their first scan any time.',
                  )
                : const NoteCard(
                    icon: Icons.info_rounded,
                    text:
                        'Sons and daughters must be under 18. An elderly dependent can be added at any age.',
                  ),
            for (final d in _deps) card(d),
            if (added) card(_danish),
            DashedCard(
              onTap: () => context.push('/add-dependent'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  const Icon(
                    Icons.person_add_rounded,
                    size: 20,
                    color: C.blueD,
                  ),
                  Text('Add a dependent', style: T.h4.copyWith(color: C.blueD)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AddDependentScreen extends ConsumerWidget {
  const AddDependentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(dependentFormProvider);
    final n = ref.read(dependentFormProvider.notifier);
    return AppScreen(
      bottom: Btn('Next', onTap: () => context.push('/dependent-medical')),
      children: [
        Pad(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackRow(label: 'Dependent'),
              Text(
                'Clear',
                style: T.cap.copyWith(
                  color: C.blueD,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Pad(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set up their profile', style: T.h1.copyWith(fontSize: 26)),
              const SizedBox(height: 2),
              Text(
                'They get their own records, scans and reports.',
                style: T.p,
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 9,
          children: [
            PhotoRow(onTap: () => context.push('/camera-profile')),
            const AppInput(
              icon: Icons.badge_rounded,
              hint: 'Name',
              height: 48,
              initial: 'Danish Haziq',
            ),
            const AppInput(
              icon: Icons.cake_rounded,
              hint: 'Date of birth',
              height: 48,
              keyboard: TextInputType.datetime,
            ),
            DropField(
              icon: Icons.wc_rounded,
              title: 'Gender',
              options: genders,
              value: f.gender,
              onChanged: n.gender,
            ),
            DropField(
              icon: Icons.groups_rounded,
              title: 'Ethnicity',
              options: ethnicities,
              value: f.ethnicity,
              onChanged: n.ethnicity,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 7,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text('Relationship', style: T.cap),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      for (final r in relationships)
                        Sel(
                          r,
                          on: r == f.relationship,
                          onTap: () => n.relationship(r),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const NoteCard(
              icon: Icons.info_rounded,
              shadow: false,
              text:
                  'Sons and daughters must be under 18. You stay their guardian until they turn 18.',
            ),
          ],
        ),
      ],
    );
  }
}

class DependentProfileScreen extends StatelessWidget {
  const DependentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      nav: const BottomNav(active: NavTab.profile),
      children: [
        const Pad(
          child: Align(
            alignment: Alignment.centerLeft,
            child: BackRow(label: 'Dependents'),
          ),
        ),
        ScrollBody(
          gap: 8,
          children: [
            AppCard(
              color: C.grad,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                spacing: 2,
                children: [
                  Sq(
                    size: 46,
                    circle: true,
                    color: Colors.white.withValues(alpha: .22),
                    child: const Icon(
                      Icons.face_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Aiman',
                    style: TextStyle(
                      fontFamily: kFont,
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Son · 9 years old · Male',
                    style: TextStyle(
                      fontFamily: kFont,
                      color: Colors.white.withValues(alpha: .88),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const ListCard(
              rows: [
                InfoRow(
                  icon: Icons.cake_rounded,
                  label: 'Date of birth',
                  value: '14 May 2017',
                ),
                InfoRow(
                  icon: Icons.groups_rounded,
                  label: 'Ethnicity',
                  value: 'Malay',
                ),
                InfoRow(
                  icon: Icons.monitor_heart_rounded,
                  label: 'Medical condition',
                  value: 'None recorded',
                  tone: Tone.r,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Eyebrow('Aiman’s dental record'),
            ),
            ScanRow(
              icon: Icons.check_circle_rounded,
              tone: Tone.o,
              title: 'Scan #3',
              date: '2 Aug 2026 · 19:05',
              grade: 'A',
              gradeColor: C.okD,
              onTap: () => context.push('/scan-result'),
            ),
            ScanRow(
              icon: Icons.error_outline_rounded,
              tone: Tone.w,
              title: 'Scan #2',
              date: '5 July 2026 · 18:40',
              grade: 'B',
              gradeColor: C.goldD,
              onTap: () => context.push('/scan-result'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Btn(
                'Scan Aiman',
                icon: Icons.photo_camera_rounded,
                onTap: () => context.push('/scan-select'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
