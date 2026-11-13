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
import '../widgets/pressable.dart';
import '../widgets/ui.dart';

/// A text link inside a line ("Sign up", "Terms"…).
Widget _link(String text, VoidCallback onTap, {double size = 12.5}) =>
    Pressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        child: Text(
          text,
          style: T.pxs.copyWith(
            fontSize: size,
            color: C.blueD,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

/// "Clear" in the top-right corner.
Widget _clearBar({String? left}) => Pad(
  padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(left ?? '', style: T.cap.copyWith(fontWeight: FontWeight.w700)),
      Text(
        'Clear',
        style: T.cap.copyWith(color: C.blueD, fontWeight: FontWeight.w700),
      ),
    ],
  ),
);

// ──────────────────────────────────────────────────────────────── sign in ──

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _keep = true;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        _clearBar(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: box.maxHeight - 28),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 14,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: BrandLogo(height: 46),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text('Welcome back', style: T.h1),
                          Text('Sign in to your account.', style: T.p),
                        ],
                      ),
                      const AppInput(
                        icon: Icons.mail_rounded,
                        hint: 'Email',
                        initial: 'demo@oralviu.com',
                        keyboard: TextInputType.emailAddress,
                      ),
                      const AppInput(
                        icon: Icons.lock_rounded,
                        hint: 'Password',
                        password: true,
                      ),
                      Pressable(
                        scale: .99,
                        onTap: () => setState(() => _keep = !_keep),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Keep me signed in',
                                style: T.pxs.copyWith(color: C.ink),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _keep ? C.blue : null,
                                borderRadius: BorderRadius.circular(7),
                                border: _keep
                                    ? null
                                    : Border.all(color: C.brd2, width: 1.5),
                              ),
                              child: _keep
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 17,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      Btn('Sign In', onTap: () => context.go('/dashboard')),
                      Center(
                        child: _link(
                          'Forgot password?',
                          () => context.push('/password-reset'),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don’t have an account? ', style: T.pxs),
                          _link('Sign up', () => context.push('/sign-up')),
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

// ───────────────────────────────────────────────────────── password reset ──

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        const Pad(
          child: Align(
            alignment: Alignment.centerLeft,
            child: BackRow(label: 'Back'),
          ),
        ),
        ScrollBody(
          gap: 14,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: BrandLogo(height: 46),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text('Reset password', style: T.h1),
                Text(
                  "Enter your email and we'll send you a reset link within a minute.",
                  style: T.p,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 7,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text('Email', style: T.cap),
                ),
                const AppInput(
                  icon: Icons.mail_rounded,
                  hint: 'name@email.com',
                  keyboard: TextInputType.emailAddress,
                ),
              ],
            ),
            Btn('Send reset link', onTap: () => context.go('/sign-in')),
            const NoteCard(
              icon: Icons.info_rounded,
              iconSize: 19,
              shadow: false,
              padding: EdgeInsets.all(15),
              text: [
                TextSpan(text: "Can't find the email? Check your "),
                TextSpan(
                  text: 'Spam',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' folder, or resend after 60 seconds.'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────── sign up ──

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      children: [
        _clearBar(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: box.maxHeight - 28),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 14,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: BrandLogo(height: 46),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text('Create account', style: T.h1),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Join '),
                                brandSpan(14),
                                const TextSpan(text: ' today.'),
                              ],
                            ),
                            style: T.p,
                          ),
                        ],
                      ),
                      const AppInput(
                        icon: Icons.mail_rounded,
                        hint: 'Email',
                        keyboard: TextInputType.emailAddress,
                      ),
                      const AppInput(
                        icon: Icons.lock_rounded,
                        hint: 'Password',
                        password: true,
                        showToggle: false,
                      ),
                      const AppInput(
                        icon: Icons.lock_reset_rounded,
                        hint: 'Confirm password',
                        password: true,
                        showToggle: false,
                      ),
                      Btn(
                        'Create account',
                        onTap: () => context.push('/profile-setup'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('By signing up you accept our ', style: T.pxs),
                          _link('Terms', () => context.push('/conditions')),
                          Text('.', style: T.pxs),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ', style: T.pxs),
                          _link('Sign in', () => context.go('/sign-in')),
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

// ────────────────────────────────────────────────────────── profile setup ──

class ProfileSetupScreen extends ConsumerWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(profileSetupProvider);
    final n = ref.read(profileSetupProvider.notifier);
    return AppScreen(
      bottom: Btn('Next', onTap: () => context.push('/medical-history')),
      children: [
        _clearBar(left: 'Self'),
        Pad(
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set up profile', style: T.h1.copyWith(fontSize: 26)),
              const SizedBox(height: 2),
              Text('Personalise your account now.', style: T.p),
            ],
          ),
        ),
        ScrollBody(
          gap: 9,
          children: [
            PhotoRow(onTap: () => context.push('/camera-profile')),
            const AppInput(
              icon: Icons.badge_rounded,
              hint: 'Nick name',
              height: 48,
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
            const AppInput(
              icon: Icons.work_rounded,
              hint: 'Profession',
              height: 48,
            ),
            const AppInput(
              icon: Icons.markunread_mailbox_rounded,
              hint: 'Postcode',
              height: 48,
              keyboard: TextInputType.number,
            ),
            DropField(
              icon: Icons.map_rounded,
              title: 'State',
              options: cities.keys.toList(),
              value: f.state,
              onChanged: n.pickState,
            ),
            DropField(
              icon: Icons.location_city_rounded,
              title: 'City',
              placeholder: f.state == null
                  ? 'City · select a state first'
                  : 'City',
              options: f.state == null ? null : cities[f.state],
              value: f.city,
              onChanged: n.city,
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────── medical history (yours) ──

class MedicalHistoryScreen extends ConsumerWidget {
  const MedicalHistoryScreen({super.key, this.dependent = false});

  /// The dependent's version (Danish Haziq) saves to Dependents.
  final bool dependent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = dependent
        ? dependentConditionsProvider
        : myConditionsProvider;
    final ticked = ref.watch(provider);
    return AppScreen(
      bottom: Btn(
        dependent ? 'Save dependent' : 'Save profile',
        onTap: () => dependent
            ? context.push('/dependents-added')
            : context.go('/dashboard'),
      ),
      children: [
        Pad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackRow(label: 'Medical History'),
              const SizedBox(height: 10),
              Text(
                dependent
                    ? 'Danish Haziq’s own record. It stays separate from yours.'
                    : 'Help us understand your health. Some conditions change how we read a scan.',
                style: T.p,
              ),
            ],
          ),
        ),
        ScrollBody(
          gap: 10,
          children: [
            const Lab('Select all that apply'),
            for (final c in medicalConditions)
              CheckRow(
                label: c,
                on: ticked.contains(c),
                onTap: () => ref.read(provider.notifier).toggle(c),
              ),
            const AppInput(
              hint: 'Please describe…',
              height: 64,
              multiline: true,
              plain: true,
            ),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────── conditions of use ──

class ConditionsScreen extends StatelessWidget {
  const ConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget section(String title, List<InlineSpan> body) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(title, style: T.h4),
        Text.rich(TextSpan(children: body), style: T.pxs),
      ],
    );
    return AppScreen(
      bottom: Btn(
        'I understand',
        onTap: () => context.canPop() ? context.pop() : context.go('/sign-up'),
      ),
      children: [
        const Pad(
          child: Align(
            alignment: Alignment.centerLeft,
            child: BackRow(label: 'Conditions of Use'),
          ),
        ),
        ScrollBody(
          gap: 7,
          children: [
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  const Icon(Icons.warning_rounded, size: 18, color: C.warnD),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.w700),
                            children: [
                              brandSpan(12.5),
                              const TextSpan(text: ' is not a diagnosis.'),
                            ],
                          ),
                          const TextSpan(
                            text:
                                ' Results are indicative only and must not replace examination by a qualified dental professional.',
                          ),
                        ],
                      ),
                      style: T.pxs.copyWith(color: C.warnD),
                    ),
                  ),
                ],
              ),
            ),
            section('1 · Intended use', [
              brandSpan(12.5),
              const TextSpan(
                text:
                    ' captures intraoral images and applies an AI model to flag visible signs such as calculus, stain and early decay.',
              ),
            ]),
            section('2 · Limitations', const [
              TextSpan(
                text:
                    'The model reads only what the camera can see. It cannot assess anything below the gum line, between contact points, or inside the tooth. A clear result does not rule out disease.',
              ),
            ]),
            section('3 · Your data', const [
              TextSpan(
                text:
                    'Scans are stored against your account so you can track change over time. You may delete any scan from Profile.',
              ),
            ]),
            section('4 · Seeking care', [
              const TextSpan(
                text:
                    'If you have pain, bleeding, swelling or a visible change that concerns you, contact a dentist regardless of what ',
              ),
              brandSpan(12.5),
              const TextSpan(text: ' reports.'),
            ]),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────── logout ──

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      nav: const BottomNav(active: NavTab.logout),
      children: [
        const Pad(
          child: Align(
            alignment: Alignment.centerLeft,
            child: BackRow(label: 'Back'),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.sizeOf(context).height - 260,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  const BrandLogo(height: 50),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12,
                      children: [
                        Center(
                          child: tile(
                            Icons.logout_rounded,
                            Tone.r,
                            size: 54,
                            iconSize: 26,
                          ),
                        ),
                        Column(
                          spacing: 5,
                          children: [
                            Text('Log Out', style: T.h2),
                            Text(
                              'Are you sure you want to sign out?',
                              style: T.p,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Btn('Logout', onTap: () => context.go('/splash')),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text:
                                    'Signing out means you will need to sign in again next time you open ',
                              ),
                              brandSpan(12.5),
                              const TextSpan(text: '.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: T.pxs,
                        ),
                      ],
                    ),
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
