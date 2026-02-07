import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/input_popup_menu.dart';

class QuantityUnitField extends StatefulWidget {
  const QuantityUnitField({
    super.key,
    required this.quantityController,
    required this.unit,
    required this.onUnitChanged,
    this.label,
    this.hintText,
    this.focusNode,
    this.onSubmitted,
    this.offset,
  });

  final String? label;
  final TextEditingController quantityController;
  final String unit;
  final void Function(String value) onUnitChanged;
  final String? hintText;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Offset? offset;

  @override
  State<QuantityUnitField> createState() => _QuantityUnitFieldState();
}

class _QuantityUnitFieldState extends State<QuantityUnitField> {
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    widget.focusNode?.addListener(() {
      setState(() {
        _hasFocus = widget.focusNode?.hasFocus ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.xs),
        ],
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          decoration: BoxDecoration(
            color: AppColors.gray500,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _hasFocus ? AppColors.purple : AppColors.gray300,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Quantidade
              SizedBox(
                width: 30,
                child: TextField(
                  focusNode: widget.focusNode,
                  controller: widget.quantityController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.button,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.hintText,
                  ),
                ),
              ),

              // Divisor
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 1,
                height: 20,
                color: AppColors.gray300,
              ),

              // Unidade
              InputPopupMenuWidget(
                menuSelect: (value) => widget.onUnitChanged(value),
                selectedValue: widget.unit,
                offset: widget.offset,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
