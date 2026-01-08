import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/tag_component.dart';

class ListCardComponent extends StatelessWidget {
  const ListCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: "Arroz");
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
                    "R\$ 0,00",
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              TagComponent(text: "0/5", color: AppColors.blue),
              TagComponent(text: "14/01", color: AppColors.green),
            ],
          ),
        ],
      ),
    );
  }
}
