import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_radius.dart';

class TagComponent extends StatelessWidget {
  const TagComponent({super.key, required this.content, required this.color});

  final Widget content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
      ),
      child: Center(child: content),
    );
  }
}
