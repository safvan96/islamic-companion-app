import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _Palette {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _Palette({
    required this.bg,
    required this.surface,
    required this.accent,
    required this.gold,
    required this.fg,
    required this.muted,
    required this.divider,
  });
  static _Palette of(bool isDark) => isDark
      ? const _Palette(
          bg: Color(0xFF0E1A19),
          surface: Color(0xFF182624),
          accent: Color(0xFF4FBFA8),
          gold: Color(0xFFE3C77B),
          fg: Color(0xFFF5F1E8),
          muted: Color(0xFF8B968F),
          divider: Color(0xFF243532),
        )
      : const _Palette(
          bg: Color(0xFFF8F5EE),
          surface: Color(0xFFFFFFFF),
          accent: Color(0xFF2C7A6B),
          gold: Color(0xFFB8902B),
          fg: Color(0xFF1F2937),
          muted: Color(0xFF6B6359),
          divider: Color(0xFFE8DDD0),
        );
}

// Nisab thresholds (approximate, gold-based)
// Gold nisab: 85 grams
// Silver nisab: 595 grams
// Zakat rate: 2.5%
const double _goldNisabGrams = 85.0;
const double _zakatRate = 0.025;

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});
  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _cashCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _investCtrl = TextEditingController();
  final _propertyCtrl = TextEditingController();
  final _debtsCtrl = TextEditingController();
  final _goldPriceCtrl = TextEditingController(text: '75');

  String _currency = 'USD';
  bool _calculated = false;
  double _totalWealth = 0;
  double _nisab = 0;
  double _zakatDue = 0;
  bool _isEligible = false;

  static const _currencies = ['USD', 'EUR', 'TRY', 'GBP', 'SAR', 'AED', 'IDR', 'MYR', 'PKR', 'BDT', 'INR'];
  static const _currencySymbols = {
    'USD': '\$', 'EUR': '€', 'TRY': '₺', 'GBP': '£',
    'SAR': 'SAR', 'AED': 'AED', 'IDR': 'Rp', 'MYR': 'RM',
    'PKR': 'Rs', 'BDT': '৳', 'INR': '₹',
  };

  void _calculate() {
    final cash = double.tryParse(_cashCtrl.text) ?? 0;
    final goldValue = double.tryParse(_goldCtrl.text) ?? 0;
    final silverValue = double.tryParse(_silverCtrl.text) ?? 0;
    final invest = double.tryParse(_investCtrl.text) ?? 0;
    final property = double.tryParse(_propertyCtrl.text) ?? 0;
    final debts = double.tryParse(_debtsCtrl.text) ?? 0;
    final goldPrice = double.tryParse(_goldPriceCtrl.text) ?? 75;

    _totalWealth = cash + goldValue + silverValue + invest + property - debts;
    _nisab = _goldNisabGrams * goldPrice;
    _isEligible = _totalWealth >= _nisab;
    _zakatDue = _isEligible ? _totalWealth * _zakatRate : 0;
    _calculated = true;
    setState(() {});
  }

  void _reset() {
    _cashCtrl.clear();
    _goldCtrl.clear();
    _silverCtrl.clear();
    _investCtrl.clear();
    _propertyCtrl.clear();
    _debtsCtrl.clear();
    setState(() => _calculated = false);
  }

  @override
  void dispose() {
    _cashCtrl.dispose();
    _goldCtrl.dispose();
    _silverCtrl.dispose();
    _investCtrl.dispose();
    _propertyCtrl.dispose();
    _debtsCtrl.dispose();
    _goldPriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _Palette.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final sym = _currencySymbols[_currency] ?? _currency;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('zakatCalculator'),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4),
        ),
        centerTitle: true,
        actions: [
          if (_calculated)
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: p.muted),
              onPressed: _reset,
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: p.gold.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.gold.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: p.gold, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.translate('zakatInfo'),
                    style: TextStyle(fontSize: 12, color: p.muted, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Currency & Gold Price
          Row(
            children: [
              Expanded(
                child: _buildDropdown(p, l10n),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InputField(
                  controller: _goldPriceCtrl,
                  label: '${l10n.translate('goldPrice')} (g)',
                  icon: Icons.monetization_on_outlined,
                  palette: p,
                  suffix: '/$sym',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Section: Assets
          _sectionLabel(l10n.translate('assets'), p),
          const SizedBox(height: 10),
          _InputField(
            controller: _cashCtrl,
            label: l10n.translate('cashSavings'),
            icon: Icons.account_balance_wallet_outlined,
            palette: p,
            prefix: sym,
          ),
          const SizedBox(height: 10),
          _InputField(
            controller: _goldCtrl,
            label: l10n.translate('goldValue'),
            icon: Icons.diamond_outlined,
            palette: p,
            prefix: sym,
          ),
          const SizedBox(height: 10),
          _InputField(
            controller: _silverCtrl,
            label: l10n.translate('silverValue'),
            icon: Icons.circle_outlined,
            palette: p,
            prefix: sym,
          ),
          const SizedBox(height: 10),
          _InputField(
            controller: _investCtrl,
            label: l10n.translate('investments'),
            icon: Icons.trending_up,
            palette: p,
            prefix: sym,
          ),
          const SizedBox(height: 10),
          _InputField(
            controller: _propertyCtrl,
            label: l10n.translate('businessAssets'),
            icon: Icons.business_outlined,
            palette: p,
            prefix: sym,
          ),
          const SizedBox(height: 20),

          // Section: Deductions
          _sectionLabel(l10n.translate('deductions'), p),
          const SizedBox(height: 10),
          _InputField(
            controller: _debtsCtrl,
            label: l10n.translate('debts'),
            icon: Icons.remove_circle_outline,
            palette: p,
            prefix: sym,
          ),
          const SizedBox(height: 24),

          // Calculate button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: p.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                l10n.translate('calculateZakat'),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // Results
          if (_calculated) ...[
            const SizedBox(height: 24),
            _ResultCard(
              p: p,
              l10n: l10n,
              sym: sym,
              currency: _currency,
              totalWealth: _totalWealth,
              nisab: _nisab,
              zakatDue: _zakatDue,
              isEligible: _isEligible,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdown(_Palette p, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _currency,
          isExpanded: true,
          dropdownColor: p.surface,
          style: TextStyle(color: p.fg, fontSize: 14),
          icon: Icon(Icons.expand_more, color: p.muted, size: 20),
          items: _currencies
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c, style: TextStyle(color: p.fg)),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _currency = v ?? 'USD'),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, _Palette p) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final _Palette palette;
  final String? prefix;
  final String? suffix;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.palette,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.divider),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: palette.fg, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: palette.muted, fontSize: 13),
          prefixIcon: Icon(icon, color: palette.muted, size: 20),
          prefixText: prefix != null ? '$prefix ' : null,
          prefixStyle: TextStyle(color: palette.fg, fontSize: 15),
          suffixText: suffix,
          suffixStyle: TextStyle(color: palette.muted, fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final _Palette p;
  final AppLocalizations l10n;
  final String sym;
  final String currency;
  final double totalWealth;
  final double nisab;
  final double zakatDue;
  final bool isEligible;

  const _ResultCard({
    required this.p,
    required this.l10n,
    required this.sym,
    required this.currency,
    required this.totalWealth,
    required this.nisab,
    required this.zakatDue,
    required this.isEligible,
  });

  String _fmt(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(2)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(2)}k';
    return n.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isEligible ? p.gold.withOpacity(0.5) : p.accent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Status icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEligible ? p.gold.withOpacity(0.15) : p.accent.withOpacity(0.1),
            ),
            child: Icon(
              isEligible ? Icons.volunteer_activism : Icons.check_circle_outline,
              size: 30,
              color: isEligible ? p.gold : p.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEligible
                ? l10n.translate('zakatDue')
                : l10n.translate('zakatNotDue'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: p.fg,
            ),
          ),
          if (isEligible) ...[
            const SizedBox(height: 8),
            Text(
              '$sym ${_fmt(zakatDue)}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: p.gold,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '2.5% ${l10n.translate('ofTotalWealth')}',
              style: TextStyle(fontSize: 12, color: p.muted),
            ),
          ],
          const SizedBox(height: 20),
          // Breakdown
          _row(l10n.translate('totalWealth'), '$sym ${_fmt(totalWealth)}'),
          _row(l10n.translate('nisabThreshold'), '$sym ${_fmt(nisab)}'),
          _row(l10n.translate('nisabBasis'), '${_goldNisabGrams.toInt()}g ${l10n.translate('gold').toLowerCase()}'),
          if (isEligible) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Share.share(
                    'Zakat Calculation:\n'
                    'Total Wealth: $sym ${_fmt(totalWealth)}\n'
                    'Nisab: $sym ${_fmt(nisab)}\n'
                    'Zakat Due: $sym ${_fmt(zakatDue)}\n\n'
                    'Islamic Companion App',
                  );
                },
                icon: Icon(Icons.share_outlined, size: 16, color: p.accent),
                label: Text(l10n.translate('shareResult'), style: TextStyle(color: p.accent)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: p.divider),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: p.muted)),
          Text(value, style: TextStyle(fontSize: 13, color: p.fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
