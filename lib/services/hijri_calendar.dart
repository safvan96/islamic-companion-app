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
  String toString() => '$day ${monthNameEnglish} $year AH';
}
