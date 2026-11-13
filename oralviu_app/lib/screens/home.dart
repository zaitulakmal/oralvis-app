import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/colors.dart';
import '../theme/type.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/grade_face.dart';
import '../widgets/streak.dart';
import '../widgets/ui.dart';

// ─────────────────────────────────────────────────────────────── dashboard ──

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget action(IconData icon, String label, String path) => Expanded(
      child: AppCard(
        onTap: () => context.push(path),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Column(
          spacing: 8,
          children: [
            tile(icon, Tone.b, size: 40, iconSize: 20),
            Text(
              label,
              textAlign: TextAlign.center,
              style: T.cap.copyWith(
                fontSize: 9.5,
                color: C.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    return AppScreen(
      nav: const BottomNav(active: NavTab.dashboard),
      children: [
        Pad(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 10),
          child: Row(
            children: [
              const Sq(
                size: 40,
                circle: true,
                color: C.grad,
                child: Icon(
                  Icons.person_rounded,
                  size: 21,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi,', style: T.cap),
                    Text('Alex Johnson', style: T.h3.copyWith(fontSize: 15)),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CBtn(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                  ),
                  Positioned(
                    top: 1,
                    right: 1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: C.bad,
                        shape: BoxShape.circle,
                        border: Border.all(color: C.card, width: 2),
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
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 12),
          children: [
            AppCard(
              onTap: () => context.push('/scan-result'),
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Eyebrow('Your oral health score'),
                  const SizedBox(height: 12),
                  const GradeFace('A', size: 96, color: C.grad),
                  const SizedBox(height: 16),
                  Text('Good condition', style: T.h3),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: C.neutral,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        const Icon(
                          Icons.trending_up_rounded,
                          size: 14,
                          color: C.okD,
                        ),
                        Text(
                          'Up from B last week',
                          style: T.cap.copyWith(
                            color: C.ink,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const StreakCard(),
            Text('Actions', style: T.h3),
            Row(
              spacing: 8,
              children: [
                action(
                  Icons.photo_camera_rounded,
                  'Start Scan',
                  '/scan-select',
                ),
                action(Icons.description_rounded, 'My Reports', '/progress'),
                action(
                  Icons.family_restroom_rounded,
                  'My Dependents',
                  '/dependents',
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                action(Icons.place_rounded, 'Find Clinic', '/near-clinic'),
                action(Icons.shopping_bag_rounded, 'Store', '/store'),
                action(Icons.forum_rounded, 'Chat', '/chat'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────── my reports ──

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const _bars = [
    ('D', .30, 'FEB'),
    ('C', .45, 'MAR'),
    ('C', .53, 'APR'),
    ('B', .74, 'MAY'),
    ('B', .82, 'JUN'),
    ('A', 1.0, 'JUL'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      nav: const BottomNav(active: NavTab.reports),
      children: [
        Pad(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Reports', style: T.h2),
              const AppChip('6 months', tone: Tone.b),
            ],
          ),
        ),
        ScrollBody(
          gap: 7,
          children: [
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AVERAGE SCORE', style: T.cap),
                            const SizedBox(height: 3),
                            const Row(
                              spacing: 6,
                              children: [
                                GradeFace('B', size: 40, color: C.okD),
                                AppChip('+12%', tone: Tone.o),
                              ],
                            ),
                          ],
                        ),
                      ),
                      tile(
                        Icons.insights_rounded,
                        Tone.b,
                        size: 40,
                        iconSize: 21,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 7,
                    children: [
                      for (var i = 0; i < _bars.length; i++)
                        Expanded(
                          child: _Bar(
                            _bars[i].$1,
                            _bars[i].$2,
                            _bars[i].$3,
                            i,
                            hi: i == _bars.length - 1,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const StreakCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Eyebrow('Scan history'),
                Text('VIEW ALL', style: T.cap.copyWith(color: C.blueD)),
              ],
            ),
            ScanRow(
              icon: Icons.verified_rounded,
              tone: Tone.o,
              title: 'Scan #8',
              date: '5 Aug 2026 · 08:40',
              grade: 'A+',
              gradeColor: C.okD,
              onTap: () => context.push('/perfect'),
            ),
            ScanRow(
              icon: Icons.check_circle_rounded,
              tone: Tone.o,
              title: 'Scan #7',
              date: '29 July 2026 · 09:12',
              grade: 'A',
              gradeColor: C.okD,
              onTap: () => context.push('/scan-result'),
            ),
            ScanRow(
              icon: Icons.error_outline_rounded,
              tone: Tone.w,
              title: 'Scan #6',
              date: '22 July 2026 · 21:40',
              grade: 'B',
              gradeColor: C.goldD,
              onTap: () => context.push('/scan-result'),
            ),
          ],
        ),
      ],
    );
  }
}

/// One month's bar, growing up from the base on first show.
class _Bar extends StatelessWidget {
  const _Bar(this.grade, this.value, this.month, this.index, {this.hi = false});
  final String grade, month;
  final double value;
  final int index;
  final bool hi;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Text(
          grade,
          style: T.cap.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 66,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 1000 + index * 80),
              curve: Interval(
                index * .07,
                1,
                curve: const Cubic(.22, 1, .36, 1),
              ),
              builder: (_, k, _) => Container(
                height: 66 * value * k,
                decoration: BoxDecoration(
                  color: hi ? C.grad : C.barBg,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        Text(month, style: T.cap.copyWith(fontSize: 9.5)),
      ],
    );
  }
}
