import 'package:flutter/material.dart';

class AppColors {
  // Spotify Theme (Default)
  static const spotifyBackground = Color(0xFF000000);
  static const spotifyCardBackground = Color(0xFF181818);
  static const spotifyPrimary = Color(0xFF1db954);
  static const spotifySecondary = Color(0xFF282828);
  static const spotifyMutedText = Color(0xFFb3b3b3);
  static const spotifyForeground = Color(0xFFffffff);

  // Purple Theme
  static const purpleBackground = Color(0xFF0a0014);
  static const purpleCardBackground = Color(0xFF1a0a2e);
  static const purplePrimary = Color(0xFF9d4edd);
  static const purpleSecondary = Color(0xFF240046);
  static const purpleMutedText = Color(0xFFc77dff);
  static const purpleAccent = Color(0xFFe0aaff);

  // Blue Theme
  static const blueBackground = Color(0xFF001219);
  static const blueCardBackground = Color(0xFF0a1929);
  static const bluePrimary = Color(0xFF00b4d8);
  static const blueSecondary = Color(0xFF023e8a);
  static const blueMutedText = Color(0xFF90e0ef);
  static const blueAccent = Color(0xFF48cae4);

  // Orange Theme
  static const orangeBackground = Color(0xFF1a0f00);
  static const orangeCardBackground = Color(0xFF2d1b00);
  static const orangePrimary = Color(0xFFff9500);
  static const orangeSecondary = Color(0xFF4a2800);
  static const orangeMutedText = Color(0xFFffb84d);
  static const orangeAccent = Color(0xFFffb84d);
}

enum ThemeVariant { spotify, purple, blue, orange }

ThemeData createCustomTheme(ThemeVariant variant) {
  Color bgN, cardBg, primary, secondary, muted, foreground;

  switch (variant) {
    case ThemeVariant.spotify:
      bgN = AppColors.spotifyBackground;
      cardBg = AppColors.spotifyCardBackground;
      primary = AppColors.spotifyPrimary;
      secondary = AppColors.spotifySecondary;
      muted = AppColors.spotifyMutedText;
      foreground = AppColors.spotifyForeground;
      break;
    case ThemeVariant.purple:
      bgN = AppColors.purpleBackground;
      cardBg = AppColors.purpleCardBackground;
      primary = AppColors.purplePrimary;
      secondary = AppColors.purpleSecondary;
      muted = AppColors.purpleMutedText;
      foreground = AppColors.purpleAccent;
      break;
    case ThemeVariant.blue:
      bgN = AppColors.blueBackground;
      cardBg = AppColors.blueCardBackground;
      primary = AppColors.bluePrimary;
      secondary = AppColors.blueSecondary;
      muted = AppColors.blueMutedText;
      foreground = AppColors.blueAccent;
      break;
    case ThemeVariant.orange:
      bgN = AppColors.orangeBackground;
      cardBg = AppColors.orangeCardBackground;
      primary = AppColors.orangePrimary;
      secondary = AppColors.orangeSecondary;
      muted = AppColors.orangeMutedText;
      foreground = AppColors.orangeAccent;
      break;
  }

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgN,
    canvasColor: bgN,
    colorScheme: ColorScheme.dark(
      background: bgN,
      surface: cardBg,
      primary: primary,
      secondary: secondary,
      onBackground: foreground,
      onSurface: foreground,
      onPrimary: bgN,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: foreground),
      titleTextStyle: TextStyle(
        color: foreground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: foreground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: foreground,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: muted,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
    ),
  );
}
