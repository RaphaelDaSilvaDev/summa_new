import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summa/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final textTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.gray900,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        brightness: Brightness.dark,
      ),
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.gray500,
      canvasColor: AppColors.gray500,
    );
  }
}
