# Islamic Companion App

<div align="center">

**A beautiful, modern Islamic companion app for daily spiritual needs**

*Prayer Times | Qibla Compass | Dhikr Counter | Hadiths | Quran Surahs | Sadaqah*

</div>

---

## Features

### Prayer Times (Ezan)
Accurate prayer time calculations based on your location with beautiful visual indicators for each prayer.

### Qibla Compass
Find the direction of the Kaaba from anywhere in the world with an elegant compass interface.

### Dhikr Counter (Zikirmatik)
Digital tasbih with haptic feedback, multiple dhikr options, customizable targets (33, 99, 100, 500, 1000), and lifetime counter.

### Hadith Collection
Curated authentic hadiths from Sahih al-Bukhari, Sahih Muslim, and Jami at-Tirmidhi with translations in 10 languages.

### Short Surahs & Ayahs
Popular short surahs including Al-Fatiha, Ayatul Kursi, Al-Ikhlas, Al-Falaq, An-Nas, and more — with Arabic text, translations, and YouTube recitation links.

### Sadaqah Button
Watch an ad as an act of charity — half of the ad revenue is donated as Sadaqah on your behalf.

## Supported Languages

| Language | Code |
|----------|------|
| English | en |
| العربية (Arabic) | ar |
| Русский (Russian) | ru |
| हिन्दी (Hindi) | hi |
| Bahasa Indonesia | id |
| 中文 (Chinese) | zh |
| Deutsch (German) | de |
| Nederlands (Dutch) | nl |
| Français (French) | fr |
| Español (Spanish) | es |

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Android Studio / VS Code
- Android SDK (API 21+)

### Installation

```bash
git clone https://github.com/YOUR_USERNAME/islamic-companion-app.git
cd islamic-companion-app
flutter pub get
flutter run
```

### Build for Play Store

```bash
flutter build appbundle --release
```

## Configuration

### AdMob Setup
1. Create an AdMob account at https://admob.google.com
2. Create an app and get your App ID
3. Create a Rewarded Ad unit
4. Replace test IDs in:
   - `android/app/src/main/AndroidManifest.xml` (App ID)
   - `lib/utils/constants.dart` (Ad Unit IDs)

## Architecture

```
lib/
├── main.dart                    # App entry point
├── l10n/
│   └── app_localizations.dart   # 10-language localization system
├── models/
│   ├── hadith_model.dart        # Hadith data with 10-lang translations
│   └── surah_model.dart         # Surah data with Arabic + translations
├── providers/
│   ├── app_provider.dart        # App state (locale, theme)
│   ├── dhikr_provider.dart      # Dhikr counter state
│   └── prayer_provider.dart     # Prayer times calculation
├── screens/
│   ├── home_screen.dart         # Main dashboard
│   ├── language_selection_screen.dart
│   ├── prayer_times_screen.dart
│   ├── qibla_screen.dart
│   ├── dhikr_screen.dart
│   ├── hadith_screen.dart
│   ├── surah_screen.dart
│   ├── sadaqah_screen.dart
│   └── settings_screen.dart
└── utils/
    ├── constants.dart           # App constants & ad IDs
    └── theme.dart               # Light/Dark theme definitions
```

## License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

**بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ**

*Made with love for the Ummah*

</div>
