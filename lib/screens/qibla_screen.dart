import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';
import '../utils/constants.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double _currentHeading = 0;
  bool _hasCompass = false;
  StreamSubscription<CompassEvent>? _compassSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCompass();
    });
  }

  Future<void> _startCompass() async {
    try {
      _compassSub = FlutterCompass.events?.listen((event) {
        if (mounted && event.heading != null) {
          setState(() {
            _currentHeading = event.heading!;
            _hasCompass = true;
          });
        }
      });
    } catch (e) {
      debugPrint('Compass not available: $e');
    }
  }

  @override
  void dispose() {
    _compassSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final prayer = Provider.of<PrayerProvider>(context);

    // Recalculate qibla when city changes
    final lat = prayer.latitude;
    final lng = prayer.longitude;
    final latRad2 = lat * pi / 180;
    final lngRad2 = lng * pi / 180;
    const kLat2 = AppConstants.kaabaLatitude * pi / 180;
    const kLng2 = AppConstants.kaabaLongitude * pi / 180;
    final dLng2 = kLng2 - lngRad2;
    final y2 = sin(dLng2) * cos(kLat2);
    final x2 = cos(latRad2) * sin(kLat2) - sin(latRad2) * cos(kLat2) * cos(dLng2);
    final qiblaDir = (atan2(y2, x2) * 180 / pi + 360) % 360;

    final needleAngle = (qiblaDir - _currentHeading) * pi / 180;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('qibla')),
        backgroundColor: const Color(0xFF0277BD),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D1B2A), const Color(0xFF1B2838)]
                : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kaaba icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mosque,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Compass
              SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Compass background
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? const Color(0xFF1E1E1E)
                            : Colors.white,
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // Direction markers
                    ..._buildDirectionMarkers(isDark),
                    // Qibla needle
                    Transform.rotate(
                      angle: needleAngle,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.navigation,
                            size: 60,
                            color: Color(0xFF1B5E20),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                    // Center dot
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Direction info
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 14,
                            color: isDark ? Colors.white54 : Colors.black38),
                        const SizedBox(width: 4),
                        Text(
                          prayer.locationName,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white54 : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.translate('qiblaDirection'),
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${qiblaDir.toStringAsFixed(1)}° ${l10n.translate('degrees')}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Compass status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _hasCompass
                      ? const Color(0xFF1B5E20).withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _hasCompass ? Icons.explore : Icons.explore_off,
                      size: 14,
                      color: _hasCompass ? const Color(0xFF1B5E20) : Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _hasCompass ? 'Compass active' : 'No compass sensor',
                      style: TextStyle(
                        fontSize: 11,
                        color: _hasCompass ? const Color(0xFF1B5E20) : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  l10n.translate('pointTowards'),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDirectionMarkers(bool isDark) {
    final directions = ['N', 'E', 'S', 'W'];
    final angles = [0.0, 90.0, 180.0, 270.0];
    final color = isDark ? Colors.white70 : Colors.black54;

    return List.generate(4, (i) {
      return Transform.rotate(
        angle: angles[i] * pi / 180,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Transform.rotate(
              angle: -angles[i] * pi / 180,
              child: Text(
                directions[i],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: directions[i] == 'N'
                      ? Colors.red
                      : color,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
