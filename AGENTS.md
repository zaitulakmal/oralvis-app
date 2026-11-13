# ORALVIU — project contract

`CLAUDE.md` is a symlink to this file. Read it before touching anything.

## What this repo holds
- `index.html` — the clickable HTML prototype (35 screens), served by GitHub
  Pages at https://zaitulakmal.github.io/oralvis-app/ . It is the design
  reference for the Flutter app.
- `oralviu_app/` — the Flutter app, a port of every prototype screen.
- `app/` — the Flutter web build, served at /app/. Generated; never edit by
  hand. Rebuild it with the command under "Flutter app — how to build".
- `index-v7.html` — an old prototype version, kept as an archive. Do not edit.
- `tools/` — local Playwright checks for the prototype (gitignored).

## Brand
- The product is **ORALVIU** (the old spelling ORAVIU is retired).
- Logo: the client-supplied file. Colour version on light grounds, white
  version (tagline knocked out of the pill) on blue grounds.
- Font: Plus Jakarta Sans.

## Flutter app — decisions made by Zaitul (11 Nov 2026)
| Topic | Decision |
|---|---|
| Scope | UI for all prototype screens and flows, with sample data. No login, database or real scanner yet. |
| Location | `oralviu_app/` in this repo; the HTML prototype stays where it is |
| Platforms | Android, iOS and Web |
| App ID | `com.oralviu.app` (Android applicationId and iOS bundle ID) |
| Navigation and state | go_router + Riverpod |
| Illustrations | flutter_svg, reusing the prototype's SVGs |
| Font | Plus Jakarta Sans TTF files bundled in the app (no google_fonts package) |
| Web hosting | GitHub Pages subpath `/app/` → https://zaitulakmal.github.io/oralvis-app/app/ ; the prototype keeps the root |

## Flutter app — how to build
Run from `oralviu_app/`:
- Checks: `flutter analyze` and `flutter test` (opens all 35 screens at two
  phone sizes, plus the scan, State/City and relationship flows).
- Android: `flutter build apk --release`
- iOS: `flutter build ios --release` (signing needs an Apple developer team)
- Web for GitHub Pages:
  `flutter build web --release --base-href /oralvis-app/app/ --pwa-strategy=none`
  then replace the repo's `app/` folder with `oralviu_app/build/web/`.

Not wired yet (no backend): Download PDF, Share result, Book, Buy now,
Add to cart, search, chat sending. Text fields take input but nothing is saved.

## Product decisions already in the prototype
- Live Scanner: everything below the header is plain black, because it is not
  yet known what the scanner backend can show. Tapping it stands in for the
  shutter.
- Grade faces are the drawn line faces (not emoji images).
- Dependents relationship options: Son, Daughter, Elderly.
- State is picked before City; City lists only that state's towns.

## Working rules
- Commit or push only when Zaitul says so in this conversation; the live link
  is public.
- Never claim something works without running it.

## Open questions
- Backend (auth, data, scanner connection) — not chosen yet.
