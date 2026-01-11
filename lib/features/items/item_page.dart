import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_text_styles.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key, required this.listId});

  final int listId;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('${widget.listId}', style: AppTextStyles.headline1),
      ),
    );
  }
}
