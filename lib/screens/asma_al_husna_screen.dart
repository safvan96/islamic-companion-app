import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/asma_al_husna_model.dart';
import '../providers/app_provider.dart';

class AsmaAlHusnaScreen extends StatefulWidget {
  const AsmaAlHusnaScreen({super.key});

  @override
  State<AsmaAlHusnaScreen> createState() => _AsmaAlHusnaScreenState();
}

class _AsmaAlHusnaScreenState extends State<AsmaAlHusnaScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final langCode = Provider.of<AppProvider>(context).locale.languageCode;

    final filteredNames = AsmaAlHusnaModel.names.where((name) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return name.transliteration.toLowerCase().contains(query) ||
          name.arabic.contains(query) ||
          (name.meanings[langCode] ?? name.meanings['en']!)
              .toLowerCase()
              .contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('99 Asma Al-Husna'),
        backgroundColor: const Color(0xFF4A148C),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search,
                    color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A0A2E), const Color(0xFF121212)]
                : [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filteredNames.length,
          itemBuilder: (context, index) {
            final name = filteredNames[index];
            final meaning =
                name.meanings[langCode] ?? name.meanings['en']!;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4A148C),
                        const Color(0xFF7B1FA2),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name.number.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  name.arabic,
                  style: TextStyle(
                    fontSize: 24,
                    color: isDark
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF4A148C),
                    fontWeight: FontWeight.w500,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      name.transliteration,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meaning,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.black54,
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
