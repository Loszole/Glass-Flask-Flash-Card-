import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color slate = Color(0xFF6C7A98);
  static const Color slateDeep = Color(0xFF4D5B79);
  static const Color ink = Color(0xFF15233D);
  static const Color accent = Color(0xFF9EB8FF);
  static const Color aqua = Color(0xFF98E7F5);
  static const Color midnight = Color(0xFF0D1527);
  static const Color midnightSoft = Color(0xFF14203A);
  static const Color mist = Color(0xFFE6EDFF);

  static ThemeData light() {
    return _buildTheme(
      brightness: Brightness.light,
      scaffoldBackgroundColor: slate,
      primary: slateDeep,
      secondary: aqua,
      surface: Colors.white,
      onSurface: ink,
      onSurfaceVariant: ink.withValues(alpha: 0.72),
      outline: Colors.white.withValues(alpha: 0.34),
      outlineVariant: Colors.white.withValues(alpha: 0.22),
      shadow: ink,
      titleColor: ink,
      bodyColor: ink,
      appBarForeground: Colors.white,
      dialogBackground: Colors.white.withValues(alpha: 0.94),
      inputFill: Colors.white.withValues(alpha: 0.58),
      inputHint: ink.withValues(alpha: 0.5),
      filledButtonBackground: slateDeep,
      outlinedForeground: Colors.white,
      outlinedBackground: Colors.white.withValues(alpha: 0.08),
      floatingBackground: Colors.white.withValues(alpha: 0.18),
      iconColor: Colors.white,
    );
  }

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnight,
      primary: accent,
      secondary: aqua,
      surface: midnightSoft,
      onSurface: mist,
      onSurfaceVariant: mist.withValues(alpha: 0.72),
      outline: Colors.white.withValues(alpha: 0.18),
      outlineVariant: Colors.white.withValues(alpha: 0.12),
      shadow: Colors.black,
      titleColor: mist,
      bodyColor: mist.withValues(alpha: 0.92),
      appBarForeground: mist,
      dialogBackground: midnightSoft.withValues(alpha: 0.94),
      inputFill: Colors.white.withValues(alpha: 0.08),
      inputHint: mist.withValues(alpha: 0.42),
      filledButtonBackground: accent.withValues(alpha: 0.9),
      outlinedForeground: mist,
      outlinedBackground: Colors.white.withValues(alpha: 0.04),
      floatingBackground: Colors.white.withValues(alpha: 0.1),
      iconColor: mist,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffoldBackgroundColor,
    required Color primary,
    required Color secondary,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color outline,
    required Color outlineVariant,
    required Color shadow,
    required Color titleColor,
    required Color bodyColor,
    required Color appBarForeground,
    required Color dialogBackground,
    required Color inputFill,
    required Color inputHint,
    required Color filledButtonBackground,
    required Color outlinedForeground,
    required Color outlinedBackground,
    required Color floatingBackground,
    required Color iconColor,
  }) {
    final base = ThemeData(useMaterial3: true, brightness: brightness);
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      secondary: secondary,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
    );

    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: appBarForeground,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: titleColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: titleColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: titleColor,
      ),
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: outlineVariant),
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: appBarForeground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: appBarForeground,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: dialogBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        hintStyle: textTheme.bodyMedium?.copyWith(color: inputHint),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            color: aqua.withValues(alpha: 0.92),
            width: 1.6,
          ),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFFB33A4B), width: 1.3),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFFB33A4B), width: 1.3),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: filledButtonBackground,
          foregroundColor: brightness == Brightness.dark ? midnight : Colors.white,
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: outlinedForeground,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: outlinedBackground,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: floatingBackground,
        foregroundColor: appBarForeground,
        elevation: 0,
        extendedTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      iconTheme: IconThemeData(color: iconColor),
    );
  }
}