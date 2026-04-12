import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class _Donation {
  final double amount;
  final String category;
  final String date;
  final String note;
  _Donation({required this.amount, required this.category, required this.date, this.note = ''});
  Map<String, dynamic> toJson() => {'amount': amount, 'category': category, 'date': date, 'note': note};
  factory _Donation.fromJson(Map<String, dynamic> j) => _Donation(
    amount: (j['amount'] as num).toDouble(), category: j['category'] ?? '', date: j['date'] ?? '', note: j['note'] ?? '',
  );
}

class CharityScreen extends StatefulWidget {
  const CharityScreen({super.key});
  @override
  State<CharityScreen> createState() => _CharityScreenState();
}

class _CharityScreenState extends State<CharityScreen> {
  List<_Donation> _donations = [];
  double _goal = 0;

  static const _categories = ['sadaqah', 'zakat', 'fitrah', 'qurbani', 'other'];
  static const _catIcons = {
    'sadaqah': Icons.favorite, 'zakat': Icons.account_balance,
    'fitrah': Icons.restaurant, 'qurbani': Icons.pets, 'other': Icons.more_horiz,
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('charityDonations');
    if (raw != null) {
      try {
        _donations = (jsonDecode(raw) as List).map((e) => _Donation.fromJson(e)).toList();
      } catch (_) {}
    }
    _goal = prefs.getDouble('charityGoal') ?? 0;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('charityDonations', jsonEncode(_donations.map((d) => d.toJson()).toList()));
    await prefs.setDouble('charityGoal', _goal);
  }

  double get _totalAmount => _donations.fold(0, (s, d) => s + d.amount);
  double get _thisMonthAmount {
    final now = DateTime.now();
    final prefix = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return _donations.where((d) => d.date.startsWith(prefix)).fold(0, (s, d) => s + d.amount);
  }

  void _addDonation(_P p, AppLocalizations l10n) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String cat = 'sadaqah';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: p.surface,
          title: Text(l10n.translate('addDonation'), style: TextStyle(color: p.fg, fontSize: 16)),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: p.fg, fontSize: 20),
              decoration: InputDecoration(labelText: l10n.translate('amount'), labelStyle: TextStyle(color: p.muted),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.divider)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.accent))),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 6, children: _categories.map((c) {
              final active = c == cat;
              return ChoiceChip(
                label: Text(l10n.translate(c)), selected: active,
                onSelected: (_) => setD(() => cat = c),
                selectedColor: p.accent, backgroundColor: p.bg,
                side: BorderSide(color: p.divider),
                labelStyle: TextStyle(color: active ? Colors.white : p.fg, fontSize: 12),
                showCheckmark: false,
              );
            }).toList()),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl, style: TextStyle(color: p.fg),
              decoration: InputDecoration(labelText: l10n.translate('noteOptional'), labelStyle: TextStyle(color: p.muted),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.divider)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.accent))),
            ),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.translate('cancel'), style: TextStyle(color: p.muted))),
            TextButton(onPressed: () {
              final amount = double.tryParse(amountCtrl.text.trim()) ?? 0;
              if (amount <= 0) return;
              final now = DateTime.now();
              final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
              _donations.insert(0, _Donation(amount: amount, category: cat, date: date, note: noteCtrl.text.trim()));
              _save();
              setState(() {});
              Navigator.pop(ctx);
            }, child: Text(l10n.translate('add'), style: TextStyle(color: p.accent))),
          ],
        ),
      ),
    ).then((_) { amountCtrl.dispose(); noteCtrl.dispose(); });
  }

  void _setGoal(_P p, AppLocalizations l10n) {
    final ctrl = TextEditingController(text: _goal > 0 ? _goal.toStringAsFixed(0) : '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surface,
        title: Text(l10n.translate('setGoal'), style: TextStyle(color: p.fg, fontSize: 16)),
        content: TextField(
          controller: ctrl, keyboardType: TextInputType.number, autofocus: true,
          style: TextStyle(color: p.fg, fontSize: 20),
          decoration: InputDecoration(labelText: l10n.translate('yearlyGoal'), labelStyle: TextStyle(color: p.muted),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.divider)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.accent))),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.translate('cancel'), style: TextStyle(color: p.muted))),
          TextButton(onPressed: () {
            _goal = double.tryParse(ctrl.text.trim()) ?? 0;
            _save();
            setState(() {});
            Navigator.pop(ctx);
          }, child: Text(l10n.translate('save'), style: TextStyle(color: p.accent))),
        ],
      ),
    ).then((_) => ctrl.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final total = _totalAmount;
    final monthly = _thisMonthAmount;
    final goalProgress = _goal > 0 ? (total / _goal).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('charityTracker'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.flag_outlined, color: p.muted, size: 20), onPressed: () => _setGoal(p, l10n)),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDonation(p, l10n),
        backgroundColor: p.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.divider)),
            child: Column(children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l10n.translate('totalDonated').toUpperCase(), style: TextStyle(fontSize: 9, color: p.muted, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(_fmt(total), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: p.gold)),
                ])),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(l10n.translate('thisMonth').toUpperCase(), style: TextStyle(fontSize: 9, color: p.muted, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(_fmt(monthly), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: p.accent)),
                ])),
              ]),
              if (_goal > 0) ...[
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(l10n.translate('yearlyGoal'), style: TextStyle(fontSize: 10, color: p.muted)),
                  Text('${(goalProgress * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 10, color: p.accent, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(value: goalProgress, minHeight: 5, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(p.gold)),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 20),
          // Donations list
          if (_donations.isEmpty)
            Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(l10n.translate('noDonations'), style: TextStyle(color: p.muted, fontSize: 14)),
            ))
          else
            ...List.generate(_donations.length, (i) {
              final d = _donations[i];
              final icon = _catIcons[d.category] ?? Icons.favorite;
              return Dismissible(
                key: ValueKey('$i-${d.date}-${d.amount}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                onDismissed: (_) {
                  _donations.removeAt(i);
                  _save();
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.12)),
                      child: Icon(icon, size: 18, color: p.gold),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l10n.translate(d.category), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
                      if (d.note.isNotEmpty)
                        Text(d.note, style: TextStyle(fontSize: 11, color: p.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(d.date, style: TextStyle(fontSize: 10, color: p.muted)),
                    ])),
                    Text(_fmt(d.amount), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: p.gold)),
                  ]),
                ),
              );
            }),
        ],
      ),
    );
  }

  String _fmt(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toStringAsFixed(n == n.roundToDouble() ? 0 : 2);
  }
}
