import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';

class SadaqahScreen extends StatefulWidget {
  const SadaqahScreen({super.key});

  @override
  State<SadaqahScreen> createState() => _SadaqahScreenState();
}

class _SadaqahScreenState extends State<SadaqahScreen>
    with SingleTickerProviderStateMixin {
  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;
  bool _showThankYou = false;
  int _sadaqahCount = 0;
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heartAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
    _loadSadaqahCount();
    if (!kIsWeb) _loadRewardedAd();
  }

  Future<void> _loadSadaqahCount() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _sadaqahCount = prefs.getInt('sadaqahCount') ?? 0);
  }

  Future<void> _incrementSadaqah() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _sadaqahCount++);
    await prefs.setInt('sadaqahCount', _sadaqahCount);
  }

  void _loadRewardedAd() {
    if (kIsWeb) return;
    setState(() => _isAdLoading = true);
    RewardedAd.load(
      adUnitId: AdConstants.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoading = false;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() => _isAdLoading = false);
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  void _showRewardedAd() {
    final l10n = AppLocalizations.of(context)!;

    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('adNotReady')),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      _loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        _incrementSadaqah();
        setState(() => _showThankYou = true);
        _heartController.forward().then((_) {
          _heartController.reverse();
        });
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) setState(() => _showThankYou = false);
        });
      },
    );
    _rewardedAd = null;
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('sadaqah')),
        backgroundColor: const Color(0xFFC62828),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1A1A), const Color(0xFF2D1515)]
                : [const Color(0xFFFFF5F5), const Color(0xFFFFEBEE)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Heart animation
                  AnimatedBuilder(
                    animation: _heartController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFC62828).withOpacity(0.2),
                                const Color(0xFFC62828).withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 70,
                            color: Color(0xFFC62828),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    l10n.translate('sadaqah'),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFFC62828),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Hadith about sadaqah
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ',
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFFD4AF37),
                            height: 1.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.translate('sadaqahMessage'),
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black54,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Watch Ad Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isAdLoading ? null : _showRewardedAd,
                      icon: _isAdLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.play_circle_fill, size: 28),
                      label: Text(
                        l10n.translate('watchAd'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor:
                            const Color(0xFFC62828).withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sadaqah count
                  if (_sadaqahCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFD4AF37),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n.translate('total')}: $_sadaqahCount',
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Thank you message
                  AnimatedOpacity(
                    opacity: _showThankYou ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B5E20).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF1B5E20).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF1B5E20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.translate('sadaqahThank'),
                              style: const TextStyle(
                                color: Color(0xFF1B5E20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

