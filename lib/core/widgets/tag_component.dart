import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_radius.dart';

class TagComponent extends StatelessWidget {
  const TagComponent({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 2, 12, 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
      ),
      child: Text(text),
    );
  }
}
