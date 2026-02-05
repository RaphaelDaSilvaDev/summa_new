import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.onChanged,
    this.autoFocus = false,
    this.readOnly = false,
    this.onTap,
    this.hintText,
    this.focusNode,
    this.inputFormatters,
    this.textInputType,
    this.onSubmitted,
    this.errorText,
  });

  final String? label;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final Function(String)? onChanged;
  final bool hasClear;
  final bool autoFocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? hintText;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final Function(String)? onSubmitted;
  final String? errorText;

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
            onChanged: onChanged,
            controller: controller,
            autofocus: autoFocus,
            readOnly: readOnly,
            onTap: onTap,
            focusNode: focusNode,
            keyboardType: textInputType,
            style: AppTextStyles.button,
            inputFormatters: inputFormatters,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.gray500,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                borderSide: BorderSide(
                  color: errorText?.isNotEmpty == true
                      ? AppColors.red
                      : AppColors.gray300,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                borderSide: BorderSide(
                  color: errorText?.isNotEmpty == true
                      ? AppColors.red
                      : AppColors.purple,
                  width: 2,
                ),
              ),
              hintText: hintText,
              hintStyle: AppTextStyles.hintText,
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
