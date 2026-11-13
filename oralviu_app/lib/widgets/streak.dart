import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/type.dart';
import 'ui.dart';

/// "5-day streak" card: a week of days, done / today / to come.
class StreakCard extends StatelessWidget {
  const StreakCard({super.key, this.done = 5});
  final int done;

  static const _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                size: 17,
                color: C.warnD,
              ),
              const SizedBox(width: 6),
              Expanded(child: Text('$done-day streak', style: T.h4)),
              const AppChip('Goal: 7 days', tone: Tone.w),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [for (var i = 0; i < 7; i++) _day(i)],
          ),
        ],
      ),
    );
  }

  Widget _day(int i) {
    final isDone = i < done, today = i == done;
    return Column(
      spacing: 5,
      children: [
        DashedRing(
          color: today ? C.ink2 : Colors.transparent,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? C.grad : null,
              border: isDone || today
                  ? null
                  : Border.all(color: C.brd2, width: 1.5),
            ),
            child: isDone
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : today
                ? const Icon(Icons.schedule_rounded, size: 16, color: C.ink)
                : null,
          ),
        ),
        Text(
          _days[i],
          style: T.cap.copyWith(fontSize: 10, color: today ? C.blueD : C.ink3),
        ),
      ],
    );
  }
}
