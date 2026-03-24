import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/dhikr_provider.dart';
import '../providers/app_provider.dart';

class DhikrScreen extends StatefulWidget {
  const DhikrScreen({super.key});

  @override
  State<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends State<DhikrScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTap(DhikrProvider provider) {
    HapticFeedback.mediumImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());
    provider.increment();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dhikrProvider = Provider.of<DhikrProvider>(context);
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final currentDhikr =
        DhikrProvider.dhikrList[dhikrProvider.selectedDhikrIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('dhikr')),
        backgroundColor: const Color(0xFF6A1B9A),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => dhikrProvider.reset(),
            tooltip: l10n.translate('reset'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A0A2E), const Color(0xFF16213E)]
                : [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)],
          ),
        ),
        child: Column(
          children: [
            // Dhikr selector
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: DhikrProvider.dhikrList.length,
                itemBuilder: (context, index) {
                  final dhikr = DhikrProvider.dhikrList[index];
                  final isSelected =
                      index == dhikrProvider.selectedDhikrIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        dhikr['transliteration']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6A1B9A),
                      onSelected: (_) => dhikrProvider.selectDhikr(index),
                    ),
                  );
                },
              ),
            ),
            // Arabic text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                currentDhikr['arabic']!,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF6A1B9A),
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              currentDhikr['meaning']!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const Spacer(),
            // Counter display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CounterBox(
                  label: l10n.translate('counter'),
                  value: dhikrProvider.count.toString(),
                  isDark: isDark,
                ),
                const SizedBox(width: 20),
                _CounterBox(
                  label: l10n.translate('target'),
                  value: dhikrProvider.targetCount.toString(),
                  isDark: isDark,
                ),
                const SizedBox(width: 20),
                _CounterBox(
                  label: l10n.translate('total'),
                  value: dhikrProvider.totalCount.toString(),
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (dhikrProvider.count / dhikrProvider.targetCount)
                      .clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    dhikrProvider.targetReached
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF6A1B9A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Big tap button
            GestureDetector(
              onTap: () => _onTap(dhikrProvider),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: dhikrProvider.targetReached
                              ? [
                                  const Color(0xFFD4AF37),
                                  const Color(0xFFB8860B),
                                ]
                              : [
                                  const Color(0xFF9C27B0),
                                  const Color(0xFF6A1B9A),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (dhikrProvider.targetReached
                                    ? const Color(0xFFD4AF37)
                                    : const Color(0xFF6A1B9A))
                                .withOpacity(0.5),
                            blurRadius: 25,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dhikrProvider.count.toString(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.touch_app,
                            color: Colors.white70,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Target selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [33, 99, 100, 500, 1000].map((target) {
                final isActive = dhikrProvider.targetCount == target;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    label: Text(
                      target.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive ? Colors.white : null,
                      ),
                    ),
                    backgroundColor:
                        isActive ? const Color(0xFF6A1B9A) : null,
                    onPressed: () => dhikrProvider.setTarget(target),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _CounterBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _CounterBox({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
