# Islamic Companion App

<div align="center">

**Your all-in-one Islamic companion for daily spiritual needs**

*Prayer Times | Qibla | Dhikr | Quran Recitation | Hadiths | Duas | 99 Names | Sadaqah*

[![Flutter CI/CD](https://github.com/safvan96/islamic-companion-app/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/safvan96/islamic-companion-app/actions/workflows/flutter-ci.yml)
[![Web Demo](https://img.shields.io/badge/Web-Demo-1B5E20)](https://safvan96.github.io/islamic-companion-app/)

**11 Languages | 27 Cities | Dark & Light Theme | Offline Support**

[Web Demo](https://safvan96.github.io/islamic-companion-app/) | [Privacy Policy](https://safvan96.github.io/islamic-companion-app/privacy.html) | [Download APK](https://github.com/safvan96/islamic-companion-app/releases)

</div>

---

## Features

### Prayer Times
- Accurate calculation for 27+ cities worldwide (10 Turkish cities)
- Next prayer countdown timer
- Adhan notification alerts
- City selection with persistent save

### Qibla Compass
- Direction based on selected city coordinates
- Visual compass with N/E/S/W markers

### Dhikr Counter (Zikirmatik)
- 8 different dhikr (SubhanAllah, Alhamdulillah, Allahu Akbar, etc.)
- Haptic feedback + click sound
- Customizable targets (33, 99, 100, 500, 1000)
- Weekly chart + per-dhikr lifetime stats
- Share your stats

### Hadith Collection (20 Hadiths)
- Authentic hadiths from Bukhari, Muslim, Tirmidhi
- "Today's Hadith" daily highlight
- Auto-scroll to today's hadith
- Bookmark & share

### Quran Surahs (12 Surahs)
- Al-Fatiha, Ya-Sin, Al-Mulk, Ar-Rahman, Ayatul Kursi, and more
- Audio recitation by Mishary Alafasy
- Arabic text + translation in 11 languages
- Bookmark & share

### Daily Duas (8 Categories)
- Morning, Evening, Sleep, Food, Travel, Mosque, Protection, Forgiveness
- Audio playback
- Bookmark & share

### 99 Names of Allah (Esmaul Husna)
- Searchable list with Arabic, transliteration, meaning

### Sadaqah
- Watch ad = charity donation (AdMob rewarded ads)

### Favorites
- Bookmark hadiths, surahs, duas
- Tabbed favorites screen

### Notifications
- Adhan alerts at prayer times
- Daily hadith notification with custom time picker

### Additional
- Daily hadith card on home screen
- Hijri calendar with Ramadan banner
- Rate Us & Share App buttons
- Custom app icon (Islamic green + gold crescent)
- Onboarding: Language -> City -> Home

## Supported Languages (11)

| Flag | Language | Code |
|------|----------|------|
| GB | English | en |
| TR | Turkce | tr |
| SA | Arabic | ar |
| RU | Russian | ru |
| IN | Hindi | hi |
| ID | Indonesian | id |
| CN | Chinese | zh |
| DE | German | de |
| NL | Dutch | nl |
| FR | French | fr |
| ES | Spanish | es |

## Supported Cities (27)

**Turkey:** Istanbul, Ankara, Konya, Izmir, Bursa, Antalya, Adana, Gaziantep, Kayseri, Trabzon
**Middle East:** Mecca, Medina, Cairo, Dubai, Riyadh
**Europe:** London, Berlin, Paris, Amsterdam, Moscow
**Asia:** Jakarta, New Delhi, Beijing, Kuala Lumpur
**Americas:** New York, Madrid

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- JDK 17
- Android SDK (API 21+)

### Installation

```bash
git clone https://github.com/safvan96/islamic-companion-app.git
cd islamic-companion-app
flutter pub get
flutter run
```

### Build

```bash
# APK
flutter build apk --release

# Play Store (App Bundle)
flutter build appbundle --release

# Web
flutter build web --release --base-href "/islamic-companion-app/"

# Run tests
flutter test

# Regenerate app icon
dart run flutter_launcher_icons
```

## Architecture

```
lib/
├── main.dart                    # App entry + providers
├── l10n/
│   └── app_localizations.dart   # 11-language localization
├── models/
│   ├── hadith_model.dart        # 20 hadiths with translations
│   ├── surah_model.dart         # 12 surahs with Arabic + translations
│   └── asma_al_husna_model.dart # 99 Names of Allah
├── providers/
│   ├��─ app_provider.dart        # Locale, theme
│   ├── prayer_provider.dart     # Prayer times, city
│   ├── dhikr_provider.dart      # Dhikr counter + stats
│   └── favorites_provider.dart  # Bookmarks
├── screens/                     # 14 screens
├── services/
│   ├── adhan_service.dart       # Adhan notifications
│   ├── notification_service.dart # Daily hadith notifications
│   ├── share_service.dart       # Share hadiths/surahs/duas
│   └── hijri_calendar.dart      # Hijri date calculation
└── utils/
    ├── constants.dart           # Kaaba coords, AdMob IDs, languages
    └── theme.dart               # Light/Dark Material 3 themes
```

## AdMob Setup

Replace test IDs before publishing:
- `android/app/src/main/AndroidManifest.xml` → App ID
- `lib/utils/constants.dart` → Ad Unit IDs

## License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

**بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ**

*Made with love for the Ummah*

</div>
