import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';

class CircularButtonComponnent extends StatelessWidget {
  const CircularButtonComponnent({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      shape: CircleBorder(),
      backgroundColor: AppColors.purple,
      child: const Icon(Icons.add, color: AppColors.gray100),
    );
  }
}
