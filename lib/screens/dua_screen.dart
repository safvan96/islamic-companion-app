import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  static const List<Map<String, dynamic>> _duas = [
    {
      'category': 'morning',
      'categoryIcon': Icons.wb_sunny,
      'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      'transliteration': 'Asbahna wa asbahal mulku lillah, walhamdu lillah, la ilaha illAllahu wahdahu la sharika lah.',
      'translations': {
        'en': 'We have reached the morning and the dominion belongs to Allah. Praise is to Allah. There is no god but Allah alone, with no partner.',
        'ar': 'أصبحنا وأصبح الملك لله والحمد لله لا إله إلا الله وحده لا شريك له',
        'ru': 'Мы встретили утро, и вся власть принадлежит Аллаху. Хвала Аллаху. Нет бога, кроме Аллаха, Единого, без сотоварища.',
        'hi': 'हमने सुबह की और सारा राज्य अल्लाह का है। सारी प्रशंसा अल्लाह के लिए है। अल्लाह के सिवा कोई पूज्य नहीं, अकेला, उसका कोई साझीदार नहीं।',
        'id': 'Kami telah memasuki waktu pagi dan kerajaan milik Allah. Segala puji bagi Allah. Tiada tuhan selain Allah semata, tiada sekutu bagi-Nya.',
        'zh': '我们迎来了早晨，一切权力属于真主。赞美归于真主。没有神灵除真主，独一无二，没有伙伴。',
        'de': 'Wir haben den Morgen erreicht und die Herrschaft gehört Allah. Lob gebührt Allah. Es gibt keinen Gott außer Allah allein, ohne Partner.',
        'nl': 'Wij hebben de ochtend bereikt en de heerschappij behoort toe aan Allah. Lof zij Allah. Er is geen god dan Allah alleen, zonder partner.',
        'fr': 'Nous avons atteint le matin et la souveraineté appartient à Allah. Louange à Allah. Il n\'y a de dieu qu\'Allah seul, sans associé.',
        'es': 'Hemos llegado a la mañana y el dominio pertenece a Allah. La alabanza es para Allah. No hay dios sino Allah solo, sin socio.',
      },
    },
    {
      'category': 'evening',
      'categoryIcon': Icons.nightlight_round,
      'arabic': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      'transliteration': 'Amsayna wa amsal mulku lillah, walhamdu lillah, la ilaha illAllahu wahdahu la sharika lah.',
      'translations': {
        'en': 'We have reached the evening and the dominion belongs to Allah. Praise is to Allah. There is no god but Allah alone, with no partner.',
        'ar': 'أمسينا وأمسى الملك لله والحمد لله لا إله إلا الله وحده لا شريك له',
        'ru': 'Мы встретили вечер, и вся власть принадлежит Аллаху. Хвала Аллаху. Нет бога, кроме Аллаха, Единого, без сотоварища.',
        'hi': 'हमने शाम की और सारा राज्य अल्लाह का है। सारी प्रशंसा अल्लाह के लिए है।',
        'id': 'Kami telah memasuki waktu petang dan kerajaan milik Allah. Segala puji bagi Allah.',
        'zh': '我们迎来了晚上，一切权力属于真主。赞美归于真主。',
        'de': 'Wir haben den Abend erreicht und die Herrschaft gehört Allah.',
        'nl': 'Wij hebben de avond bereikt en de heerschappij behoort toe aan Allah.',
        'fr': 'Nous avons atteint le soir et la souveraineté appartient à Allah.',
        'es': 'Hemos llegado a la noche y el dominio pertenece a Allah.',
      },
    },
    {
      'category': 'sleep',
      'categoryIcon': Icons.bedtime,
      'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      'transliteration': 'Bismika Allahumma amutu wa ahya.',
      'translations': {
        'en': 'In Your name, O Allah, I die and I live.',
        'ar': 'باسمك اللهم أموت وأحيا',
        'ru': 'С Твоим именем, о Аллах, я умираю и живу.',
        'hi': 'तेरे नाम से, ऐ अल्लाह, मैं मरता और जीता हूँ।',
        'id': 'Dengan nama-Mu ya Allah, aku mati dan aku hidup.',
        'zh': '以你的名义，真主啊，我死去我活着。',
        'de': 'In Deinem Namen, o Allah, sterbe und lebe ich.',
        'nl': 'In Uw naam, o Allah, sterf en leef ik.',
        'fr': 'En Ton nom, ô Allah, je meurs et je vis.',
        'es': 'En Tu nombre, oh Allah, muero y vivo.',
      },
    },
    {
      'category': 'food',
      'categoryIcon': Icons.restaurant,
      'arabic': 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
      'transliteration': 'Bismillahi wa ala barakatillah.',
      'translations': {
        'en': 'In the name of Allah and with the blessings of Allah.',
        'ar': 'بسم الله وعلى بركة الله',
        'ru': 'Во имя Аллаха и с благословением Аллаха.',
        'hi': 'अल्लाह के नाम से और अल्लाह की बरकत से।',
        'id': 'Dengan nama Allah dan dengan berkah Allah.',
        'zh': '以真主之名，凭真主的吉庆。',
        'de': 'Im Namen Allahs und mit dem Segen Allahs.',
        'nl': 'In de naam van Allah en met de zegeningen van Allah.',
        'fr': 'Au nom d\'Allah et avec les bénédictions d\'Allah.',
        'es': 'En el nombre de Allah y con las bendiciones de Allah.',
      },
    },
    {
      'category': 'travel',
      'categoryIcon': Icons.flight,
      'arabic': 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
      'transliteration': 'Subhanal-ladhi sakh-khara lana hadha wa ma kunna lahu muqrinin, wa inna ila Rabbina lamunqalibun.',
      'translations': {
        'en': 'Glory to Him who has subjected this to us, and we could never have it. And to our Lord, surely, we are to return.',
        'ar': 'سبحان الذي سخر لنا هذا وما كنا له مقرنين وإنا إلى ربنا لمنقلبون',
        'ru': 'Пречист Тот, Кто подчинил нам это, ведь сами мы не могли бы этого. И мы к нашему Господу вернёмся.',
        'hi': 'पाक है वह जिसने इसे हमारे वश में किया और हम इसे वश में करने की ताक़त नहीं रखते। और हम अपने रब की ओर लौटने वाले हैं।',
        'id': 'Maha Suci yang menundukkan ini untuk kami, padahal kami tidak mampu menguasainya. Dan sesungguhnya kami akan kembali kepada Tuhan kami.',
        'zh': '赞美那为我们制服这一切的主，我们自己无法做到。我们确将归于我们的主。',
        'de': 'Gepriesen sei Der, Der uns dieses dienstbar gemacht hat, und wir hätten es nicht vermocht. Und zu unserem Herrn werden wir zurückkehren.',
        'nl': 'Glorie aan Degene Die dit voor ons onderworpen heeft, wij hadden het niet kunnen doen. En tot onze Heer keren wij terug.',
        'fr': 'Gloire à Celui qui a mis ceci à notre service, nous n\'aurions pas pu le faire. Et c\'est vers notre Seigneur que nous retournerons.',
        'es': 'Gloria a Quien ha sometido esto para nosotros, que no podríamos haberlo hecho. Y a nuestro Señor ciertamente regresaremos.',
      },
    },
    {
      'category': 'mosque',
      'categoryIcon': Icons.mosque,
      'arabic': 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      'transliteration': 'Allahumma iftah li abwaba rahmatik.',
      'translations': {
        'en': 'O Allah, open the gates of Your mercy for me.',
        'ar': 'اللهم افتح لي أبواب رحمتك',
        'ru': 'О Аллах, открой для меня врата Твоей милости.',
        'hi': 'ऐ अल्लाह, मेरे लिए अपनी रहमत के दरवाज़े खोल दे।',
        'id': 'Ya Allah, bukakanlah pintu-pintu rahmat-Mu untukku.',
        'zh': '真主啊，请为我打开你慈悲之门。',
        'de': 'O Allah, öffne mir die Tore Deiner Barmherzigkeit.',
        'nl': 'O Allah, open voor mij de deuren van Uw genade.',
        'fr': 'Ô Allah, ouvre-moi les portes de Ta miséricorde.',
        'es': 'Oh Allah, abre para mí las puertas de Tu misericordia.',
      },
    },
    {
      'category': 'protection',
      'categoryIcon': Icons.shield,
      'arabic': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      'transliteration': 'Bismillahil-ladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\'i wa huwas-Sami\'ul-Alim.',
      'translations': {
        'en': 'In the name of Allah with whose name nothing can cause harm in the earth or in the heavens. He is the All-Hearing, the All-Knowing.',
        'ar': 'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم',
        'ru': 'Во имя Аллаха, с именем Которого ничто не причинит вреда ни на земле, ни на небесах. Он Всеслышащий, Всезнающий.',
        'hi': 'अल्लाह के नाम से, जिसके नाम के साथ ज़मीन और आसमान में कोई चीज़ नुकसान नहीं पहुँचा सकती। वह सब सुनने वाला, सब जानने वाला है।',
        'id': 'Dengan nama Allah yang dengan nama-Nya tidak ada sesuatu pun yang membahayakan di bumi dan di langit. Dia Maha Mendengar lagi Maha Mengetahui.',
        'zh': '以真主之名，凭他的名，天地间没有任何事物能造成伤害。他是全听的，全知的。',
        'de': 'Im Namen Allahs, mit dessen Namen nichts auf Erden und im Himmel Schaden anrichten kann. Er ist der Allhörende, der Allwissende.',
        'nl': 'In de naam van Allah, met wiens naam niets op aarde of in de hemelen schade kan berokkenen. Hij is de Alhorende, de Alwetende.',
        'fr': 'Au nom d\'Allah, avec le nom duquel rien ne peut nuire sur terre ni dans les cieux. Il est l\'Audient, l\'Omniscient.',
        'es': 'En el nombre de Allah, con cuyo nombre nada puede causar daño en la tierra ni en los cielos. Él es el que Todo lo Oye, el Omnisciente.',
      },
    },
    {
      'category': 'forgiveness',
      'categoryIcon': Icons.favorite_border,
      'arabic': 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
      'transliteration': 'Rabbighfir li wa tub alayya, innaka Antat-Tawwabur-Rahim.',
      'translations': {
        'en': 'My Lord, forgive me and accept my repentance. You are the Acceptor of Repentance, the Most Merciful.',
        'ar': 'رب اغفر لي وتب عليّ إنك أنت التواب الرحيم',
        'ru': 'Господь мой, прости меня и прими моё покаяние. Ты — Принимающий покаяние, Милосердный.',
        'hi': 'मेरे रब, मुझे माफ़ कर और मेरी तौबा कबूल कर। बेशक तू तौबा कबूल करने वाला, रहम करने वाला है।',
        'id': 'Ya Tuhanku, ampunilah aku dan terimalah taubatku. Sesungguhnya Engkau Maha Penerima taubat lagi Maha Penyayang.',
        'zh': '我的主啊，请原谅我，接受我的忏悔。你是接受忏悔的，至慈的。',
        'de': 'Mein Herr, vergib mir und nimm meine Reue an. Du bist der Reue-Annehmende, der Barmherzige.',
        'nl': 'Mijn Heer, vergeef mij en aanvaard mijn berouw. U bent de Aanvaardder van Berouw, de Meest Barmhartige.',
        'fr': 'Mon Seigneur, pardonne-moi et accepte mon repentir. Tu es l\'Accueillant au repentir, le Miséricordieux.',
        'es': 'Señor mío, perdóname y acepta mi arrepentimiento. Tú eres el que Acepta el arrepentimiento, el Más Misericordioso.',
      },
    },
  ];

  static const Map<String, Map<String, String>> _categoryNames = {
    'morning': {'en': 'Morning', 'ar': 'الصباح', 'ru': 'Утро', 'hi': 'सुबह', 'id': 'Pagi', 'zh': '早晨', 'de': 'Morgen', 'nl': 'Ochtend', 'fr': 'Matin', 'es': 'Mañana'},
    'evening': {'en': 'Evening', 'ar': 'المساء', 'ru': 'Вечер', 'hi': 'शाम', 'id': 'Petang', 'zh': '晚上', 'de': 'Abend', 'nl': 'Avond', 'fr': 'Soir', 'es': 'Noche'},
    'sleep': {'en': 'Before Sleep', 'ar': 'قبل النوم', 'ru': 'Перед сном', 'hi': 'सोने से पहले', 'id': 'Sebelum Tidur', 'zh': '睡前', 'de': 'Vor dem Schlafen', 'nl': 'Voor het Slapen', 'fr': 'Avant de Dormir', 'es': 'Antes de Dormir'},
    'food': {'en': 'Before Eating', 'ar': 'قبل الأكل', 'ru': 'Перед едой', 'hi': 'खाने से पहले', 'id': 'Sebelum Makan', 'zh': '饭前', 'de': 'Vor dem Essen', 'nl': 'Voor het Eten', 'fr': 'Avant de Manger', 'es': 'Antes de Comer'},
    'travel': {'en': 'Travel', 'ar': 'السفر', 'ru': 'Путешествие', 'hi': 'यात्रा', 'id': 'Perjalanan', 'zh': '旅行', 'de': 'Reise', 'nl': 'Reis', 'fr': 'Voyage', 'es': 'Viaje'},
    'mosque': {'en': 'Entering Mosque', 'ar': 'دخول المسجد', 'ru': 'Вход в мечеть', 'hi': 'मस्जिद में प्रवेश', 'id': 'Masuk Masjid', 'zh': '进入清真寺', 'de': 'Betreten der Moschee', 'nl': 'Betreden van de Moskee', 'fr': 'Entrée à la Mosquée', 'es': 'Entrando a la Mezquita'},
    'protection': {'en': 'Protection', 'ar': 'الحماية', 'ru': 'Защита', 'hi': 'सुरक्षा', 'id': 'Perlindungan', 'zh': '保护', 'de': 'Schutz', 'nl': 'Bescherming', 'fr': 'Protection', 'es': 'Protección'},
    'forgiveness': {'en': 'Forgiveness', 'ar': 'الاستغفار', 'ru': 'Прощение', 'hi': 'क्षमा', 'id': 'Ampunan', 'zh': '宽恕', 'de': 'Vergebung', 'nl': 'Vergiffenis', 'fr': 'Pardon', 'es': 'Perdón'},
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final langCode = Provider.of<AppProvider>(context).locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duas / الدعاء'),
        backgroundColor: const Color(0xFF00838F),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1A1A), const Color(0xFF0A1929)]
                : [const Color(0xFFE0F7FA), const Color(0xFFB2EBF2)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _duas.length,
          itemBuilder: (context, index) {
            final dua = _duas[index];
            final category = dua['category'] as String;
            final categoryName = _categoryNames[category]?[langCode] ??
                _categoryNames[category]?['en'] ??
                category;
            final translation = (dua['translations']
                as Map<String, String>)[langCode] ??
                (dua['translations'] as Map<String, String>)['en']!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00838F).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      dua['categoryIcon'] as IconData,
                      color: const Color(0xFF00838F),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    categoryName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    dua['transliteration'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : const Color(0xFFE0F7FA),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              dua['arabic'] as String,
                              style: TextStyle(
                                fontSize: 22,
                                color: isDark
                                    ? const Color(0xFFD4AF37)
                                    : const Color(0xFF00695C),
                                height: 2.0,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            dua['transliteration'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            translation,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.black87,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
