import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/theme/app_theme.dart';
import 'package:summa/core/widgets/Input/check_box.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/Input/quantity_unit.dart';
import 'package:summa/data/repository/shopping_list_repository_impl.dart';
import 'package:summa/features/lists/list_page.dart';
import 'package:summa/features/lists/shopping_list_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShoppingListViewmodel(ShoppingListRepositoryImpl()),
      child: const SummaApp(),
    ),
  );
}

class SummaApp extends StatelessWidget {
  const SummaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Summa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: ListPage(),
      ),
    );
  }
}

class ItemCardComponent extends StatelessWidget {
  const ItemCardComponent({
    super.key,
    required this.cents,
    required this.quantity,
    required this.unit,
    required this.isChecked,
    required this.controller,
  });

  final int cents;
  final double quantity;
  final String unit;
  final bool? isChecked;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final quantityController = TextEditingController();
    final valueController = TextEditingController();
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
              CheckboxComponent(value: false),
              SizedBox(width: 8),
              Expanded(
                child: FlatInputTextComponent(
                  controller: controller,
                  isBig: true,
                ),
              ),
              Icon(Icons.more_vert, color: AppColors.gray100),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 114,
                    child: QuantityUnitField(
                      onUnitChanged: (value) {},
                      quantityController: quantityController,
                      unit: 'un',
                    ),
                  ),
                  Text("Total: ", style: AppTextStyles.body),
                  Text(
                    "R\$ 0,00",
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: InputTextComponent(
                      controller: valueController,
                      onClear: () => valueController.clear(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
