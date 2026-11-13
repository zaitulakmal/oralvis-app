import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/account.dart';
import 'screens/home.dart';
import 'screens/more.dart';
import 'screens/onboarding.dart';
import 'screens/profile.dart';
import 'screens/scan.dart';

/// One route per prototype screen, named after its `data-screen` id, so a
/// link like /#/scan-result opens the same screen as #scr-scan-result did.
final _screens = <String, Widget Function()>{
  'splash': () => const SplashScreen(),
  'onboarding': () => const OnboardingScreen(),
  'sign-in': () => const SignInScreen(),
  'password-reset': () => const PasswordResetScreen(),
  'sign-up': () => const SignUpScreen(),
  'profile-setup': () => const ProfileSetupScreen(),
  'medical-history': () => const MedicalHistoryScreen(),
  'conditions': () => const ConditionsScreen(),
  'profile-viewer': () => const ProfileViewerScreen(),
  'camera-profile': () => const CameraProfileScreen(),
  'logout': () => const LogoutScreen(),
  'dashboard': () => const DashboardScreen(),
  'progress': () => const ProgressScreen(),
  'scan-select': () => const ScanSelectScreen(),
  'device-connect': () => const DeviceConnectScreen(),
  'device-tutorial': () => const DeviceTutorialScreen(),
  'live-scanner': () => const LiveScannerScreen(),
  'image-capture': () => const ImageCaptureScreen(),
  'ai-processing': () => const AiProcessingScreen(),
  'report-form': () => const ReportFormScreen(),
  'scan-result': () => const ScanResultScreen(),
  'perfect': () => const PerfectScreen(),
  'guide': () => const GuideScreen(),
  'states': () => const StatesScreen(),
  'near-clinic': () => const NearClinicScreen(),
  'disease-library': () => const DiseaseLibraryScreen(),
  'disease-detail': () => const DiseaseDetailScreen(),
  'about': () => const AboutScreen(),
  'store': () => const StoreScreen(),
  'chat': () => const ChatScreen(),
  'dependents': () => const DependentsScreen(),
  'dependents-added': () => const DependentsScreen(added: true),
  'add-dependent': () => const AddDependentScreen(),
  'dependent-medical': () => const MedicalHistoryScreen(dependent: true),
  'dependent-profile': () => const DependentProfileScreen(),
};

List<String> get screenIds => _screens.keys.toList();

GoRouter buildRouter({String initial = '/splash'}) => GoRouter(
  initialLocation: initial,
  routes: [
    for (final e in _screens.entries)
      GoRoute(
        path: '/${e.key}',
        name: e.key,
        pageBuilder: (context, state) => _page(state, e.value()),
      ),
  ],
  errorBuilder: (_, _) => const SplashScreen(),
);

/// Screens slide in from the right, like a native push.
Page<void> _page(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, anim, secondary, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
