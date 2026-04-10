// Run: dart pub add image --dev
// Then: dart run tool/generate_icon.dart
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  const size = 1024;
  final image = img.Image(width: size, height: size);

  const bgR = 0x1B, bgG = 0x5E, bgB = 0x20;
  const fgR = 0xD4, fgG = 0xAF, fgB = 0x37;

  final cx = size / 2;
  final cy = size / 2;

  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      final dx = (x - cx);
      final dy = (y - cy);
      final dist = sqrt(dx * dx + dy * dy);

      if (dist > size * 0.48) {
        image.setPixelRgba(x, y, 0, 0, 0, 0);
        continue;
      }

      // Gradient bg
      final t = dist / (size * 0.48);
      final r = (bgR + (20 * (1 - t))).clamp(0, 255).toInt();
      final g = (bgG + (30 * (1 - t))).clamp(0, 255).toInt();
      final b = (bgB + (20 * (1 - t))).clamp(0, 255).toInt();

      // Crescent
      final moonCx = cx - size * 0.05;
      final moonCy = cy - size * 0.08;
      final moonR = size * 0.25;
      final moonDist = sqrt(pow(x - moonCx, 2) + pow(y - moonCy, 2));
      final innerCx = cx + size * 0.05;
      final innerCy = cy - size * 0.1;
      final innerR = size * 0.2;
      final innerDist = sqrt(pow(x - innerCx, 2) + pow(y - innerCy, 2));

      // Star (5-pointed check simplified as circle)
      final starCx = cx + size * 0.15;
      final starCy = cy - size * 0.05;
      final starR = size * 0.045;
      final starDist = sqrt(pow(x - starCx, 2) + pow(y - starCy, 2));

      // Mosque dome
      final domeCy = cy + size * 0.15;
      final domeRx = size * 0.2;
      final domeRy = size * 0.12;
      final domeNorm = pow((x - cx) / domeRx, 2) + pow((y - domeCy) / domeRy, 2);
      final isInDome = domeNorm <= 1.0 && y <= domeCy;

      // Mosque base
      final baseTop = (domeCy).toInt();
      final baseBot = (cy + size * 0.3).toInt();
      final baseLeft = (cx - size * 0.2).toInt();
      final baseRight = (cx + size * 0.2).toInt();
      final isBase = x >= baseLeft && x <= baseRight && y >= baseTop && y <= baseBot;

      // Minarets
      final mW = (size * 0.025).toInt();
      final mTop = (cy + size * 0.02).toInt();
      final mBot = (cy + size * 0.3).toInt();
      final lmX = (cx - size * 0.24).toInt();
      final rmX = (cx + size * 0.24).toInt();
      final isLMin = (x - lmX).abs() < mW && y >= mTop && y <= mBot;
      final isRMin = (x - rmX).abs() < mW && y >= mTop && y <= mBot;

      // Minaret tops (small domes)
      final lmTopDist = sqrt(pow(x - lmX, 2) + pow(y - mTop, 2));
      final rmTopDist = sqrt(pow(x - rmX, 2) + pow(y - mTop, 2));
      final mTopR = size * 0.035;

      bool isFg = false;
      if (moonDist <= moonR && innerDist > innerR) isFg = true;
      if (starDist <= starR) isFg = true;
      if (isInDome) isFg = true;
      if (isBase) isFg = true;
      if (isLMin || isRMin) isFg = true;
      if (lmTopDist <= mTopR || rmTopDist <= mTopR) isFg = true;

      if (isFg) {
        image.setPixelRgba(x, y, fgR, fgG, fgB, 255);
      } else {
        image.setPixelRgba(x, y, r, g, b, 255);
      }
    }
  }

  // Save
  final pngBytes = img.encodePng(image);
  File('assets/icon/app_icon.png').writeAsBytesSync(pngBytes);
  print('Generated app_icon.png (${size}x$size)');

  // Foreground only (for adaptive icon)
  final fg = img.Image(width: size, height: size);
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      final p = image.getPixel(x, y);
      if (p.r == fgR && p.g == fgG && p.b == fgB) {
        fg.setPixelRgba(x, y, fgR, fgG, fgB, 255);
      } else {
        fg.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  File('assets/icon/app_icon_fg.png').writeAsBytesSync(img.encodePng(fg));
  print('Generated app_icon_fg.png');
}
