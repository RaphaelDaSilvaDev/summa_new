import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_text_styles.dart';

class FlatInputTextComponent extends StatelessWidget {
  const FlatInputTextComponent({
    super.key,
    this.controller,
    this.isBig = false,
  });

  final TextEditingController? controller;
  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        style: isBig ? AppTextStyles.headline1 : AppTextStyles.button,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
