import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';

class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({
    super.key,
    required this.menuSelect,
    required this.menuItems,
    this.onOpened,
  });

  final Function(String) menuSelect;
  final List<PopupMenuItem<String>> menuItems;
  final Function()? onOpened;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      onOpened: onOpened,
      constraints: const BoxConstraints(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(width: 1, color: AppColors.gray300),
      ),
      icon: Icon(Icons.more_vert, color: AppColors.gray100),
      color: AppColors.gray500,
      onSelected: (value) => menuSelect(value),
      itemBuilder: (context) => [...menuItems],
    );
  }
}
