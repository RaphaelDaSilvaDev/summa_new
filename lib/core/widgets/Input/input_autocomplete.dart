import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/data/dto/item_suggestion_dto.dart';

class InputAutocomplete extends StatefulWidget {
  const InputAutocomplete({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    required this.search,
    this.onSubmitted,
    required this.onSelectedReturn,
    this.onFocusNodeCreated,
    this.onInputControllerCreated,
  });

  final String? label;
  final String? hintText;
  final String? errorText;
  final Function(String)? onSubmitted;
  final Future<Iterable<ItemSuggestionDto>> Function(String) search;
  final Function(ItemSuggestionDto) onSelectedReturn;
  final void Function(TextEditingController)? onInputControllerCreated;
  final void Function(FocusNode)? onFocusNodeCreated;

  @override
  State<InputAutocomplete> createState() => _InputAutocompleteState();
}

class _InputAutocompleteState extends State<InputAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<ItemSuggestionDto>(
      displayStringForOption: (option) => option.name,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        final text = textEditingValue.text.trim();
        if (text.isEmpty) {
          return const Iterable<ItemSuggestionDto>.empty();
        }

        return await widget.search(text);
      },
      optionsViewBuilder: (context, onSelectedAutocomplete, options) {
        return Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: BorderSide(width: 2, color: AppColors.gray300),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            separatorBuilder: (context, index) => Divider(
              color: AppColors.gray300.withValues(alpha: 0.0),
              height: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              final option = options.elementAt(index);

              return InkWell(
                onTap: () => onSelectedAutocomplete(option),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Text(
                    '${option.name} (${option.unit})',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.gray100,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      onSelected: (option) {
        widget.onSelectedReturn.call(option);
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onFocusNodeCreated?.call(focusNode);
              widget.onInputControllerCreated?.call(textEditingController);
            });

            return InputTextComponent(
              label: widget.label,
              controller: textEditingController,
              onSubmitted: widget.onSubmitted,
              hintText: widget.hintText,
              errorText: widget.errorText,
              focusNode: focusNode,
            );
          },
    );
  }
}
