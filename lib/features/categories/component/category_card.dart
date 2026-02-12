import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/constants/app_icons.dart';
import 'package:summa/core/constants/app_special_color.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/Input/input_popup_menu.dart';
import 'package:summa/core/widgets/app_icon.dart';
import 'package:summa/core/widgets/popup_menu.dart';
import 'package:summa/domain/model/categories.dart';
import 'package:summa/features/categories/categories_viewmodel.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key, required this.category});

  final Categories category;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late TextEditingController _nameCategoryController;
  late String _iconController;
  late int _colorController;
  late FocusNode _nameCategoryFocusNode;

  @override
  void initState() {
    super.initState();
    _nameCategoryController = TextEditingController(text: widget.category.name);
    _iconController = widget.category.icon;
    _colorController = widget.category.color;
    _nameCategoryFocusNode = FocusNode();

    _nameCategoryFocusNode.addListener(() {
      if (!_nameCategoryFocusNode.hasFocus) {
        if (_nameCategoryController.text.isNotEmpty) {
          context.read<CategoriesViewmodel>().update(
            id: widget.category.id,
            name: _nameCategoryController.text.trim(),
          );
        } else {
          _nameCategoryController.text = widget.category.name;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameCategoryController.dispose();
    _nameCategoryFocusNode.dispose();
    super.dispose();
  }

  void _menuSelected(String? selected) async {
    switch (selected) {
      case 'remove':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.gray400,
            title: Text('Remover categoria?', style: AppTextStyles.headline2),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                'Essa opção não pode ser desfeita.',
                style: AppTextStyles.body,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancelar",
                  style: AppTextStyles.body.copyWith(color: AppColors.gray100),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "Remover",
                  style: AppTextStyles.body.copyWith(color: AppColors.purple),
                ),
              ),
            ],
          ),
        );

        if (confirm == true && mounted) {
          await context.read<CategoriesViewmodel>().remove(widget.category.id);
        }
        break;
    }
  }

  void _removeAllFocus(BuildContext context) {
    FocusScope.of(context).unfocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  void updateIcon(String value) {
    context.read<CategoriesViewmodel>().update(
      id: widget.category.id,
      icon: _iconController,
    );
  }

  void updateColor(int value) {
    context.read<CategoriesViewmodel>().update(
      id: widget.category.id,
      color: _colorController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
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
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            decoration: BoxDecoration(
              color: AppColors.gray500,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.gray300, width: 2),
            ),
            child: InputPopupMenuWidget<String>(
              menuSelect: (value) => {
                setState(() {
                  _iconController = value;
                }),

                updateIcon(value),
              },
              selectedValue: AppIcon(
                icon: AppIcons.icons[_iconController]!,
                size: 18,
              ),
              items: AppIcons.allKeys.map((key) {
                return PopupMenuItem(
                  value: key,
                  child: Center(
                    child: AppIcon(icon: AppIcons.icons[key]!, size: 18),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(width: 8),

          Expanded(
            child: FlatInputTextComponent(
              controller: _nameCategoryController,
              isBig: true,
              focusNode: _nameCategoryFocusNode,
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            decoration: BoxDecoration(
              color: AppColors.gray500,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.gray300, width: 2),
            ),
            child: InputPopupMenuWidget<int>(
              menuSelect: (value) => {
                setState(() {
                  _colorController = value;
                }),

                updateColor(value),
              },
              selectedValue: CircleAvatar(
                backgroundColor: Color(_colorController),
                maxRadius: 12,
              ),
              items: AppSpecialColor.all.map((item) {
                return PopupMenuItem(
                  value: item.toARGB32(),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Color(item.toARGB32()),
                      maxRadius: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(width: 8),

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
