import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/date_picker.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/Input/quantity_unit.dart';
import 'package:summa/core/widgets/circular_button.dart';
import 'package:summa/core/widgets/tag_component.dart';
import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/domain/model/shopping_list.dart';
import 'package:summa/features/items/component/item_card.dart';
import 'package:summa/features/items/shopping_item_viewmodel.dart';
import 'package:summa/features/lists/shopping_list_viewmodel.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key, required this.listId});

  final int listId;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late TextEditingController _listNameController;
  late TextEditingController _itemNameController;
  late TextEditingController _quantityController;
  late FocusNode _listNameFocusNode;
  ShoppingList? _list;
  String _unitController = 'un';

  void _createItem() async {
    if (_itemNameController.text.isNotEmpty) {
      await context.read<ShoppingItemViewmodel>().create(
        name: _itemNameController.text,
        quantity: double.parse(_quantityController.text),
        unit: _unitController,
      );

      _itemNameController.clear();
      _quantityController.clear();
    }
  }

  void _getList() async {
    final getList = await context.read<ShoppingListViewmodel>().getList(
      widget.listId,
    );

    if (!mounted) return;

    setState(() {
      _list = getList;
      _listNameController.text = _list?.name ?? "";
    });
  }

  void _showEditDate() async {
    final DateTime? pickedDate = await DatePicker.show(
      context,
      initialDate: _list?.plannedAt ?? DateTime.now(),
    );

    if (pickedDate != null && mounted && _list != null) {
      await context.read<ShoppingListViewmodel>().update(
        listId: _list!.id,
        plannedAt: pickedDate,
      );
      _getList();
    }
  }

  void _saveName() async {
    final newName = _listNameController.text.trim();
    final oldName = _list?.name;

    if (newName.isNotEmpty && newName != oldName && _list != null) {
      await context.read<ShoppingListViewmodel>().update(
        listId: _list!.id,
        name: newName,
      );
      _getList();
    }
  }

  @override
  void initState() {
    super.initState();
    _listNameController = TextEditingController();
    _itemNameController = TextEditingController();
    _quantityController = TextEditingController();
    _listNameFocusNode = FocusNode();
    _getList();

    _listNameFocusNode.addListener(() {
      if (!_listNameFocusNode.hasFocus) {
        _saveName();
      }
    });
  }

  @override
  void dispose() {
    _listNameController.dispose();
    _itemNameController.dispose();
    _quantityController.dispose();
    _listNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 180,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    0,
                    AppSpacing.lg,
                    0,
                  ),
                  decoration: BoxDecoration(color: AppColors.gray900),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(Icons.chevron_left_sharp),
                      ),
                      Flexible(
                        child: FlatInputTextComponent(
                          controller: _listNameController,
                          isBig: true,
                          focusNode: _listNameFocusNode,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showEditDate,
                        child: TagComponent(
                          text: _list?.formatDateDayMonth ?? "Adicionar data",
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 100,
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: InputTextComponent(
                          controller: _itemNameController,
                          label: 'Item',
                          hintText: 'Nome do item',
                        ),
                      ),

                      const SizedBox(width: 8),

                      SizedBox(
                        width: 114,
                        child: QuantityUnitField(
                          hintText: 'Qnt',
                          quantityController: _quantityController,
                          unit: _unitController,
                          onUnitChanged: (value) {
                            setState(() {
                              _unitController = value;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      CircularButtonComponnent(onPress: _createItem),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Consumer<ShoppingItemViewmodel>(
              builder: (context, viewModel, child) {
                return StreamBuilder<List<ShoppingItem>>(
                  stream: viewModel.baseStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: const CircularProgressIndicator(
                          color: AppColors.gray100,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final listItems = snapshot.data ?? [];

                    if (listItems.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhum item encontrado',
                          style: AppTextStyles.body.copyWith(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      separatorBuilder: (_, _) => SizedBox(height: 12),
                      itemCount: listItems.length,
                      itemBuilder: (context, index) {
                        final item = listItems[index];
                        return ItemCardComponent(
                          key: ValueKey(item.id),
                          item: item,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
