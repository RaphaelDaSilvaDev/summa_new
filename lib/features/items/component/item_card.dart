import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/extensions/currency_extensions.dart';
import 'package:summa/core/extensions/quantity_exteinsions.dart';
import 'package:summa/core/input_formatters/currency_input_formatter.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/check_box.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/Input/quantity_unit.dart';
import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/features/items/shopping_item_viewmodel.dart';

class ItemCardComponent extends StatefulWidget {
  const ItemCardComponent({
    super.key,
    required this.item,
    required this.listId,
  });

  final ShoppingItem item;
  final int listId;

  @override
  State<ItemCardComponent> createState() => _ItemCardComponentState();
}

class _ItemCardComponentState extends State<ItemCardComponent> {
  late TextEditingController _quantityController;
  late FocusNode _quantityFocusNode;
  late TextEditingController _valueController;
  late FocusNode _valueFocusNode;
  late TextEditingController _nameItemController;
  late FocusNode _nameItemFocusNode;

  late int _unitTotalInCents;
  late int _subTotalInCents;
  late double _quantity;

  @override
  void initState() {
    _unitTotalInCents = widget.item.unitPrice ?? 0;
    _quantity = widget.item.quantity;
    _subTotalInCents = (_unitTotalInCents * _quantity).round();

    _quantityController = TextEditingController(
      text: _quantity.formatQuantity(),
    );
    _quantityController.addListener(_recalculateSubtotal);
    _quantityFocusNode = FocusNode();
    _quantityFocusNode.addListener(() {
      if (_quantityFocusNode.hasFocus) {
        _quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _quantityController.text.length,
        );
      }

      if (!_quantityFocusNode.hasFocus) {
        final rawText = _quantityController.text.trim();

        if (rawText.isEmpty) return;

        final parsedValue = double.tryParse(rawText.replaceAll(",", "."));

        if (parsedValue == null) return;

        context.read<ShoppingItemViewmodel>().update(
          itemId: widget.item.id,
          quantity: parsedValue,
        );

        _quantityController.text = parsedValue.formatQuantity();
      }
    });

    _valueController = TextEditingController(
      text: _unitTotalInCents.formatCurrencyBR(),
    );
    _valueController.addListener(_recalculateSubtotal);
    _valueFocusNode = FocusNode();
    _valueFocusNode.addListener(() {
      if (_valueFocusNode.hasFocus) {
        _valueController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _valueController.text.length,
        );
      }

      if (!_valueFocusNode.hasFocus) {
        final cents = _valueController.text.parseCurrencyBRToCents();
        context.read<ShoppingItemViewmodel>().update(
          itemId: widget.item.id,
          unitPrice: cents,
        );

        _valueController.text = cents.formatCurrencyBR();
      }
    });

    _nameItemController = TextEditingController(text: widget.item.name);
    _nameItemFocusNode = FocusNode();
    _nameItemFocusNode.addListener(() {
      if (!_nameItemFocusNode.hasFocus) {
        if (_nameItemController.text.isNotEmpty) {
          context.read<ShoppingItemViewmodel>().update(
            itemId: widget.item.id,
            name: _nameItemController.text.trim(),
          );
        } else {
          _nameItemController.text = widget.item.name;
        }
      }
    });
    super.initState();
  }

  void _recalculateSubtotal() {
    final cents = _valueController.text.parseCurrencyBRToCents();
    final quantity = _quantityController.text.formatStringToQuanity();
    setState(() {
      _unitTotalInCents = cents;
      _quantity = quantity;
      _subTotalInCents = (cents * quantity).round();
    });

    context.read<ShoppingItemViewmodel>().update(
      itemId: widget.item.id,
      unitPrice: cents,
      quantity: quantity,
    );
  }

  void updateStatus() {
    context.read<ShoppingItemViewmodel>().update(
      itemId: widget.item.id,
      isDone: !widget.item.isDone,
    );
  }

  void updateUnit(String value) {
    context.read<ShoppingItemViewmodel>().update(
      itemId: widget.item.id,
      unit: value,
    );
  }

  void _menuSelected(String? selected) async {
    switch (selected) {
      case 'remove':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.gray400,
            title: Text("Remover item?", style: AppTextStyles.headline2),
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
          await context.read<ShoppingItemViewmodel>().remove(widget.item.id);
        }
        break;
    }
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
              CheckboxComponent(value: widget.item.isDone, onTap: updateStatus),
              SizedBox(width: 8),
              Expanded(
                child: FlatInputTextComponent(
                  controller: _nameItemController,
                  isBig: true,
                  focusNode: _nameItemFocusNode,
                ),
              ),
              SizedBox(
                width: 24,
                child: PopupMenuButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  icon: Icon(Icons.more_vert, color: AppColors.gray100),
                  color: AppColors.gray400,
                  onSelected: (value) => _menuSelected(value),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'remove',
                      child: Text("Remover", style: AppTextStyles.button),
                    ),
                  ],
                ),
              ),
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
                      onUnitChanged: (value) => updateUnit(value),
                      quantityController: _quantityController,
                      focusNode: _quantityFocusNode,
                      unit: widget.item.unit,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Total: ',
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(
                          text: _subTotalInCents.formatCurrencyBR(),
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
                      focusNode: _valueFocusNode,
                      textInputType: TextInputType.number,
                      onClear: () => _valueController.clear(),
                      hintText: "R\$ 0,00",
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
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
