import 'package:flutter/material.dart';

/// ثيمات التطبيق
class AppTheme {
  // ثيم الفاتح (الغروب الدافئ)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFFB8704F), // برتقالي دافئ
        primaryContainer: const Color(0xFFFFEADD), // برتقالي فاتح
        secondary: const Color(0xFF8B5A2B), // بني
        secondaryContainer: const Color(0xFFF5DEC8), // كريمي
        surface: const Color(0xFFFFFBF5), // خلفية فاتحة
        surfaceVariant: const Color(0xFFE8E0D5), // سطح متغير
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF2C241A), // نص داكن
        onSurfaceVariant: const Color(0xFF524538),
        outline: const Color(0xFF8B7355),
        shadow: Colors.black12,
        error: const Color(0xFFBA1A1A),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFBF5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFB8704F),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFFFFFFFF),
        surfaceTintColor: const Color(0xFFB8704F),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB8704F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFB8704F),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: Color(0xFFB8704F)),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFB8704F),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB8704F), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Color(0xFF9E9E9E),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        titleMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        titleSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: Color(0xFF2C241A),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Color(0xFF2C241A),
        ),
        bodySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          color: Color(0xFF524538),
        ),
        labelLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Color(0xFFB8704F),
        ),
        labelMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          color: Color(0xFFB8704F),
        ),
        labelSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 10,
          color: Color(0xFFB8704F),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFB8704F),
        size: 24,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.white,
        textColor: const Color(0xFF2C241A),
        iconColor: const Color(0xFFB8704F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        selectedItemColor: Color(0xFFB8704F),
        unselectedItemColor: Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFB8704F),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Color(0xFFFFFFFF),
        surfaceTintColor: Color(0xFFB8704F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C241A),
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: Color(0xFF2C241A),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        textStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Color(0xFF2C241A),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF2C241A),
        contentTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Colors.white,
        ),
        actionTextColor: Color(0xFFB8704F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFFB8704F),
        linearTrackColor: Color(0xFFE8E0D5),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.selected) 
              ? const Color(0xFFB8704F) 
              : Colors.white,
        ),
        trackColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.selected) 
              ? const Color(0xFFB8704F).withOpacity(0.5) 
              : const Color(0xFFE0E0E0),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.selected) 
              ? const Color(0xFFB8704F) 
              : Colors.white,
        ),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.selected) 
              ? const Color(0xFFB8704F) 
              : Colors.white,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Color(0xFFB8704F),
        unselectedLabelColor: Color(0xFF9E9E9E),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Color(0xFFB8704F), width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
        ),
      ),
    );
  }

  // ثيم الداكن (الهدوء الطبيعي)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF6BA88A), // أخضر مريح
        primaryContainer: const Color(0xFF2D5A4A),
        secondary: const Color(0xFF4A7C59),
        secondaryContainer: const Color(0xFF1E3A2E),
        surface: const Color(0xFF121212),
        surfaceVariant: const Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFFE0E0E0), // نص فاتح
        onSurfaceVariant: const Color(0xFFB0B0B0),
        outline: const Color(0xFF6BA88A),
        shadow: Colors.black45,
        error: const Color(0xFFCF6679),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0E0E0E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D5A4A),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        surfaceTintColor: const Color(0xFF6BA88A),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6BA88A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6BA88A), width: 2),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Color(0xFF9E9E9E),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFFE0E0E0),
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFFE0E0E0),
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: Color(0xFFE0E0E0),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Color(0xFFE0E0E0),
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFFE0E0E0),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF6BA88A),
        size: 24,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: const Color(0xFF1E1E1E),
        textColor: const Color(0xFFE0E0E0),
        iconColor: const Color(0xFF6BA88A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFF6BA88A),
        unselectedItemColor: Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF6BA88A),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Color(0xFF1E1E1E),
        surfaceTintColor: Color(0xFF6BA88A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3A3A),
        thickness: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF2D5A4A),
        contentTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Colors.white,
        ),
        actionTextColor: Color(0xFF6BA88A),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF6BA88A),
        linearTrackColor: Color(0xFF2D5A4A),
      ),
    );
  }

  // ثيم السماء الهادئة
  static ThemeData get calmSkyTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF4A90E2), // أزرق لطيف
        primaryContainer: const Color(0xFFE6F3FF),
        secondary: const Color(0xFF2E5BBA),
        secondaryContainer: const Color(0xFFE6F0FF),
        surface: const Color(0xFFF8F9FF),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A1A2E),
        outline: const Color(0xFF4A90E2),
        shadow: Colors.black12,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        surfaceTintColor: const Color(0xFF4A90E2),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: Color(0xFF1A1A2E),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  // الحصول على الثيم حسب الاسم
  static ThemeData getThemeByName(String themeName) {
    switch (themeName) {
      case 'natural_calm':
        return darkTheme;
      case 'calm_sky':
        return calmSkyTheme;
      default:
        return lightTheme;
    }
  }
}
