import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/check_box.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/Input/quantity_unit.dart';
import 'package:summa/domain/model/shopping_item.dart';

class ItemCardComponent extends StatefulWidget {
  const ItemCardComponent({super.key, required this.item});

  final ShoppingItem item;

  @override
  State<ItemCardComponent> createState() => _ItemCardComponentState();
}

class _ItemCardComponentState extends State<ItemCardComponent> {
  late TextEditingController _quantityController;
  late TextEditingController _valueController;
  late TextEditingController _nameItemController;

  @override
  void initState() {
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    _valueController = TextEditingController(
      text: widget.item.unitPrice != null
          ? widget.item.unitPrice.toString()
          : "",
    );
    _nameItemController = TextEditingController(text: widget.item.name);
    super.initState();
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
      child: Column(
        spacing: AppRadius.sm,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CheckboxComponent(value: widget.item.isDone),
              SizedBox(width: 8),
              Expanded(
                child: FlatInputTextComponent(
                  controller: _nameItemController,
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
                      quantityController: _quantityController,
                      unit: widget.item.unit,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Total: ',
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(
                          text: 'R\$${widget.item.totalPriceInCents}',
                          style: AppTextStyles.headline2.copyWith(
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 114,
                    child: InputTextComponent(
                      controller: _valueController,
                      onClear: () => _valueController.clear(),
                      hintText: "R\$ 0,00",
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
