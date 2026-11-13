import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../theme/colors.dart';
import '../theme/type.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/brand.dart';
import '../widgets/pressable.dart';
import '../widgets/ui.dart';

// ──────────────────────────────────────────────────────────────── profile ──

class ProfileViewerScreen extends StatelessWidget {
  const ProfileViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      nav: const BottomNav(active: NavTab.profile),
      children: [
        Pad(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile', style: T.h2),
              CBtn(
                icon: Icons.settings_rounded,
                label: 'About',
                onTap: () => context.push('/about'),
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 7,
          children: [
            AppCard(
              color: C.grad,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                spacing: 2,
                children: [
                  Pressable(
                    onTap: () => context.push('/camera-profile'),
                    label: 'Change profile photo',
                    child: Sq(
                      size: 46,
                      circle: true,
                      color: Colors.white.withValues(alpha: .22),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Alex Johnson',
                    style: TextStyle(
                      fontFamily: kFont,
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '12 March 1998 · Male',
                    style: TextStyle(
                      fontFamily: kFont,
                      color: Colors.white.withValues(alpha: .82),
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
                  icon: Icons.mail_rounded,
                  label: 'Email',
                  value: 'demo@oralviu.com',
                ),
                InfoRow(
                  icon: Icons.work_rounded,
                  label: 'Profession',
                  value: 'Engineer',
                ),
                InfoRow(
                  icon: Icons.home_rounded,
                  label: 'Address',
                  value: 'Kuala Lumpur, WP',
                ),
                InfoRow(
                  icon: Icons.monitor_heart_rounded,
                  label: 'Medical condition',
                  value: 'Diabetes',
                  tone: Tone.r,
                ),
              ],
            ),
            ListCard(
              rows: [
                LinkRow(
                  icon: Icons.family_restroom_rounded,
                  label: 'Dependents',
                  onTap: () => context.push('/dependents'),
                ),
                LinkRow(
                  icon: Icons.forum_rounded,
                  label: 'Chat with assistant',
                  onTap: () => context.push('/chat'),
                ),
                const LinkRow(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  trailing: AppChip('On', tone: Tone.o),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────── profile photo ──

class CameraProfileScreen extends StatelessWidget {
  const CameraProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget side(IconData icon, String label) => Pressable(
      onTap: () => goBack(context),
      child: Column(
        spacing: 5,
        children: [
          Sq(
            size: 46,
            circle: true,
            color: Colors.white.withValues(alpha: .1),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white.withValues(alpha: .65),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: kFont,
              color: Colors.white.withValues(alpha: .4),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    return AppScreen(
      background: C.cameraSoft,
      lightStatusIcons: true,
      bottomColor: C.camera,
      bottomPadding: const EdgeInsets.fromLTRB(28, 16, 28, 26),
      bottom: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          side(Icons.photo_library_rounded, 'Gallery'),
          Pressable(
            onTap: () => goBack(context),
            label: 'Take photo',
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0x426EC0FF), spreadRadius: 5),
                ],
              ),
              child: const Icon(
                Icons.photo_camera_rounded,
                size: 30,
                color: C.blue,
              ),
            ),
          ),
          side(Icons.flip_camera_ios_rounded, 'Flip'),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackRow(dark: true),
              const Text(
                'Profile Photo',
                style: TextStyle(
                  fontFamily: kFont,
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CBtn(
                icon: Icons.bolt_rounded,
                background: Colors.white.withValues(alpha: .12),
                iconColor: Colors.white,
                shadow: false,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: C.camera,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                DashedRing(
                  color: const Color(0x806EC0FF),
                  width: 2,
                  child: Container(
                    width: 184,
                    height: 184,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x0F6EC0FF),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 60,
                      color: Colors.white.withValues(alpha: .2),
                    ),
                  ),
                ),
                Text(
                  'Position your face in the circle',
                  style: TextStyle(
                    fontFamily: kFont,
                    color: Colors.white.withValues(alpha: .45),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
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

// ──────────────────────────────────────────────────────────────── about ──

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget step(IconData icon, String label, Tone tone) => Expanded(
      child: Column(
        spacing: 5,
        children: [
          tile(icon, tone),
          Text(label, style: T.cap.copyWith(fontSize: 8.5)),
        ],
      ),
    );
    const arrow = Icon(Icons.arrow_forward_rounded, size: 14, color: C.ink3);
    Widget contact(
      IconData icon,
      Tone tone,
      String text, {
      VoidCallback? onTap,
    }) {
      final row = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          spacing: 11,
          children: [
            tile(icon, tone, iconSize: 16),
            Expanded(
              child: Text(
                text,
                style: T.pxs.copyWith(
                  color: C.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
      return onTap == null
          ? row
          : Pressable(onTap: onTap, scale: .985, child: row);
    }

    return AppScreen(
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackRow(label: 'Profile'),
              const SizedBox(height: 9),
              Text('About us', style: T.h1),
            ],
          ),
        ),
        ScrollBody(
          gap: 9,
          children: [
            AppCard(
              color: C.grad,
              shadow: Shadows.shb,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/tooth_mascot.svg',
                    width: 54,
                    height: 59,
                  ),
                  const SizedBox(height: 8),
                  const BrandLogo(height: 42, white: true),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0 · Made in Malaysia',
                    style: TextStyle(
                      fontFamily: kFont,
                      color: Colors.white.withValues(alpha: .72),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Making professional-grade oral scanning accessible to everyone, using AI.',
                    textAlign: TextAlign.center,
                    style: T.pxs.copyWith(
                      color: Colors.white.withValues(alpha: .85),
                    ),
                  ),
                ],
              ),
            ),
            AppCard(
              onTap: () => context.push('/guide'),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      const Icon(
                        Icons.settings_suggest_rounded,
                        size: 16,
                        color: C.blueD,
                      ),
                      Text('How it works', style: T.h4),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      step(Icons.sensors_rounded, 'Connect', Tone.b),
                      arrow,
                      step(Icons.photo_camera_rounded, 'Scan', Tone.b),
                      arrow,
                      step(Icons.description_rounded, 'Report', Tone.o),
                    ],
                  ),
                ],
              ),
            ),
            ListCard(
              indent: 14,
              rows: [
                contact(Icons.mail_rounded, Tone.b, 'support@oralviu.com'),
                contact(
                  Icons.language_rounded,
                  Tone.o,
                  'www.oralviu.com',
                  onTap: () => context.push('/store'),
                ),
                contact(Icons.phone_rounded, Tone.w, '+60 3-XXXX XXXX'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
