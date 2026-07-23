import 'package:Product_Catalogue_Application/app/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// color: Theme.of(context).colorScheme.primary
class ThemeServiceProvider with ChangeNotifier {
  ThemeServiceProvider({bool isDark = false}) : _isDark = isDark;

  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get lightTheme => _lightThemeData();
  ThemeData get darkTheme => _darkThemeData();
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    Hive.box<bool>('themeMode').put('isDark', _isDark);
    notifyListeners();
  }

  /// **Important**: Don't make colors public
  final Color _primaryColor = const Color.fromARGB(255, 134, 185, 46);
  final Color _secondaryColor = const Color(0xFF7FD0D3);
  final Color _lightSurfaceColor = const Color.fromARGB(255, 208, 207, 207);
  final Color _darkSurfaceColor = const Color.fromRGBO(18, 19, 23, 1);
  final Color _lightBackgroundColor = const Color.fromARGB(255, 208, 207, 207);
  final Color _darkBackgroundColor = const Color.fromRGBO(18, 19, 23, 1);

  final Color _errorColor = const Color(0xFFD32F2F);

  Color get shimmersColor => _primaryColor.withValues(alpha: 0.24);
  Color get shimmerHighlightColor => _secondaryColor.withValues(alpha: 0.2);

  ThemeData _lightThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: _lightBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        onSecondary: Colors.white,
        surface: _lightSurfaceColor,
        error: _errorColor,
      ),
      fontFamily: _fontFamily(),
      elevatedButtonTheme: _elevatedButtonThemeData(isDark: false),
      outlinedButtonTheme: _outlinedButtonThemeData(isDark: false),
      inputDecorationTheme: _inputDecorationTheme(isDark: false),
      appBarTheme: _appBarTheme(),
      iconTheme: _iconThemeData(isDark: false),
    );
  }

  ThemeData _darkThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: _darkBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: _primaryColor,
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        onSecondary: Colors.white,
        surface: _darkSurfaceColor,
        error: _errorColor,
      ),
      fontFamily: _fontFamily(),
      elevatedButtonTheme: _elevatedButtonThemeData(isDark: true),
      outlinedButtonTheme: _outlinedButtonThemeData(isDark: true),
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
      appBarTheme: _appBarTheme(),
      iconTheme: _iconThemeData(isDark: true),
    );
  }

  String? _fontFamily() {
    return GoogleFonts.poppins().fontFamily;
  }

  ElevatedButtonThemeData _elevatedButtonThemeData({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _primaryColor,
        elevation: 0,
        textStyle: buttonPrimary(_primaryColor),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  OutlinedButtonThemeData _outlinedButtonThemeData({required bool isDark}) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? _lightSurfaceColor : _primaryColor,
        backgroundColor: isDark ? _darkSurfaceColor : _lightSurfaceColor,
        elevation: 0,
        textStyle: buttonSecondary(isDark ? _lightSurfaceColor : _primaryColor),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    return InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xffC6DEE0), // Border color when the field is enabled
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xffC6DEE0), // Border color when the field is focused
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _errorColor, // Border color when validation fails
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _errorColor, // Border color when focused but has an error
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xff262D2E), // Default border color
        ),
      ),
      filled: true,
      fillColor: isDark ? _darkSurfaceColor : Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  AppBarTheme _appBarTheme() {
    return AppBarTheme(
      foregroundColor: isDark ? _lightBackgroundColor : _darkBackgroundColor,
      backgroundColor: isDark ? _darkSurfaceColor : _lightSurfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: isDark ? _lightBackgroundColor : _darkBackgroundColor,
      ),
      titleTextStyle: navBarTitle(
        isDark ? _lightBackgroundColor : _darkBackgroundColor,
      ),
    );
  }

  IconThemeData _iconThemeData({required bool isDark}) {
    return IconThemeData(
      color: isDark ? _lightBackgroundColor : _darkBackgroundColor,
    );
  }

  static void setSystemUIOverlayStyle({bool isDark = false}) {
    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }
}
