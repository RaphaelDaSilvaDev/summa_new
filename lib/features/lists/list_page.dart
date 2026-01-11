import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/circular_button.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';
import 'package:summa/features/lists/component/create_list_dialog.dart';
import 'package:summa/features/lists/component/list_card.dart';
import 'package:summa/features/lists/shopping_list_viewmodel.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateListDialog() async {
    final result = await showDialog<(String, DateTime?)>(
      context: context,
      builder: (context) => const CreateListDialog(),
    );

    if (result != null && mounted) {
      final (listName, date) = result;
      final id = await context.read<ShoppingListViewmodel>().createList(
        listName,
        date,
      );
      _goToItemPage(id);
    }
  }

  void _goToItemPage(int pageId) {
    context.push('/item/$pageId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircularButtonComponnent(
        onPress: _showCreateListDialog,
      ),
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
                  child: Text(
                    'Todas as Listas',
                    style: AppTextStyles.headline1,
                  ),
                ),

                Positioned(
                  top: 100,
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: InputTextComponent(
                    onChanged: (value) {
                      context.read<ShoppingListViewmodel>().updateSearch(value);
                    },
                    controller: _searchController,
                    hasClear: true,
                    label: "Pesquisar",
                    hintText: 'Nome da Lista',
                    onClear: () {
                      _searchController.clear();
                      context.read<ShoppingListViewmodel>().updateSearch("");
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          Expanded(
            child: Consumer<ShoppingListViewmodel>(
              builder: (context, viewModel, _) {
                return StreamBuilder<List<ShoppingListWithItems>>(
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

                    final lists = snapshot.data ?? [];

                    if (lists.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhuma lista encontrada',
                          style: AppTextStyles.body.copyWith(fontSize: 16),
                        ),
                      );
                    }

                    final filtered = viewModel.applyFilter(lists);

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhuma lista encontrada para o filtro',
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
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return ListCardComponent(
                          key: ValueKey(item.list.id),
                          listWithItem: item,
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
