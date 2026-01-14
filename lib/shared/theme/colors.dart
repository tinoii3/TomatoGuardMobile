import 'package:flutter/material.dart';

class AppColors {
  // h = 0-360, s = 0-100, l = 0-100
  static Color hsl(double h, double s, double l, [double a = 1.0]) {
    return HSLColor.fromAHSL(a, h, s / 100, l / 100).toColor();
  }

  static final background = hsl(120, 20, 97);
  static final primary = hsl(152, 55, 35);
  static final card = hsl(0, 0, 100);
  static final destructive = hsl(0, 75, 55);
  static final warning = hsl(35, 95, 55);
  static final success = hsl(145, 65, 40);
  static final backgroundSecondary = Colors.white.withOpacity(0.95);

  // --- Gradients ---
  static final gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [hsl(152, 55, 35), hsl(100, 50, 45)],
  );

  static final gradientHero = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [hsl(140, 30, 92), hsl(120, 20, 97)],
  );
}
