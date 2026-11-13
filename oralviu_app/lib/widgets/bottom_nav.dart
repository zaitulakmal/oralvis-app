import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/colors.dart';
import '../theme/type.dart';
import 'pressable.dart';

/// The tab bar from the live app: Dashboard · My Reports · Learn · Profile ·
/// Logout. Only the current tab shows its label.
enum NavTab { dashboard, reports, learn, profile, logout }

const _tabs = [
  (NavTab.dashboard, Icons.home_rounded, 'Dashboard', '/dashboard'),
  (NavTab.reports, Icons.description_rounded, 'My Reports', '/progress'),
  (NavTab.learn, Icons.menu_book_rounded, 'Learn', '/disease-library'),
  (NavTab.profile, Icons.person_rounded, 'Profile', '/profile-viewer'),
  (NavTab.logout, Icons.logout_rounded, 'Logout', '/logout'),
];

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.active});
  final NavTab active;

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.viewPaddingOf(context).bottom;
    return Container(
      height: 64 + inset,
      padding: EdgeInsets.only(left: 8, right: 8, bottom: inset),
      decoration: const BoxDecoration(
        color: C.card,
        border: Border(top: BorderSide(color: C.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final (tab, icon, label, path) in _tabs)
            Pressable(
              label: label,
              onTap: tab == active ? null : () => context.go(path),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Icon(icon, size: 23, color: tab == active ? C.ink : C.ink3),
                    if (tab == active)
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: kFont,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: C.ink,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
