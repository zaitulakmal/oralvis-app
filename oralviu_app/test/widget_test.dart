// Opens every screen on a 390 × 844 phone and fails on any exception or
// layout overflow; then walks the main flows by tapping.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oralviu_app/main.dart';
import 'package:oralviu_app/router.dart';

Future<void> _open(
  WidgetTester t,
  String id, {
  Size size = const Size(390, 844),
}) async {
  t.view.physicalSize = size * 3;
  t.view.devicePixelRatio = 3;
  addTearDown(t.view.reset);
  await t.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      child: OralviuApp(key: UniqueKey(), initial: '/$id'),
    ),
  );
  await t.pump(const Duration(milliseconds: 600));
}

void main() {
  // Tests draw every glyph as a square unless the real font is loaded, which
  // makes text far wider than on a phone. Load the app's own font.
  setUpAll(() async {
    final loader = FontLoader('PlusJakartaSans');
    for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
      final bytes = File('assets/fonts/PlusJakartaSans-$w.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  });

  for (final id in screenIds) {
    testWidgets('screen $id renders cleanly', (t) async {
      await _open(t, id);
      expect(t.takeException(), isNull);
    });
    testWidgets('screen $id fits a small phone (360 × 640)', (t) async {
      await _open(t, id, size: const Size(360, 640));
      expect(t.takeException(), isNull);
    });
  }

  testWidgets(
    'scan flow: select → connect → tutorial → scanner → review → analysing → symptoms → report',
    (t) async {
      await _open(t, 'scan-select');
      Future<void> tap(Finder f) async {
        await t.tap(f.first);
        await t.pump();
        await t.pump(const Duration(milliseconds: 500));
      }

      await tap(find.text('Single Scan'));
      expect(find.text('Device connection'), findsOneWidget);
      await tap(find.text('Connect device'));
      expect(find.text('Start Scanning'), findsOneWidget);
      await tap(find.text('Start Scanning'));
      expect(find.text('Live Scanner'), findsOneWidget);
      await tap(find.byType(ColoredBox).last);
      expect(find.text('Review Photo'), findsOneWidget);
      await tap(find.text('Analyse with AI'));
      expect(find.text('Analysing your scan'), findsOneWidget);
      await tap(find.text('Analysing your scan'));
      expect(find.text('Symptom report'), findsOneWidget);
      await tap(find.text('Generate report'));
      expect(find.text('Download PDF'), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('Full Scan is greyed out and goes nowhere', (t) async {
    await _open(t, 'scan-select');
    await t.tap(find.text('Full Scan'), warnIfMissed: false);
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('Oral Scanning'), findsOneWidget);
    expect(find.text('Device connection'), findsNothing);
  });

  testWidgets(
    'City stays locked until a State is picked, then lists only its towns',
    (t) async {
      await _open(t, 'profile-setup');
      await t.tap(find.text('City · select a state first'));
      await t.pump(const Duration(milliseconds: 400));
      expect(find.text('Select city'), findsNothing);

      await t.ensureVisible(find.text('State'));
      await t.tap(find.text('State'));
      await t.pumpAndSettle();
      expect(find.text('Select state'), findsOneWidget);
      await t.tap(find.text('Selangor'));
      await t.pumpAndSettle();

      await t.tap(find.text('City'));
      await t.pumpAndSettle();
      expect(find.text('Kajang'), findsOneWidget);
      expect(find.text('Ipoh'), findsNothing);
      await t.tap(find.text('Kajang'));
      await t.pumpAndSettle();
      expect(find.text('Kajang'), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets(
    'Relationship offers Son / Daughter / Elderly and Elderly can be picked',
    (t) async {
      await _open(t, 'add-dependent');
      for (final r in ['Son', 'Daughter', 'Elderly']) {
        expect(find.text(r), findsWidgets);
      }
      expect(find.text('Spouse'), findsNothing);
      await t.ensureVisible(find.text('Elderly'));
      await t.tap(find.text('Elderly'));
      await t.pump(const Duration(milliseconds: 300));
      final elderly = t.widget<Text>(find.text('Elderly'));
      expect(elderly.style?.color, Colors.white);
    },
  );
}
