# Islamic Companion App

## Project Overview
A comprehensive Islamic companion app built with Flutter for Google Play Store.
Lightweight, modern, and innovative design targeting Muslim users worldwide.

## Features
- **Prayer Times**: City-based prayer time calculation (71 cities worldwide), adhan notifications
- **Qibla Compass**: City-based Qibla direction finder
- **Dhikr Counter (Zikirmatik)**: Digital tasbih with haptic feedback, weekly chart, per-dhikr stats, loop mode, custom dhikr, streak display, sound toggle
- **Tasbih Set**: Post-prayer guided 33+33+33 (SubhanAllah, Alhamdulillah, Allahu Akbar)
- **Qaza Tracker**: Track missed prayers per type (Fajr-Witr), bulk add by years, progress bar
- **Zakat Calculator**: Gold/silver/cash/investment based, 11 currencies, Nisab calculation
- **Islamic Quiz**: 15 questions in 5 categories, score tracking, share results
- **Fasting Tracker**: Calendar view, Ramadan/voluntary/makeup tracking, sunnah fasting info
- **Hadith Collection**: 10 curated hadiths with bookmark & share
- **Short Surahs**: Arabic text, translation, audio recitation (Mishary Alafasy), bookmark & share
- **Daily Duas**: 8 categories with audio playback, bookmark & share
- **99 Names of Allah**: Searchable list with meanings
- **Sadaqah Button**: Watch ads (Google AdMob) as charity
- **Favorites**: Bookmark hadiths, surahs, duas - tabbed favorites screen
- **Daily Hadith Notification**: Scheduled with time picker
- **Hijri Calendar**: With Ramadan suhoor/iftar banner

## Supported Languages (20)
English, Türkçe, العربية, Русский, हिन्दी, Bahasa Indonesia, 中文, Deutsch, Nederlands, Français, Español, اردو, বাংলা, Bahasa Melayu, Português, فارسی, Kiswahili, 日本語, 한국어, Soomaali

## Tech Stack
- **Framework**: Flutter 3.x / Dart
- **State Management**: Provider
- **Ads**: Google Mobile Ads (AdMob)
- **Audio**: audioplayers
- **Notifications**: flutter_local_notifications + timezone
- **Sharing**: share_plus
- **Storage**: SharedPreferences
- **Architecture**: Feature-based with clean separation

## Build Commands
```bash
export PATH="/c/Users/Administrator/flutter/bin:$PATH"
export JAVA_HOME="/c/Users/Administrator/jdk-17.0.13+11"
export PATH="$JAVA_HOME/bin:$PATH"

flutter pub get          # Install dependencies
flutter analyze          # Check for errors
flutter build apk        # Build release APK
flutter build appbundle  # Build for Play Store
dart run flutter_launcher_icons  # Regenerate app icons
```

## Project Structure
```
lib/
├── main.dart              # App entry point
├── l10n/                  # Localization (11 languages)
├── models/                # Data models (hadith, surah, asma)
├── providers/             # State (app, prayer, dhikr, favorites, qaza, fasting)
├── screens/               # Feature screens (120 screens)
├── services/              # Adhan, notifications, sharing, hijri
├── utils/                 # Constants, helpers, theme
└── widgets/               # Reusable UI components
```

## Key Design Decisions
- City-based prayer times (27+ cities) instead of GPS - more reliable
- Offline-first: prayer times calculated locally, content bundled
- Dark/Light theme with Islamic green (#1B5E20) + gold (#D4AF37) accent
- AdMob test IDs in use - **replace with production IDs before release**
- Keystore: android/app/upload-keystore.jks (password: IslamicApp2026!)

## Play Store
- Version: 4.3.0+20
- Target SDK: 35, Min SDK: 21
- App Bundle: build/app/outputs/bundle/release/app-release.aab
- Store listings: store_listing/play_store.md (EN) + play_store_tr.md (TR)
- Privacy policy: store_listing/privacy_policy.html
