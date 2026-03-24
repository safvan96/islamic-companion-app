import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _qiblaDirection = 0;
  double _currentHeading = 0;

  // Default location (Istanbul) - in production, use geolocator
  final double _latitude = 41.0082;
  final double _longitude = 28.9784;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _calculateQibla();
  }

  void _calculateQibla() {
    final latRad = _latitude * pi / 180;
    final lngRad = _longitude * pi / 180;
    final kaabaLatRad = AppConstants.kaabaLatitude * pi / 180;
    final kaabaLngRad = AppConstants.kaabaLongitude * pi / 180;

    final dLng = kaabaLngRad - lngRad;
    final y = sin(dLng) * cos(kaabaLatRad);
    final x = cos(latRad) * sin(kaabaLatRad) -
        sin(latRad) * cos(kaabaLatRad) * cos(dLng);

    var bearing = atan2(y, x) * 180 / pi;
    bearing = (bearing + 360) % 360;

    setState(() {
      _qiblaDirection = bearing;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    // The needle should point towards Qibla relative to current heading
    final needleAngle = (_qiblaDirection - _currentHeading) * pi / 180;

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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.navigation,
                            size: 60,
                            color: const Color(0xFF1B5E20),
                          ),
                          const SizedBox(height: 40),
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
                    Text(
                      l10n.translate('qiblaDirection'),
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_qiblaDirection.toStringAsFixed(1)}° ${l10n.translate('degrees')}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B5E20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
