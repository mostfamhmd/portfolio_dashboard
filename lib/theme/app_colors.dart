import 'package:flutter/material.dart';

class AppColors {
  // Primary Gradient - Purple to Blue
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Secondary Gradient - Pink to Orange
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Accent Gradient - Blue to Cyan
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Success Gradient
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF667eea);
  static const Color lightSecondary = Color(0xFFf5576c);
  static const Color lightAccent = Color(0xFF4facfe);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F0F1E);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkPrimary = Color(0xFF8B7FFF);
  static const Color darkSecondary = Color(0xFFFF6B9D);
  static const Color darkAccent = Color(0xFF6BC8FF);

  // Text Colors
  static const Color lightText = Color(0xFF2D3748);
  static const Color darkText = Color(0xFFE2E8F0);
  static const Color lightTextSecondary = Color(0xFF718096);
  static const Color darkTextSecondary = Color(0xFFA0AEC0);

  // Semantic Colors
  static const Color success = Color(0xFF38ef7d);
  static const Color error = Color(0xFFf5576c);
  static const Color warning = Color(0xFFffa502);
  static const Color info = Color(0xFF4facfe);

  // Glassmorphism
  static Color glassSurface(bool isDark) {
    return isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.7);
  }

  static Color glassBorder(bool isDark) {
    return isDark
        ? Colors.white.withOpacity(0.2)
        : Colors.white.withOpacity(0.3);
  }
}
