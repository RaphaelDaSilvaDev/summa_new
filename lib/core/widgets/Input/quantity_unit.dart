import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';

class QuantityUnitField extends StatefulWidget {
  const QuantityUnitField({
    super.key,
    required this.quantityController,
    required this.unit,
    required this.onUnitChanged,
    this.label,
  });

  final String? label;
  final TextEditingController quantityController;
  final String unit;
  final ValueChanged<String> onUnitChanged;

  @override
  State<QuantityUnitField> createState() => _QuantityUnitFieldState();
}

class _QuantityUnitFieldState extends State<QuantityUnitField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
          padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
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
                  focusNode: _focusNode,
                  controller: widget.quantityController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.button,
                  decoration: const InputDecoration(border: InputBorder.none),
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
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: widget.unit,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: AppTextStyles.button,
                  dropdownColor: AppColors.gray500,
                  onChanged: (value) => widget.onUnitChanged(value ?? ""),
                  items: const [
                    DropdownMenuItem(value: 'un', child: Text('un')),
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                    DropdownMenuItem(value: 'g', child: Text('g')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
