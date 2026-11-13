import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/colors.dart';
import 'theme/type.dart';

void main() {
  runApp(const ProviderScope(child: OralviuApp()));
}

class OralviuApp extends StatefulWidget {
  const OralviuApp({super.key, this.initial = '/splash'});
  final String initial;

  @override
  State<OralviuApp> createState() => _OralviuAppState();
}

class _OralviuAppState extends State<OralviuApp> {
  late final _router = buildRouter(initial: widget.initial);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ORALVIU',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        fontFamily: kFont,
        scaffoldBackgroundColor: C.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: C.blue,
          primary: C.blue,
          surface: C.bg,
        ),
        splashFactory: NoSplash.splashFactory,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: C.blue,
          selectionColor: C.blueL,
          selectionHandleColor: C.blue,
        ),
      ),
      // On a wide screen (web on a desktop) the app keeps phone width,
      // centred, as the prototype did.
      builder: (context, child) {
        final w = MediaQuery.sizeOf(context).width;
        if (w <= 600) return child!;
        return ColoredBox(
          color: const Color(0xFFDDE7F0),
          child: Center(
            child: Container(
              width: 430,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x2E132B44),
                    blurRadius: 40,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(size: Size(430, MediaQuery.sizeOf(context).height)),
                child: child!,
              ),
            ),
          ),
        );
      },
    );
  }
}
