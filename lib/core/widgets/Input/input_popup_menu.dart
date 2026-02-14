import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';

class InputPopupMenuWidget<T> extends StatelessWidget {
  const InputPopupMenuWidget({
    super.key,
    required this.menuSelect,
    required this.selectedValue,
    this.offset,
    required this.items,
  });

  final Widget selectedValue;
  final ValueChanged<T> menuSelect;
  final Offset? offset;
  final List<PopupMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onOpened: () => FocusManager.instance.primaryFocus?.unfocus(),
      offset: offset ?? Offset(-8, -8),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: 10,
        maxHeight: MediaQuery.of(context).size.height * 0.32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(width: 2, color: AppColors.gray300),
      ),
      icon: Row(
        children: [selectedValue, const Icon(Icons.keyboard_arrow_down)],
      ),
      color: AppColors.gray500,
      onSelected: (value) => {menuSelect(value)},
      itemBuilder: (context) => items,
    );
  }
}
