import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summa/core/theme/app_colors.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, required this.icon, this.size, this.color});

  final String icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: size ?? 14,
      height: size ?? 14,
      colorFilter: ColorFilter.mode(
        color ?? AppColors.gray100,
        BlendMode.srcIn,
      ),
    );
  }
}
