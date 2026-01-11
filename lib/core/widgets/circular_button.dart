import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';

class CircularButtonComponnent extends StatelessWidget {
  const CircularButtonComponnent({super.key, required this.onPress});

  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPress,
      shape: CircleBorder(),
      backgroundColor: AppColors.purple,
      child: const Icon(Icons.add, color: AppColors.gray100),
    );
  }
}
