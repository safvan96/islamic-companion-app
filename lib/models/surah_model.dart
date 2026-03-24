class SurahModel {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String transliteration;
  final int versesCount;
  final String arabicText;
  final Map<String, String> translations;
  final String youtubeUrl;

  const SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.transliteration,
    required this.versesCount,
    required this.arabicText,
    required this.translations,
    required this.youtubeUrl,
  });

  static const List<SurahModel> shortSurahs = [
    SurahModel(
      number: 1,
      nameArabic: 'الفاتحة',
      nameEnglish: 'The Opening',
      transliteration: 'Al-Fatiha',
      versesCount: 7,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴿١﴾\nالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ﴿٢﴾\nالرَّحْمَٰنِ الرَّحِيمِ ﴿٣﴾\nمَالِكِ يَوْمِ الدِّينِ ﴿٤﴾\nإِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ﴿٥﴾\nاهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ﴿٦﴾\nصِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ ﴿٧﴾',
      translations: {
        'en': 'In the name of Allah, the Most Gracious, the Most Merciful. Praise be to Allah, Lord of the Worlds. The Most Gracious, the Most Merciful. Master of the Day of Judgment. You alone we worship, and You alone we ask for help. Guide us on the Straight Path. The path of those You have blessed, not of those who earned anger, nor of those who went astray.',
        'tr': 'Rahman ve Rahim olan Allah\'ın adıyla. Hamd, âlemlerin Rabbi Allah\'a mahsustur. Rahman ve Rahim olan. Din gününün sahibi. Yalnız Sana ibadet ederiz ve yalnız Senden yardım dileriz. Bizi doğru yola ilet. Kendilerine nimet verdiklerinin yoluna; gazaba uğrayanların ve sapıtanların yoluna değil.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=al-Cf3t2jHI',
    ),
    SurahModel(
      number: 112,
      nameArabic: 'الإخلاص',
      nameEnglish: 'Sincerity',
      transliteration: 'Al-Ikhlas',
      versesCount: 4,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nقُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾\nاللَّهُ الصَّمَدُ ﴿٢﴾\nلَمْ يَلِدْ وَلَمْ يُولَدْ ﴿٣﴾\nوَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ ﴿٤﴾',
      translations: {
        'en': 'Say: He is Allah, the One. Allah, the Eternal Refuge. He neither begets nor is born. Nor is there to Him any equivalent.',
        'tr': 'De ki: O Allah birdir. Allah Samed\'dir. Doğurmamış ve doğmamıştır. Hiçbir şey O\'na denk değildir.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=hoRqiGMrl5M',
    ),
    SurahModel(
      number: 113,
      nameArabic: 'الفلق',
      nameEnglish: 'The Daybreak',
      transliteration: 'Al-Falaq',
      versesCount: 5,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ﴿١﴾\nمِن شَرِّ مَا خَلَقَ ﴿٢﴾\nوَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ﴿٣﴾\nوَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ﴿٤﴾\nوَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ ﴿٥﴾',
      translations: {
        'en': 'Say: I seek refuge in the Lord of daybreak. From the evil of that which He created. And from the evil of darkness when it settles. And from the evil of the blowers in knots. And from the evil of an envier when he envies.',
        'tr': 'De ki: Sabahın Rabbine sığınırım. Yarattığı şeylerin şerrinden. Karanlığı çöktüğü zaman gecenin şerrinden. Düğümlere üfleyenlerin şerrinden. Ve haset ettiği zaman hasetçinin şerrinden.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=DEolYqSBejg',
    ),
    SurahModel(
      number: 114,
      nameArabic: 'الناس',
      nameEnglish: 'Mankind',
      transliteration: 'An-Nas',
      versesCount: 6,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ ﴿١﴾\nمَلِكِ النَّاسِ ﴿٢﴾\nإِلَٰهِ النَّاسِ ﴿٣﴾\nمِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ﴿٤﴾\nالَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ﴿٥﴾\nمِنَ الْجِنَّةِ وَالنَّاسِ ﴿٦﴾',
      translations: {
        'en': 'Say: I seek refuge in the Lord of mankind. The King of mankind. The God of mankind. From the evil of the retreating whisperer. Who whispers in the breasts of mankind. From among the jinn and mankind.',
        'tr': 'De ki: İnsanların Rabbine sığınırım. İnsanların Melikine. İnsanların İlahına. Sinsi vesvesecinin şerrinden. O ki insanların göğüslerine vesvese verir. Gerek cinlerden gerek insanlardan.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=VpFEbtrjOg0',
    ),
    SurahModel(
      number: 108,
      nameArabic: 'الكوثر',
      nameEnglish: 'Abundance',
      transliteration: 'Al-Kawthar',
      versesCount: 3,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nإِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ ﴿١﴾\nفَصَلِّ لِرَبِّكَ وَانْحَرْ ﴿٢﴾\nإِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ ﴿٣﴾',
      translations: {
        'en': 'Indeed, We have granted you Al-Kawthar. So pray to your Lord and sacrifice. Indeed, your enemy is the one cut off.',
        'tr': 'Şüphesiz biz sana Kevser\'i verdik. O halde Rabbin için namaz kıl ve kurban kes. Doğrusu sana buğzeden, soyu kesik olanın ta kendisidir.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=vJGrao5Nq5w',
    ),
    SurahModel(
      number: 110,
      nameArabic: 'النصر',
      nameEnglish: 'Divine Support',
      transliteration: 'An-Nasr',
      versesCount: 3,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nإِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ ﴿١﴾\nوَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا ﴿٢﴾\nفَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ ۚ إِنَّهُ كَانَ تَوَّابًا ﴿٣﴾',
      translations: {
        'en': 'When the victory of Allah has come and the conquest. And you see the people entering into the religion of Allah in multitudes. Then exalt with praise of your Lord and ask forgiveness of Him. Indeed, He is ever Accepting of repentance.',
        'tr': 'Allah\'ın yardımı ve fetih geldiğinde. Ve insanların bölük bölük Allah\'ın dinine girdiklerini gördüğünde. Rabbini hamd ile tesbih et ve O\'ndan mağfiret dile. Şüphesiz O, tövbeleri çok kabul edendir.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=0zlIxkRFi6w',
    ),
    SurahModel(
      number: 111,
      nameArabic: 'المسد',
      nameEnglish: 'The Palm Fiber',
      transliteration: 'Al-Masad',
      versesCount: 5,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nتَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ ﴿١﴾\nمَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ ﴿٢﴾\nسَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ ﴿٣﴾\nوَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ ﴿٤﴾\nفِي جِيدِهَا حَبْلٌ مِّن مَّسَدٍ ﴿٥﴾',
      translations: {
        'en': 'May the hands of Abu Lahab be ruined, and ruined is he. His wealth will not avail him or that which he gained. He will burn in a Fire of blazing flame. And his wife, the carrier of firewood. Around her neck is a rope of palm fiber.',
        'tr': 'Ebu Leheb\'in elleri kurusun, kurudu da. Malı ve kazandıkları ona fayda vermedi. Alevli bir ateşe girecektir. Karısı da odun taşıyıcısı olarak. Boynunda hurma lifinden bir ip olduğu halde.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=FBiGnSPOhBU',
    ),
    SurahModel(
      number: 109,
      nameArabic: 'الكافرون',
      nameEnglish: 'The Disbelievers',
      transliteration: 'Al-Kafirun',
      versesCount: 6,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nقُلْ يَا أَيُّهَا الْكَافِرُونَ ﴿١﴾\nلَا أَعْبُدُ مَا تَعْبُدُونَ ﴿٢﴾\nوَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ ﴿٣﴾\nوَلَا أَنَا عَابِدٌ مَّا عَبَدتُّمْ ﴿٤﴾\nوَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ ﴿٥﴾\nلَكُمْ دِينُكُمْ وَلِيَ دِينِ ﴿٦﴾',
      translations: {
        'en': 'Say: O disbelievers. I do not worship what you worship. Nor are you worshippers of what I worship. Nor will I be a worshipper of what you worship. Nor will you be worshippers of what I worship. For you is your religion, and for me is my religion.',
        'tr': 'De ki: Ey kâfirler! Ben sizin taptıklarınıza tapmam. Siz de benim taptığıma tapmazsınız. Ben sizin taptıklarınıza tapacak değilim. Siz de benim taptığıma tapacak değilsiniz. Sizin dininiz size, benim dinim banadır.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=VQxf5X4GkFI',
    ),
    SurahModel(
      number: 36,
      nameArabic: 'يس',
      nameEnglish: 'Ya-Sin',
      transliteration: 'Ya-Sin',
      versesCount: 83,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nيس ﴿١﴾\nوَالْقُرْآنِ الْحَكِيمِ ﴿٢﴾\nإِنَّكَ لَمِنَ الْمُرْسَلِينَ ﴿٣﴾\nعَلَىٰ صِرَاطٍ مُّسْتَقِيمٍ ﴿٤﴾\n...',
      translations: {
        'en': 'Ya-Sin. By the wise Quran. Indeed you are from among the messengers. On a straight path.',
        'tr': 'Yâ Sîn. Hikmetli Kur\'an\'a andolsun. Şüphesiz sen gönderilen peygamberlerdensin. Dosdoğru bir yol üzerindesin.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=UkfRwVoJffI',
    ),
    SurahModel(
      number: 67,
      nameArabic: 'الملك',
      nameEnglish: 'The Sovereignty',
      transliteration: 'Al-Mulk',
      versesCount: 30,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nتَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ ﴿١﴾\nالَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا ۚ وَهُوَ الْعَزِيزُ الْغَفُورُ ﴿٢﴾\n...',
      translations: {
        'en': 'Blessed is He in whose hand is dominion, and He is over all things competent. He who created death and life to test you as to which of you is best in deed - and He is the Exalted in Might, the Forgiving.',
        'tr': 'Mülk elinde olan ne yücedir! O her şeye kadirdir. Hanginizin daha güzel amel yapacağını denemek için ölümü ve hayatı yaratan O\'dur. O, Azîz\'dir, Gafûr\'dur.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=2KQHZM6e3mA',
    ),
    SurahModel(
      number: 55,
      nameArabic: 'الرحمن',
      nameEnglish: 'The Most Merciful',
      transliteration: 'Ar-Rahman',
      versesCount: 78,
      arabicText:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nالرَّحْمَٰنُ ﴿١﴾\nعَلَّمَ الْقُرْآنَ ﴿٢﴾\nخَلَقَ الْإِنسَانَ ﴿٣﴾\nعَلَّمَهُ الْبَيَانَ ﴿٤﴾\n...',
      translations: {
        'en': 'The Most Merciful. Taught the Quran. Created man. Taught him eloquence.',
        'tr': 'Rahman. Kur\'an\'ı öğretti. İnsanı yarattı. Ona beyanı öğretti.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=UkfRwVoJffI',
    ),
    SurahModel(
      number: 2,
      nameArabic: 'آية الكرسي',
      nameEnglish: 'Ayat al-Kursi (The Throne Verse)',
      transliteration: 'Ayatul Kursi',
      versesCount: 1,
      arabicText:
          'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      translations: {
        'en': 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
        'tr': 'Allah, O\'ndan başka ilah yoktur. Hayy ve Kayyum\'dur. O\'nu ne uyuklama tutar ne uyku. Göklerde ve yerde ne varsa O\'nundur. İzni olmadan O\'nun katında kim şefaat edebilir? O, kullarının önlerindekini ve arkalarındakini bilir. Onlar O\'nun ilminden, O\'nun dilediği kadarından başka bir şey kavrayamazlar. O\'nun kürsüsü gökleri ve yeri kaplamıştır. Onların korunması O\'na güç gelmez. O, yücedir, büyüktür.',
      },
      youtubeUrl: 'https://www.youtube.com/watch?v=eXQnCGiIoNM',
    ),
  ];
}
