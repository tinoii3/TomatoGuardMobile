import 'package:flutter/material.dart';

class AppColors {
  // Helper สำหรับแปลงค่า HSL แบบเดียวกับใน CSS
  // h = 0-360, s = 0-100, l = 0-100
  static Color hsl(double h, double s, double l, [double a = 1.0]) {
    return HSLColor.fromAHSL(a, h, s / 100, l / 100).toColor();
  }

  // --- Light Mode Palette (ตาม CSS :root) ---
  static final background = hsl(120, 20, 97);
  static final primary = hsl(152, 55, 35);
  static final card = hsl(0, 0, 100);
  static final destructive = hsl(0, 75, 55); // Tomato red
  static final warning = hsl(35, 95, 55);
  static final success = hsl(145, 65, 40);

  // --- Gradients ---
  static final gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      hsl(152, 55, 35), // --primary start
      hsl(100, 50, 45), // --accent end
    ],
  );

  static final gradientHero = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [hsl(140, 30, 92), hsl(120, 20, 97)],
  );
}
