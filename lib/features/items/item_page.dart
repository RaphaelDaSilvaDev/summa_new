import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/extensions/currency_extensions.dart';
import 'package:summa/core/extensions/date_extensions.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/date_picker.dart';
import 'package:summa/core/widgets/Input/flat_input_text.dart';
import 'package:summa/core/widgets/Input/input_autocomplete.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/Input/quantity_unit.dart';
import 'package:summa/core/widgets/banner_ad.dart';
import 'package:summa/core/widgets/circular_button.dart';
import 'package:summa/core/widgets/tag_component.dart';
import 'package:summa/data/dto/item_suggestion_dto.dart';
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
  late TextEditingController _searchController;
  late FocusNode _listNameFocusNode;
  late FocusNode _quantityFocusNode;
  StreamSubscription<ShoppingItemsUiState>? _itemsSub;
  String? _itemNameError;
  FocusNode? _itemNameFocusNode;
  bool _listIsEmpty = false;

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

      setState(() {
        _unitController = 'un';
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _itemNameFocusNode?.requestFocus();
      });
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

  Future<Iterable<ItemSuggestionDto>> _getSearchItem(String text) async {
    return await context.read<ShoppingItemViewmodel>().getItemSearch(text);
  }

  void _onSelectSearchItem(ItemSuggestionDto item) {
    _itemNameController.text = item.name;
    setState(() {
      _unitController = item.unit;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quantityFocusNode.requestFocus();
    });
  }

  @override
  void initState() {
    super.initState();
    _listNameController = TextEditingController();
    _quantityController = TextEditingController();
    _searchController = TextEditingController();
    _listNameFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();
    _getList();

    _listNameFocusNode.addListener(() {
      if (!_listNameFocusNode.hasFocus) {
        _saveName();
      }
    });

    _itemsSub = context.read<ShoppingItemViewmodel>().uiState.listen((state) {
      final isEmpty = state.items.isEmpty;
      if (isEmpty && !_listIsEmpty) {
        _itemNameFocusNode?.requestFocus();
      }
      _listIsEmpty = isEmpty;
    });
  }

  void _removeAllFocus(BuildContext context) {
    FocusScope.of(context).unfocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _itemsSub?.cancel();
    _listNameController.dispose();
    _quantityController.dispose();
    _searchController.dispose();
    _listNameFocusNode.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _removeAllFocus(context),
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
                            text:
                                _list?.plannedAt?.formatDate() ??
                                "Adicionar data",
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
                          child: InputAutocomplete(
                            onInputControllerCreated: (textController) {
                              _itemNameController = textController;
                            },
                            onFocusNodeCreated: (focusNode) {
                              _itemNameFocusNode = focusNode;
                            },
                            errorText: _itemNameError,
                            onSubmitted: (_) {
                              _quantityFocusNode.requestFocus();
                            },
                            onSelectedReturn: (item) =>
                                _onSelectSearchItem(item),
                            search: (value) => _getSearchItem(value),
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
                  return StreamBuilder<ShoppingItemsUiState>(
                    stream: context.read<ShoppingItemViewmodel>().uiState,
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

                      final state = snapshot.data!;
                      final listItems = state.items;

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

                      List<ListItem> listWithAds = [];

                      for (int i = 0; i < listItems.length; i++) {
                        if (i != 0 && i % 5 == 0) {
                          listWithAds.add(AdPlaceholder('ad_$i'));
                        }
                        listWithAds.add(ItemData(listItems[i]));
                      }

                      return Column(
                        children: [
                          Expanded(
                            child:
                                _searchController.text.isEmpty &&
                                    listItems.isEmpty
                                ? Center(
                                    child: Text(
                                      'Nenhum item encontrado para o filtro',
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ImplicitlyAnimatedList(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.lg,
                                      vertical: AppSpacing.sm,
                                    ),
                                    items: listWithAds,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    areItemsTheSame: (oldItem, newItem) {
                                      if (oldItem is ItemData &&
                                          newItem is ItemData) {
                                        return oldItem.item.id ==
                                            newItem.item.id;
                                      }
                                      if (oldItem is AdPlaceholder &&
                                          newItem is AdPlaceholder) {
                                        oldItem.id == newItem.id;
                                      }
                                      return false;
                                    },
                                    itemBuilder:
                                        (context, animation, item, index) {
                                          return SizeFadeTransition(
                                            sizeFraction: 0.5,
                                            curve: Curves.easeInOut,
                                            animation: animation,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              child: item is ItemData
                                                  ? ItemCardComponent(
                                                      key: ValueKey(
                                                        item.item.id,
                                                      ),
                                                      item: item.item,
                                                      listId: widget.listId,
                                                    )
                                                  : Center(
                                                      child:
                                                          const BannerAdWidget(),
                                                    ),
                                            ),
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

abstract class ListItem {}

class ItemData extends ListItem {
  final ShoppingItem item;
  ItemData(this.item);
}

class AdPlaceholder extends ListItem {
  final String id;
  AdPlaceholder(this.id);
}
