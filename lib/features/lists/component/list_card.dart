import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/tag_component.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';

class ListCardComponent extends StatelessWidget {
  const ListCardComponent({super.key, required this.listWithItem});

  final ShoppingListWithItems listWithItem;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: listWithItem.list.name);
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
      child: Column(
        spacing: AppRadius.sm,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FlatInputTextComponent(
                  controller: controller,
                  isBig: true,
                ),
              ),
              Icon(Icons.more_vert, color: AppColors.gray100),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("Total: ", style: AppTextStyles.body),
                  Text(
                    "R\$ ${listWithItem.totalPrice}",
                    style: AppTextStyles.headline1.copyWith(
                      fontSize: 18,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              TagComponent(
                text:
                    "${listWithItem.totalIsDone}/${listWithItem.items.length}",
                color: AppColors.blue,
              ),
              TagComponent(
                text: listWithItem.list.formatDateDayMonth,
                color: AppColors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
