import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/date_picker.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/tag_component.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';
import 'package:summa/features/lists/shopping_list_viewmodel.dart';

class ListCardComponent extends StatefulWidget {
  const ListCardComponent({super.key, required this.listWithItem});

  final ShoppingListWithItems listWithItem;

  @override
  State<ListCardComponent> createState() => _ListCardComponentState();
}

class _ListCardComponentState extends State<ListCardComponent> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.listWithItem.list.name);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _saveName();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveName() {
    final newName = _controller.text.trim();
    final oldName = widget.listWithItem.list.name;

    if (newName.isNotEmpty && newName != oldName) {
      context.read<ShoppingListViewmodel>().update(
        listId: widget.listWithItem.list.id,
        name: newName,
      );
    }
  }

  void _showEditDate() async {
    final DateTime? pickedDate = await DatePicker.show(
      context,
      initialDate: widget.listWithItem.list.plannedAt,
    );

    if (pickedDate != null && mounted) {
      await context.read<ShoppingListViewmodel>().update(
        listId: widget.listWithItem.list.id,
        plannedAt: pickedDate,
      );
    }
  }

  void _menuSelect(String? selected) async {
    switch (selected) {
      case 'remove':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.gray400,
            title: Text('Remover Lista?', style: AppTextStyles.headline2),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                'Essa opção não pode ser desfeita.',
                style: AppTextStyles.body,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.body.copyWith(color: AppColors.gray100),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Remover',
                  style: AppTextStyles.button.copyWith(color: AppColors.purple),
                ),
              ),
            ],
          ),
        );
        if (confirm == true && mounted) {
          await context.read<ShoppingListViewmodel>().remove(
            widget.listWithItem.list.id,
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/item/${widget.listWithItem.list.id}'),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.gray400,
          border: Border.all(width: 2, color: AppColors.gray300),
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
        child: Column(
          spacing: AppRadius.sm,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: FlatInputTextComponent(
                    controller: _controller,
                    isBig: true,
                    focusNode: _focusNode,
                  ),
                ),
                SizedBox(
                  width: 24,
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    icon: Icon(Icons.more_vert, color: AppColors.gray100),
                    color: AppColors.gray400,
                    onSelected: (value) => _menuSelect(value),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'remove',
                        child: Text('Remover', style: AppTextStyles.button),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("Total: ", style: AppTextStyles.body),
                    Text(
                      "R\$ ${widget.listWithItem.totalPrice}",
                      style: AppTextStyles.headline1.copyWith(
                        fontSize: 18,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
                TagComponent(
                  text:
                      "${widget.listWithItem.totalIsDone}/${widget.listWithItem.items.length}",
                  color: AppColors.blue,
                ),
                GestureDetector(
                  onTap: _showEditDate,
                  child: TagComponent(
                    text: widget.listWithItem.list.formatDateDayMonth,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
