# Islamic Companion App

## Project Overview
A comprehensive Islamic companion app built with Flutter for Google Play Store.
Lightweight, modern, and innovative design targeting Muslim users worldwide.

## Features
- **Prayer Times (Ezan)**: Location-based prayer time calculation with adhan notifications
- **Qibla Compass**: Sensor-based Qibla direction finder
- **Dhikr Counter (Zikirmatik)**: Digital tasbih with haptic feedback and animations
- **Hadith Collection**: Curated hadiths from authentic sources
- **Short Surahs**: Popular short surahs with Arabic text, transliteration, translation, and YouTube recitation links
- **Sadaqah Button**: Watch ads (Google AdMob) as charity - revenue shared as sadaqah

## Supported Languages (10)
English, Arabic (العربية), Russian (Русский), Hindi (हिन्दी), Indonesian (Bahasa Indonesia), Chinese (中文), German (Deutsch), Dutch (Nederlands), French (Français), Spanish (Español)

## Tech Stack
- **Framework**: Flutter 3.x / Dart
- **State Management**: Provider
- **Ads**: Google Mobile Ads (AdMob)
- **Location**: Geolocator + Geocoding
- **Compass**: Flutter Compass
- **Storage**: SharedPreferences
- **Architecture**: Feature-based with clean separation

## Build Commands
```bash
flutter pub get          # Install dependencies
flutter run              # Run in debug mode
flutter build apk        # Build release APK
flutter build appbundle  # Build for Play Store
flutter test             # Run tests
```

## Project Structure
```
lib/
├── main.dart              # App entry point
├── l10n/                  # Localization files (10 languages)
├── models/                # Data models
├── providers/             # State management
├── screens/               # Feature screens
├── services/              # Business logic & APIs
├── utils/                 # Constants, helpers, theme
└── widgets/               # Reusable UI components
```

## Key Design Decisions
- Auto-detect language from device locale, with manual override on first launch
- Minimal APK size (<15MB) by using vector graphics and efficient assets
- Offline-first: prayer times calculated locally, content bundled
- Dark/Light theme support with Islamic green accent
- AdMob rewarded ads for sadaqah feature (user watches ad = charity donation)

## AdMob Integration
- Replace test ad unit IDs with production IDs before release
- Rewarded ads for sadaqah feature
- Banner ads on secondary screens (optional)

## Play Store Notes
- Target SDK: 34
- Min SDK: 21 (Android 5.0+)
- Category: Lifestyle
- Content Rating: Everyone
