import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_text_styles.dart';

class FlatInputTextComponent extends StatelessWidget {
  const FlatInputTextComponent({
    super.key,
    this.controller,
    this.isBig = false,
    this.autoFocus = false,
    this.focusNode,
  });

  final TextEditingController? controller;
  final bool isBig;
  final bool autoFocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        constraints: BoxConstraints(minWidth: 48),
        child: TextField(
          controller: controller,
          autofocus: autoFocus,
          focusNode: focusNode,
          style: isBig ? AppTextStyles.headline1 : AppTextStyles.button,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
