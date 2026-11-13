# ORALVIU app (Flutter)

Flutter port of the ORALVIU prototype (`../index.html`): all 35 screens and
their flows, with sample data. See `../AGENTS.md` for the decisions behind it
and the build commands.

- `lib/theme/` — colours and text styles, one for one with the prototype CSS
- `lib/widgets/` — shared pieces (buttons, cards, chips, fields, tab bar, logo, grade faces)
- `lib/screens/` — the screens, grouped by area
- `lib/router.dart` — one route per prototype screen id (`/#/dashboard`, …)
- `lib/state/forms.dart` — form state (Riverpod)
