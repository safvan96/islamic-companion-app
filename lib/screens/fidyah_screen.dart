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

class FidyahScreen extends StatefulWidget {
  const FidyahScreen({super.key});
  @override
  State<FidyahScreen> createState() => _FidyahScreenState();
}

class _FidyahScreenState extends State<FidyahScreen> {
  final _daysCtrl = TextEditingController();
  final _mealCostCtrl = TextEditingController(text: '10');
  bool _isKaffarah = false;
  double _result = 0;
  bool _calculated = false;

  void _calculate() {
    final days = int.tryParse(_daysCtrl.text) ?? 0;
    final cost = double.tryParse(_mealCostCtrl.text) ?? 10;
    if (days <= 0) return;
    setState(() {
      if (_isKaffarah) {
        // Kaffarah: 60 days fasting OR feed 60 people per day broken
        _result = days * 60 * cost;
      } else {
        // Fidyah: feed one person per missed day
        _result = days * cost;
      }
      _calculated = true;
    });
  }

  @override
  void dispose() { _daysCtrl.dispose(); _mealCostCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('fidyahCalc'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Info cards
          _infoCard(l10n.translate('fidyahInfo'), Icons.info_outline, p.accent, p),
          const SizedBox(height: 8),
          _infoCard(l10n.translate('kaffarahInfo'), Icons.warning_amber, p.gold, p),
          const SizedBox(height: 20),

          // Type toggle
          Container(
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
            child: Row(children: [
              _tab(l10n.translate('fidyah'), !_isKaffarah, p.accent, p, () => setState(() { _isKaffarah = false; _calculated = false; })),
              _tab(l10n.translate('kaffarah'), _isKaffarah, p.gold, p, () => setState(() { _isKaffarah = true; _calculated = false; })),
            ]),
          ),
          const SizedBox(height: 20),

          // Inputs
          _input(_daysCtrl, _isKaffarah ? l10n.translate('daysBroken') : l10n.translate('daysMissed'), Icons.calendar_today, p),
          const SizedBox(height: 10),
          _input(_mealCostCtrl, l10n.translate('mealCost'), Icons.restaurant, p),
          const SizedBox(height: 20),

          // Calculate
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(backgroundColor: _isKaffarah ? p.gold : p.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: Text(l10n.translate('calculate'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          )),

          if (_calculated) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: (_isKaffarah ? p.gold : p.accent).withOpacity(0.3))),
              child: Column(children: [
                Icon(_isKaffarah ? Icons.warning_amber : Icons.volunteer_activism, size: 40, color: _isKaffarah ? p.gold : p.accent),
                const SizedBox(height: 12),
                Text(
                  _isKaffarah ? l10n.translate('kaffarahDue') : l10n.translate('fidyahDue'),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg),
                ),
                const SizedBox(height: 8),
                Text(
                  _result.toStringAsFixed(2),
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: _isKaffarah ? p.gold : p.accent),
                ),
                const SizedBox(height: 12),
                if (_isKaffarah) ...[
                  Text(l10n.translate('kaffarahAlt'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
                  const SizedBox(height: 8),
                  Text('${(int.tryParse(_daysCtrl.text) ?? 0) * 60} ${l10n.translate('daysFasting')}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.accent)),
                ] else
                  Text('${_daysCtrl.text} ${l10n.translate('mealsToFeed')}', style: TextStyle(fontSize: 13, color: p.muted)),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoCard(String text, IconData icon, Color color, _P p) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 18), const SizedBox(width: 10),
      Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: p.muted, height: 1.5))),
    ]),
  );

  Widget _tab(String label, bool active, Color color, _P p, VoidCallback onTap) => Expanded(child: GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: active ? color.withOpacity(0.12) : Colors.transparent, borderRadius: BorderRadius.circular(11)),
      child: Center(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? color : p.muted)))),
  ));

  Widget _input(TextEditingController ctrl, String label, IconData icon, _P p) => Container(
    decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
    child: TextField(controller: ctrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: TextStyle(color: p.fg, fontSize: 15),
      decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: p.muted, fontSize: 13), prefixIcon: Icon(icon, color: p.muted, size: 20), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14))),
  );
}
