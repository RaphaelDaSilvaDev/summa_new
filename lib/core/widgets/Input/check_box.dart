import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';

class CheckboxComponent extends StatelessWidget {
  const CheckboxComponent({super.key, required this.value, this.onTap});

  final bool value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? AppColors.purple : AppColors.gray500,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: value ? AppColors.purple : AppColors.gray300,
            width: 2,
          ),
        ),
        child: Icon(
          value ? Icons.check : null,
          size: 20,
          color: AppColors.gray100,
        ),
      ),
    );
  }
}
