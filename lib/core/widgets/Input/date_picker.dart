import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';

class DatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    return await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.purple,
              onPrimary: AppColors.gray100,
              surface: AppColors.gray400,
              onSecondary: AppColors.gray100,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.purple),
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.gray500),
          ),
          child: child!,
        );
      },
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2060),
    );
  }
}
