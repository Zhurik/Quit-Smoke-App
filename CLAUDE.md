# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

QuitSmoke is a Flutter mobile app (Android + iOS) that helps users quit smoking by tracking time smoke-free, money saved, cigarettes not smoked, and health milestones. Originally built for the developer's father.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app (requires connected device or emulator)
flutter run

# Build Android APK
flutter build apk

# Build iOS
flutter build ios

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze
```

## Architecture

The app has no state management library — all state is held in `StatefulWidget`s and persisted via `shared_preferences`.

**Entry flow:** `main.dart` → `SplashScreen` checks `shared_preferences` for `"startTime"` key → routes to `WelcomeScreen` (first run) or `HomeScreen` (returning user).

**Core model:** `lib/comps/cigaratte.dart` — `Cigaratte` class (note the typo, keep it) holds `startDate`, `dailyCigarattes`, and `pricePerCigaratte`. All calculations (money saved, cigarettes avoided, day percentage, upcoming health milestone) are derived live from these three values + `DateTime.now()`. No persistence inside the model itself.

**Shared preferences keys:**
- `"startTime"` — ISO 8601 string of quit date
- `"dailycigarattes"` — int
- `"pricePerCigaratte"` — double
- `"currency"` — currency symbol string
- `"transactionData"` — JSON array of wallet transactions

**Health milestones:** `lib/static/htimes.dart` defines a `List<Map>` of 14 timed health events (20 min → 10 years). The `Cigaratte.upcomingEvent` getter walks this list to find the next upcoming milestone. Milestone descriptions live in `lib/static/lang.dart` under `progressDescription`.

**Localization:** `lib/static/lang.dart` holds all UI strings in a single `Map langs` with keys `"en"`, `"tr"`, `"es"`. Language is detected at runtime via `Platform.localeName` in `lib/comps/getlang.dart` — no Flutter l10n/intl codegen is used. To add a language, add a new key to `langs` covering all the same nested keys as `"en"`.

**Screens:**
- `HomeScreen` — main dashboard; rebuilds every second via `Timer.periodic` to update live counters
- `WelcomeScreen` — onboarding; saves initial prefs and navigates to `HomeScreen`
- `SettingsScreen` — edits the same prefs; pops back to `HomeScreen` which calls `loadData()` again
- `WalletScreen` — tracks spending of saved money; transactions stored as JSON in prefs
- `ProgressScreen` — health milestone timeline
- `GuideScreen` / `GuideViewScreen` — in-app quit-smoking guide; content is embedded in `lang.dart`
- `ReasonScreen` — user's personal list of reasons to quit

**Visual components in `lib/comps/`:**
- `progress_painter.dart` — custom `CustomPainter` for the circular progress arc on `HomeScreen`
- `particleSpawner.dart` / `particle.dart` / `particlePainer.dart` — particle animation system behind the progress circle
- `snappable.dart` — snap/disintegration animation widget

**Sizing:** `lib/size_config.dart` provides `getProportionateScreenWidth` / `getProportionateScreenHeight` helpers based on a 375×812 reference design. Call `SizeConfig().init(context)` before using these helpers in a build method.

**Theme:** `lib/theme.dart` defines `themeData` and `darkThemeData`. Color constants are in `lib/constants.dart`. The app is currently locked to light mode (`ThemeMode.light` in `main.dart`).

**Notifications:** `lib/notification_manager.dart` wraps `flutter_local_notifications`. Initialized at app start; used in settings to schedule reminders.
