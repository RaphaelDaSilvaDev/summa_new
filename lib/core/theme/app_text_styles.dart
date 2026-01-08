import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summa/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final headline1 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.gray100,
  );

  static final headline2 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.gray100,
  );

  static final button = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.gray100,
  );

  static final body = GoogleFonts.inter(fontSize: 12, color: AppColors.gray100);
}
