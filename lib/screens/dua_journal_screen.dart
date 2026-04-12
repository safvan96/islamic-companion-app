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

class _DuaEntry {
  String text;
  String date;
  bool answered;
  String? answerDate;
  _DuaEntry({required this.text, required this.date, this.answered = false, this.answerDate});
  Map<String, dynamic> toJson() => {'text': text, 'date': date, 'answered': answered, 'answerDate': answerDate};
  factory _DuaEntry.fromJson(Map<String, dynamic> j) => _DuaEntry(
    text: j['text'] ?? '', date: j['date'] ?? '', answered: j['answered'] ?? false, answerDate: j['answerDate'],
  );
}

class DuaJournalScreen extends StatefulWidget {
  const DuaJournalScreen({super.key});
  @override
  State<DuaJournalScreen> createState() => _DuaJournalScreenState();
}

class _DuaJournalScreenState extends State<DuaJournalScreen> {
  List<_DuaEntry> _entries = [];
  int _filter = 0; // 0=all, 1=pending, 2=answered

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('duaJournal');
    if (raw != null) {
      try {
        _entries = (jsonDecode(raw) as List).map((e) => _DuaEntry.fromJson(e)).toList();
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('duaJournal', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  List<_DuaEntry> get _filtered {
    if (_filter == 1) return _entries.where((e) => !e.answered).toList();
    if (_filter == 2) return _entries.where((e) => e.answered).toList();
    return _entries;
  }

  void _addEntry(_P p, AppLocalizations l10n) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surface,
        title: Text(l10n.translate('newDua'), style: TextStyle(color: p.fg, fontSize: 16)),
        content: TextField(
          controller: ctrl, maxLines: 4, autofocus: true,
          style: TextStyle(color: p.fg, fontSize: 14),
          decoration: InputDecoration(
            hintText: l10n.translate('writeDua'),
            hintStyle: TextStyle(color: p.muted),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: p.divider), borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: p.accent), borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.translate('cancel'), style: TextStyle(color: p.muted))),
          TextButton(onPressed: () {
            if (ctrl.text.trim().isEmpty) return;
            final now = DateTime.now();
            _entries.insert(0, _DuaEntry(
              text: ctrl.text.trim(),
              date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
            ));
            _save();
            setState(() {});
            Navigator.pop(ctx);
          }, child: Text(l10n.translate('add'), style: TextStyle(color: p.accent))),
        ],
      ),
    ).then((_) => ctrl.dispose());
  }

  void _markAnswered(int index) {
    final now = DateTime.now();
    setState(() {
      _entries[index].answered = true;
      _entries[index].answerDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final entries = _filtered;
    final answeredCount = _entries.where((e) => e.answered).length;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('duaJournal'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEntry(p, l10n),
        backgroundColor: p.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              // Stats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
                child: Row(children: [
                  Expanded(child: Column(children: [
                    Text('${_entries.length}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: p.fg)),
                    Text(l10n.translate('totalDuas'), style: TextStyle(fontSize: 9, color: p.muted, fontWeight: FontWeight.w600)),
                  ])),
                  Container(width: 1, height: 30, color: p.divider),
                  Expanded(child: Column(children: [
                    Text('${_entries.length - answeredCount}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: p.accent)),
                    Text(l10n.translate('pending'), style: TextStyle(fontSize: 9, color: p.muted, fontWeight: FontWeight.w600)),
                  ])),
                  Container(width: 1, height: 30, color: p.divider),
                  Expanded(child: Column(children: [
                    Text('$answeredCount', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: p.gold)),
                    Text(l10n.translate('answered'), style: TextStyle(fontSize: 9, color: p.muted, fontWeight: FontWeight.w600)),
                  ])),
                ]),
              ),
              const SizedBox(height: 12),
              // Filter
              Row(children: [
                _Chip(l10n.translate('allNames'), _filter == 0, p.accent, p, () => setState(() => _filter = 0)),
                const SizedBox(width: 6),
                _Chip(l10n.translate('pending'), _filter == 1, p.accent, p, () => setState(() => _filter = 1)),
                const SizedBox(width: 6),
                _Chip(l10n.translate('answered'), _filter == 2, p.gold, p, () => setState(() => _filter = 2)),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: entries.isEmpty
                ? Center(child: Text(l10n.translate('noDuasYet'), style: TextStyle(color: p.muted)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    itemCount: entries.length,
                    itemBuilder: (context, i) {
                      final e = entries[i];
                      final realIndex = _entries.indexOf(e);
                      return Dismissible(
                        key: ValueKey('${e.date}-${e.text.hashCode}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                        onDismissed: (_) { _entries.removeAt(realIndex); _save(); setState(() {}); },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: e.answered ? p.gold.withOpacity(0.06) : p.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: e.answered ? p.gold.withOpacity(0.3) : p.divider),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Icon(e.answered ? Icons.check_circle : Icons.radio_button_unchecked, size: 16, color: e.answered ? p.gold : p.muted),
                              const SizedBox(width: 8),
                              Text(e.date, style: TextStyle(fontSize: 11, color: p.muted)),
                              if (e.answered && e.answerDate != null) ...[
                                const SizedBox(width: 8),
                                Text('→ ${e.answerDate}', style: TextStyle(fontSize: 11, color: p.gold)),
                              ],
                              const Spacer(),
                              if (!e.answered)
                                GestureDetector(
                                  onTap: () => _markAnswered(realIndex),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(color: p.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                    child: Text(l10n.translate('markAnswered'), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: p.gold)),
                                  ),
                                ),
                            ]),
                            const SizedBox(height: 10),
                            Text(e.text, style: TextStyle(fontSize: 14, color: p.fg, height: 1.5)),
                          ]),
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

class _Chip extends StatelessWidget {
  final String label; final bool active; final Color color; final _P p; final VoidCallback onTap;
  const _Chip(this.label, this.active, this.color, this.p, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: active ? color.withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(6), border: Border.all(color: active ? color : p.divider)),
    child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: active ? color : p.muted)),
  ));
}
