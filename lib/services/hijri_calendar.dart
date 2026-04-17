/// Hijri (Islamic) calendar converter.
/// Uses the Umm al-Qura algorithm for accurate date conversion.
class HijriCalendar {
  final int year;
  final int month;
  final int day;

  HijriCalendar({required this.year, required this.month, required this.day});

  /// Convert Gregorian date to Hijri date
  factory HijriCalendar.fromGregorian(DateTime date) {
    // Julian Day Number calculation
    final y = date.year;
    final m = date.month;
    final d = date.day;

    int jd;
    if (m <= 2) {
      jd = ((365.25 * (y - 1)).floor()) +
          ((30.6001 * (m + 13)).floor()) +
          d +
          1720995;
    } else {
      jd = ((365.25 * y).floor()) +
          ((30.6001 * (m + 1)).floor()) +
          d +
          1720995;
    }

    // Gregorian correction
    final a = (y / 100).floor();
    jd = jd + 2 - a + (a / 4).floor();

    // Convert Julian Day to Hijri
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final remaining = l - 10631 * n + 354;
    final j = (((10985 - remaining) / 5316).floor()) *
            ((((50 * remaining) / 17719).floor())) +
        ((remaining / 5670).floor()) *
            ((((43 * remaining) / 15238).floor()));
    final adjustedRemaining =
        remaining - (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
        (((j / 16).floor()) * (((15238 * j) / 43).floor())) + 29;
    final hijriMonth = ((24 * adjustedRemaining) / 709).floor();
    final hijriDay = adjustedRemaining - ((709 * hijriMonth) / 24).floor();
    final hijriYear = 30 * n + j - 30;

    return HijriCalendar(
      year: hijriYear,
      month: hijriMonth.clamp(1, 12),
      day: hijriDay.clamp(1, 30),
    );
  }

  /// Get current Hijri date
  factory HijriCalendar.now() {
    return HijriCalendar.fromGregorian(DateTime.now());
  }

  /// Hijri month names in Arabic
  static const List<String> monthNamesArabic = [
    'مُحَرَّم',
    'صَفَر',
    'رَبِيع الأَوَّل',
    'رَبِيع الثَّانِي',
    'جُمَادَى الأُولَى',
    'جُمَادَى الثَّانِيَة',
    'رَجَب',
    'شَعْبَان',
    'رَمَضَان',
    'شَوَّال',
    'ذُو القَعْدَة',
    'ذُو الحِجَّة',
  ];

  /// Hijri month names in English
  static const List<String> monthNamesEnglish = [
    'Muharram',
    'Safar',
    'Rabi al-Awwal',
    'Rabi al-Thani',
    'Jumada al-Ula',
    'Jumada al-Thani',
    'Rajab',
    'Shaban',
    'Ramadan',
    'Shawwal',
    'Dhul Qadah',
    'Dhul Hijjah',
  ];

  /// Hijri month names in Turkish
  static const List<String> monthNamesTurkish = [
    'Muharrem',
    'Safer',
    'Rebiülevvel',
    'Rebiülahir',
    'Cemaziyelevvel',
    'Cemaziyelahir',
    'Recep',
    'Şaban',
    'Ramazan',
    'Şevval',
    'Zilkade',
    'Zilhicce',
  ];

  String get monthNameArabic =>
      month >= 1 && month <= 12 ? monthNamesArabic[month - 1] : '';
  String get monthNameEnglish =>
      month >= 1 && month <= 12 ? monthNamesEnglish[month - 1] : '';
  String get monthNameTurkish =>
      month >= 1 && month <= 12 ? monthNamesTurkish[month - 1] : '';

  bool get isRamadan => month == 9;
  bool get isDhulHijjah => month == 12;
  bool get isMuharram => month == 1;

  /// Get special Islamic day if today is one, or null
  String? getSpecialDay(String langCode) {
    final key = '$month-$day';
    final days = _specialDays[key];
    if (days == null) return null;
    return days[langCode] ?? days['en'];
  }

  static const Map<String, Map<String, String>> _specialDays = {
    '1-1': {'en': 'Islamic New Year', 'tr': 'Hicri Yılbaşı', 'ar': 'رأس السنة الهجرية'},
    '1-10': {'en': 'Day of Ashura', 'tr': 'Aşure Günü', 'ar': 'يوم عاشوراء'},
    '3-12': {'en': 'Mawlid al-Nabi', 'tr': 'Mevlid Kandili', 'ar': 'المولد النبوي'},
    '7-27': {'en': 'Isra and Miraj', 'tr': 'Miraç Kandili', 'ar': 'الإسراء والمعراج'},
    '8-15': {'en': 'Mid-Shaban', 'tr': 'Berat Kandili', 'ar': 'ليلة النصف من شعبان'},
    '9-1': {'en': 'Ramadan Begins', 'tr': 'Ramazan Başlangıcı', 'ar': 'بداية رمضان'},
    '9-27': {'en': 'Laylat al-Qadr', 'tr': 'Kadir Gecesi', 'ar': 'ليلة القدر'},
    '10-1': {'en': 'Eid al-Fitr', 'tr': 'Ramazan Bayramı', 'ar': 'عيد الفطر'},
    '10-2': {'en': 'Eid al-Fitr (2nd day)', 'tr': 'Ramazan Bayramı 2. gün', 'ar': 'عيد الفطر'},
    '10-3': {'en': 'Eid al-Fitr (3rd day)', 'tr': 'Ramazan Bayramı 3. gün', 'ar': 'عيد الفطر'},
    '12-9': {'en': 'Day of Arafah', 'tr': 'Arefe Günü', 'ar': 'يوم عرفة'},
    '12-10': {'en': 'Eid al-Adha', 'tr': 'Kurban Bayramı', 'ar': 'عيد الأضحى'},
    '12-11': {'en': 'Eid al-Adha (2nd day)', 'tr': 'Kurban Bayramı 2. gün', 'ar': 'عيد الأضحى'},
    '12-12': {'en': 'Eid al-Adha (3rd day)', 'tr': 'Kurban Bayramı 3. gün', 'ar': 'عيد الأضحى'},
    '12-13': {'en': 'Eid al-Adha (4th day)', 'tr': 'Kurban Bayramı 4. gün', 'ar': 'عيد الأضحى'},
  };

  /// Get upcoming special days within the next N days
  static List<(DateTime, String)> getUpcomingEvents(String langCode, {int withinDays = 7}) {
    final events = <(DateTime, String)>[];
    final now = DateTime.now();
    for (int d = 1; d <= withinDays; d++) {
      final date = now.add(Duration(days: d));
      final hijri = HijriCalendar.fromGregorian(date);
      final special = hijri.getSpecialDay(langCode);
      if (special != null) {
        events.add((date, special));
      }
    }
    return events;
  }

  /// Check if today is a sunnah fasting day
  static String? getSunnahFastingReason(String langCode) {
    final now = DateTime.now();
    final hijri = HijriCalendar.fromGregorian(now);

    // Ayyamul Beed (White Days): 13, 14, 15 of each Hijri month
    if (hijri.day >= 13 && hijri.day <= 15) {
      return langCode == 'tr' ? 'Eyyâm-ı Bîd orucu (ayın 13-14-15\'i)' :
             langCode == 'ar' ? 'أيام البيض (١٣-١٤-١٥ من الشهر)' :
             'Ayyamul Beed (13th-15th of Hijri month)';
    }

    // Monday and Thursday
    if (now.weekday == DateTime.monday) {
      return langCode == 'tr' ? 'Pazartesi orucu (sünnet)' :
             langCode == 'ar' ? 'صيام الاثنين (سنة)' :
             'Monday fast (Sunnah)';
    }
    if (now.weekday == DateTime.thursday) {
      return langCode == 'tr' ? 'Perşembe orucu (sünnet)' :
             langCode == 'ar' ? 'صيام الخميس (سنة)' :
             'Thursday fast (Sunnah)';
    }

    // Day of Arafah (9 Dhul Hijjah) — not during Hajj
    if (hijri.month == 12 && hijri.day == 9) {
      return langCode == 'tr' ? 'Arefe günü orucu (geçmiş ve gelecek yılın günahlarına kefarettir)' :
             langCode == 'ar' ? 'صيام يوم عرفة' :
             'Day of Arafah fast';
    }

    // Ashura (10 Muharram) + day before
    if (hijri.month == 1 && (hijri.day == 9 || hijri.day == 10)) {
      return langCode == 'tr' ? 'Aşûre günü orucu (geçmiş yılın günahlarına kefarettir)' :
             langCode == 'ar' ? 'صيام عاشوراء' :
             'Ashura fast';
    }

    // 6 days of Shawwal
    if (hijri.month == 10 && hijri.day >= 2 && hijri.day <= 7) {
      return langCode == 'tr' ? 'Şevval\'in 6 günü orucu (bir yıl oruç tutmuş gibi sevaptır)' :
             langCode == 'ar' ? 'صيام ستة من شوال' :
             'Six days of Shawwal fast';
    }

    return null;
  }

  String getMonthName(String langCode) {
    switch (langCode) {
      case 'ar':
        return monthNameArabic;
      case 'tr':
        return monthNameTurkish;
      default:
        return monthNameEnglish;
    }
  }

  String format(String langCode) {
    return '$day ${getMonthName(langCode)} $year';
  }

  @override
  String toString() => '$day $monthNameEnglish $year AH';
}
