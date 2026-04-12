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

class _Entry { final String date, note; final int pages; _Entry(this.date, this.note, this.pages);
  Map<String, dynamic> toJson() => {'date': date, 'note': note, 'pages': pages};
  factory _Entry.fromJson(Map<String, dynamic> j) => _Entry(j['date'] ?? '', j['note'] ?? '', j['pages'] ?? 0); }

class ReadingLogScreen extends StatefulWidget {
  const ReadingLogScreen({super.key});
  @override
  State<ReadingLogScreen> createState() => _ReadingLogScreenState();
}

class _ReadingLogScreenState extends State<ReadingLogScreen> {
  List<_Entry> _entries = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('readingLog');
    if (raw != null) {
      try {
        _entries = (jsonDecode(raw) as List).map((e) => _Entry.fromJson(e)).toList();
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('readingLog', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  int get _totalPages => _entries.fold(0, (s, e) => s + e.pages);
  int get _totalEntries => _entries.length;

  void _add(_P p, AppLocalizations l10n) {
    final pagesCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: p.surface,
      title: Text(l10n.translate('addEntry'), style: TextStyle(color: p.fg, fontSize: 16)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: pagesCtrl, keyboardType: TextInputType.number, style: TextStyle(color: p.fg),
          decoration: InputDecoration(labelText: l10n.translate('pagesRead'), labelStyle: TextStyle(color: p.muted),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.divider)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.accent)))),
        const SizedBox(height: 10),
        TextField(controller: noteCtrl, style: TextStyle(color: p.fg), maxLines: 2,
          decoration: InputDecoration(labelText: l10n.translate('noteOptional'), labelStyle: TextStyle(color: p.muted),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.divider)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.accent)))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.translate('cancel'), style: TextStyle(color: p.muted))),
        TextButton(onPressed: () {
          final pages = int.tryParse(pagesCtrl.text) ?? 0;
          if (pages <= 0) return;
          final now = DateTime.now();
          _entries.insert(0, _Entry('${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}', noteCtrl.text.trim(), pages));
          _save(); setState(() {}); Navigator.pop(ctx);
        }, child: Text(l10n.translate('add'), style: TextStyle(color: p.accent))),
      ],
    )).then((_) { pagesCtrl.dispose(); noteCtrl.dispose(); });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('readingLog'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      floatingActionButton: FloatingActionButton(onPressed: () => _add(p, l10n), backgroundColor: p.accent, child: const Icon(Icons.add, color: Colors.white)),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 80), children: [
        // Stats
        Row(children: [
          _stat('$_totalPages', l10n.translate('pages'), p.gold, p),
          const SizedBox(width: 8),
          _stat('$_totalEntries', l10n.translate('entries'), p.accent, p),
          const SizedBox(width: 8),
          _stat(_totalEntries > 0 ? '${(_totalPages / _totalEntries).round()}' : '0', l10n.translate('avgPages'), p.fg, p),
        ]),
        const SizedBox(height: 16),
        if (_entries.isEmpty) Center(child: Padding(padding: const EdgeInsets.only(top: 40),
          child: Text(l10n.translate('noEntries'), style: TextStyle(color: p.muted, fontSize: 14))))
        else ..._entries.map((e) {
          return Dismissible(
          key: ValueKey('${e.date}-${e.pages}'),
          direction: DismissDirection.endToStart,
          background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.delete_outline, color: Colors.red)),
          onDismissed: (_) { _entries.remove(e); _save(); setState(() {}); },
          child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
            child: Row(children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.12)),
                child: Center(child: Text('${e.pages}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: p.gold)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.date, style: TextStyle(fontSize: 12, color: p.muted)),
                if (e.note.isNotEmpty) Text(e.note, style: TextStyle(fontSize: 13, color: p.fg), maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              Text('${e.pages}p', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.gold)),
            ])),
          );
        }),
      ]),
    );
  }

  Widget _stat(String value, String label, Color color, _P p) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
    child: Column(children: [
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: TextStyle(fontSize: 9, color: p.muted, fontWeight: FontWeight.w600)),
    ]),
  ));
}
