import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_text_styles.dart';

class InputPopupMenuWidget extends StatelessWidget {
  const InputPopupMenuWidget({
    super.key,
    required this.menuSelect,
    required this.selectedValue,
    this.offset,
  });

  final String selectedValue;
  final Function(String) menuSelect;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onOpened: () => FocusManager.instance.primaryFocus?.unfocus(),
      offset: offset ?? Offset(-8, -8),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(width: 1, color: AppColors.gray300),
      ),
      icon: Row(
        children: [
          Text(
            selectedValue,
            style: AppTextStyles.button.copyWith(color: AppColors.gray100),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
      color: AppColors.gray500,
      onSelected: (value) => {menuSelect(value)},
      itemBuilder: (context) => [
        PopupMenuItem(value: 'un', child: Text('un')),
        PopupMenuItem(value: 'kg', child: Text('kg')),
        PopupMenuItem(value: 'g', child: Text('g')),
      ],
    );
  }
}
