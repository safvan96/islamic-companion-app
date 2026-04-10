import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class _Step {
  final String titleKey;
  final String descKey;
  final IconData icon;
  const _Step({required this.titleKey, required this.descKey, required this.icon});
}

const _hajjSteps = [
  _Step(titleKey: 'hajj_s1_title', descKey: 'hajj_s1_desc', icon: Icons.checkroom),
  _Step(titleKey: 'hajj_s2_title', descKey: 'hajj_s2_desc', icon: Icons.mosque),
  _Step(titleKey: 'hajj_s3_title', descKey: 'hajj_s3_desc', icon: Icons.terrain),
  _Step(titleKey: 'hajj_s4_title', descKey: 'hajj_s4_desc', icon: Icons.nights_stay),
  _Step(titleKey: 'hajj_s5_title', descKey: 'hajj_s5_desc', icon: Icons.circle_outlined),
  _Step(titleKey: 'hajj_s6_title', descKey: 'hajj_s6_desc', icon: Icons.content_cut),
  _Step(titleKey: 'hajj_s7_title', descKey: 'hajj_s7_desc', icon: Icons.loop),
  _Step(titleKey: 'hajj_s8_title', descKey: 'hajj_s8_desc', icon: Icons.directions_walk),
  _Step(titleKey: 'hajj_s9_title', descKey: 'hajj_s9_desc', icon: Icons.dark_mode),
  _Step(titleKey: 'hajj_s10_title', descKey: 'hajj_s10_desc', icon: Icons.celebration),
];

const _umrahSteps = [
  _Step(titleKey: 'umrah_s1_title', descKey: 'umrah_s1_desc', icon: Icons.checkroom),
  _Step(titleKey: 'umrah_s2_title', descKey: 'umrah_s2_desc', icon: Icons.loop),
  _Step(titleKey: 'umrah_s3_title', descKey: 'umrah_s3_desc', icon: Icons.directions_walk),
  _Step(titleKey: 'umrah_s4_title', descKey: 'umrah_s4_desc', icon: Icons.content_cut),
];

class HajjGuideScreen extends StatefulWidget {
  const HajjGuideScreen({super.key});
  @override
  State<HajjGuideScreen> createState() => _HajjGuideScreenState();
}

class _HajjGuideScreenState extends State<HajjGuideScreen> {
  bool _isHajj = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final steps = _isHajj ? _hajjSteps : _umrahSteps;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('hajjUmrah'),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.divider),
              ),
              child: Row(
                children: [
                  _Tab(label: l10n.translate('hajj'), active: _isHajj, color: p.gold, p: p, onTap: () => setState(() => _isHajj = true)),
                  _Tab(label: l10n.translate('umrah'), active: !_isHajj, color: p.accent, p: p, onTap: () => setState(() => _isHajj = false)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: steps.length,
              itemBuilder: (context, i) {
                final step = steps[i];
                final isLast = i == steps.length - 1;
                final color = _isHajj ? p.gold : p.accent;
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline
                      SizedBox(
                        width: 40,
                        child: Column(
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.withOpacity(0.15),
                                border: Border.all(color: color, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
                                ),
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  color: p.divider,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: p.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: p.divider),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(step.icon, size: 18, color: color),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      l10n.translate(step.titleKey),
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.translate(step.descKey),
                                style: TextStyle(fontSize: 13, color: p.muted, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final _P p;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.color, required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? color.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(
            child: Text(label, style: TextStyle(fontSize: 14, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? color : p.muted)),
          ),
        ),
      ),
    );
  }
}
