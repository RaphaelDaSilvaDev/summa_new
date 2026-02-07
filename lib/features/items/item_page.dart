import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/extensions/currency_extensions.dart';
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
  String? _itemNameError;
  late TextEditingController _quantityController;
  late TextEditingController _searchController;
  late FocusNode _listNameFocusNode;
  late FocusNode _itemNameFocusNode;
  late FocusNode _quantityFocusNode;

  ShoppingList? _list;
  String _unitController = 'un';

  void _createItem() async {
    if (_itemNameController.text.isNotEmpty) {
      setState(() {
        _itemNameError = null;
      });
      await context.read<ShoppingItemViewmodel>().create(
        name: _itemNameController.text,
        quantity: double.tryParse(_quantityController.text) ?? 0.0,
        unit: _unitController,
      );

      _itemNameController.clear();
      _quantityController.clear();
    } else {
      setState(() {
        _itemNameError = "Campo obrigatório";
      });
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

    if (newName.isNotEmpty) {
      if (newName != oldName && _list != null) {
        await context.read<ShoppingListViewmodel>().update(
          listId: _list!.id,
          name: newName,
        );
        _getList();
      }
    } else {
      _listNameController.text = _list?.name ?? "";
    }
  }

  @override
  void initState() {
    super.initState();
    _listNameController = TextEditingController();
    _itemNameController = TextEditingController();
    _quantityController = TextEditingController();
    _searchController = TextEditingController();
    _listNameFocusNode = FocusNode();
    _itemNameFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();
    _getList();

    _itemNameFocusNode.requestFocus();

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
    _searchController.dispose();
    _listNameFocusNode.dispose();
    _itemNameFocusNode.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                            focusNode: _itemNameFocusNode,
                            errorText: _itemNameError,
                            onSubmitted: (_) {
                              _quantityFocusNode.requestFocus();
                            },
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
                            focusNode: _quantityFocusNode,
                            onSubmitted: (_) {
                              _createItem();
                            },
                            unit: _unitController,
                            onUnitChanged: (value) {
                              setState(() {
                                _unitController = value;
                              });
                            },
                            offset: Offset(0, -8),
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

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: InputTextComponent(
                controller: _searchController,
                hasClear: true,
                label: "Pesquisar",
                hintText: "Nome do item",
                onChanged: (value) {
                  context.read<ShoppingItemViewmodel>().updateSearch(value);
                },
                onClear: () {
                  _searchController.clear();
                  context.read<ShoppingItemViewmodel>().updateSearch("");
                },
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

                      final totalInCents = listItems.fold(
                        0,
                        (sum, item) => sum + item.totalPriceInCents,
                      );

                      final filtered = viewModel.applyFilter(listItems);

                      return Column(
                        children: [
                          Expanded(
                            child: filtered.isEmpty
                                ? Center(
                                    child: Text(
                                      'Nenhum item encontrado para o filtro',
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.lg,
                                      vertical: AppSpacing.sm,
                                    ),
                                    separatorBuilder: (_, _) =>
                                        SizedBox(height: 12),
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      final item = filtered[index];
                                      return ItemCardComponent(
                                        key: ValueKey(item.id),
                                        item: item,
                                        listId: widget.listId,
                                      );
                                    },
                                  ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 90,
                            decoration: BoxDecoration(color: AppColors.gray900),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Total:', style: AppTextStyles.body),
                                  Text(
                                    totalInCents.formatCurrencyBR(),
                                    style: AppTextStyles.headline1.copyWith(
                                      color: AppColors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
