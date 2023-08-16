import 'package:flutter/material.dart';

class ScannerTheme {

  ColorScheme lightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF3B6A1D),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFBAF294),
    onPrimaryContainer: Color(0xFF092100),
    secondary: Color(0xFF56624B),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD9E7CA),
    onSecondaryContainer: Color(0xFF141E0D),
    tertiary: Color(0xFF386666),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFBBECEB),
    onTertiaryContainer: Color(0xFF002020),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFDFDF5),
    onBackground: Color(0xFF1A1C18),
    surface: Color(0xFFFDFDF5),
    onSurface: Color(0xFF1A1C18),
    surfaceVariant: Color(0xFFE0E4D6),
    onSurfaceVariant: Color(0xFF43483E),
    outline: Color(0xFF74796D),
    onInverseSurface: Color(0xFFF1F1EA),
    inverseSurface: Color(0xFF2F312C),
    inversePrimary: Color(0xFF9FD67B),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF3B6A1D),
    outlineVariant: Color(0xFFC4C8BB),
    scrim: Color(0xFF000000),
  );

  ColorScheme darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9FD67B),
    onPrimary: Color(0xFF153800),
    primaryContainer: Color(0xFF235103),
    onPrimaryContainer: Color(0xFFBAF294),
    secondary: Color(0xFFBDCBAF),
    onSecondary: Color(0xFF283420),
    secondaryContainer: Color(0xFF3E4A35),
    onSecondaryContainer: Color(0xFFD9E7CA),
    tertiary: Color(0xFFA0CFCF),
    onTertiary: Color(0xFF003737),
    tertiaryContainer: Color(0xFF1E4E4E),
    onTertiaryContainer: Color(0xFFBBECEB),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1A1C18),
    onBackground: Color(0xFFE3E3DC),
    surface: Color(0xFF1A1C18),
    onSurface: Color(0xFFE3E3DC),
    surfaceVariant: Color(0xFF43483E),
    onSurfaceVariant: Color(0xFFC4C8BB),
    outline: Color(0xFF8E9286),
    onInverseSurface: Color(0xFF1A1C18),
    inverseSurface: Color(0xFFE3E3DC),
    inversePrimary: Color(0xFF3B6A1D),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF9FD67B),
    outlineVariant: Color(0xFF43483E),
    scrim: Color(0xFF000000),
  );


  ThemeData lightTheme() {
    return ThemeData(useMaterial3: true, colorScheme: lightColorScheme);
  }
  ThemeData darkTheme(){
    return ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
  }
}
