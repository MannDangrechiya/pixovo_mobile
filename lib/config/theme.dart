import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PixovoColors {
  static const primary       = Color(0xFF1A1A2E);  // Deep navy (hero bg)
  static const accent        = Color(0xFFE94560);  // Coral/red CTA buttons
  static const accentOrange  = Color(0xFFFF6B35);  // Orange accent
  static const background    = Color(0xFFF7F7F7);  // Off-white page bg
  static const white         = Color(0xFFFFFFFF);
  static const textDark      = Color(0xFF1A1A2E);
  static const textGrey      = Color(0xFF6B7280);
  static const textLight     = Color(0xFF9CA3AF);
  static const border        = Color(0xFFE5E7EB);
  static const cardBg        = Color(0xFFFFFFFF);
  static const starYellow    = Color(0xFFFBBF24);
  static const successGreen  = Color(0xFF10B981);
  static const errorRed      = Color(0xFFEF4444);
}

class PixovoTypography {
  static const fontFamily    = 'Inter';  // or system default
  static const headlineXL    = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: PixovoColors.white);
  static const headlineLG    = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: PixovoColors.textDark);
  static const headlineMD    = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: PixovoColors.textDark);
  static const bodyLG        = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: PixovoColors.textDark);
  static const bodyMD        = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: PixovoColors.textGrey);
  static const bodySM        = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: PixovoColors.textLight);
  static const buttonText    = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: PixovoColors.white);
  static const labelText     = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: PixovoColors.textDark);
}

class PixovoSpacing {
  static const xs   = 4.0;
  static const sm   = 8.0;
  static const md   = 16.0;
  static const lg   = 24.0;
  static const xl   = 32.0;
  static const xxl  = 48.0;
}

class PixovoRadius {
  static const sm  = BorderRadius.all(Radius.circular(8));
  static const md  = BorderRadius.all(Radius.circular(12));
  static const lg  = BorderRadius.all(Radius.circular(16));
  static const xl  = BorderRadius.all(Radius.circular(24));
  static const full = BorderRadius.all(Radius.circular(999));
}

/// App-wide theming for Pixovo Mobile.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: PixovoColors.primary,
        onPrimary: PixovoColors.white,
        secondary: PixovoColors.accent,
        onSecondary: PixovoColors.white,
        surface: PixovoColors.background,
        onSurface: PixovoColors.textDark,
        error: PixovoColors.errorRed,
        onError: PixovoColors.white,
      ),
      scaffoldBackgroundColor: PixovoColors.background,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: PixovoColors.white,
        foregroundColor: PixovoColors.textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: PixovoColors.textDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: const RoundedRectangleBorder(borderRadius: PixovoRadius.md),
        color: PixovoColors.cardBg,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PixovoColors.accent,           // coral-red
          foregroundColor: PixovoColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          textStyle: PixovoTypography.buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PixovoColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: PixovoColors.primary, width: 1.5),
          textStyle: PixovoTypography.buttonText.copyWith(color: PixovoColors.primary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PixovoColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PixovoColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PixovoColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PixovoColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PixovoColors.errorRed, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          color: PixovoColors.textLight,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: PixovoColors.white,
        selectedItemColor: PixovoColors.primary,
        unselectedItemColor: PixovoColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: PixovoColors.border,
        selectedColor: PixovoColors.primary,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: PixovoColors.textDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: PixovoColors.border,
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: PixovoColors.primary,
        onPrimary: PixovoColors.white,
        secondary: PixovoColors.accent,
        onSecondary: PixovoColors.white,
        surface: PixovoColors.primary, // using primary deep navy as surface in dark mode
        onSurface: PixovoColors.white,
        error: PixovoColors.errorRed,
        onError: PixovoColors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F1A), // darker navy
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: PixovoColors.primary,
        foregroundColor: PixovoColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: PixovoColors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: const RoundedRectangleBorder(borderRadius: PixovoRadius.md),
        color: PixovoColors.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PixovoColors.accent,
          foregroundColor: PixovoColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: PixovoTypography.buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PixovoColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: PixovoColors.white, width: 1.5),
          textStyle: PixovoTypography.buttonText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PixovoColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PixovoColors.textGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PixovoColors.textGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PixovoColors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PixovoColors.errorRed, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          color: PixovoColors.textLight,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: PixovoColors.primary,
        selectedItemColor: PixovoColors.white,
        unselectedItemColor: PixovoColors.textGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: PixovoColors.textDark,
        selectedColor: PixovoColors.accent,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: PixovoColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: PixovoColors.textGrey,
        thickness: 1,
      ),
    );
  }

  static Color get success => PixovoColors.successGreen;
  static Color get warning => PixovoColors.starYellow;
  static Color get error => PixovoColors.errorRed;
  static Color get info => const Color(0xFF45AAF2);
}
