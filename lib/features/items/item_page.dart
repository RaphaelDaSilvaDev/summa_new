import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/Input/quantity_unit.dart';
import 'package:summa/core/widgets/circular_button.dart';
import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/features/items/component/item_card.dart';
import 'package:summa/features/items/shopping_item_viewmodel.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key, required this.listId});

  final int listId;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late TextEditingController _itemNameController;
  late TextEditingController _quantityController;
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

  @override
  void initState() {
    super.initState();

    _itemNameController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 150,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    60,
                    AppSpacing.lg,
                    0,
                  ),
                  decoration: BoxDecoration(color: AppColors.gray900),
                  child: Text('Compra do mês'),
                ),

                Positioned(
                  top: 100,
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 3,
                        child: InputTextComponent(
                          controller: _itemNameController,
                          label: 'Item',
                          hintText: 'Nome do item',
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        flex: 2,
                        child: QuantityUnitField(
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

          SizedBox(height: 40),

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
