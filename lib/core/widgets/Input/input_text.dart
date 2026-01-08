import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';

class InputTextComponent extends StatelessWidget {
  const InputTextComponent({
    super.key,
    this.controller,
    this.onClear,
    this.hasClear = false,
    this.label,
  });

  final String? label;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final bool hasClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(label!, style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.xs),
          ],
          TextField(
            controller: controller,
            style: AppTextStyles.button,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.gray500,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                borderSide: BorderSide(color: AppColors.gray300, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                borderSide: BorderSide(color: AppColors.purple, width: 2),
              ),
              hintText: 'Item',
              suffixIcon: hasClear
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      color: AppColors.gray100,
                      onPressed: onClear,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
