import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/popup_menu.dart';
import 'package:summa/domain/model/categories.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key, required this.category});

  final Categories category;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late TextEditingController _nameCategoryController;
  late FocusNode _nameCategoryFocusNode;

  @override
  void initState() {
    super.initState();
    _nameCategoryController = TextEditingController(text: widget.category.name);
    _nameCategoryFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameCategoryController.dispose();
    _nameCategoryFocusNode.dispose();
    super.dispose();
  }

  void _menuSelected(String? selected) async {}

  void _removeAllFocus(BuildContext context) {
    FocusScope.of(context).unfocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray400,
        border: Border.all(width: 2, color: AppColors.gray300),
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FlatInputTextComponent(
              controller: _nameCategoryController,
              isBig: true,
              focusNode: _nameCategoryFocusNode,
            ),
          ),
          SizedBox(
            width: 24,
            child: PopupMenuWidget(
              menuSelect: _menuSelected,
              onOpened: () => _removeAllFocus(context),
              menuItems: [
                PopupMenuItem(
                  value: 'remove',
                  child: Text("Remover", style: AppTextStyles.button),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
