import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/circular_button.dart';
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

  void _removeAllFocus(BuildContext context) {
    FocusScope.of(context).unfocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
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
    return GestureDetector(
      onTap: () => _removeAllFocus(context),
      child: Scaffold(
        floatingActionButton: CircularButtonComponnent(
          onPress: _showCreateListDialog,
        ),
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
                        context.read<ShoppingListViewmodel>().updateSearch(
                          value,
                        );
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
            Expanded(
              child: Consumer<ShoppingListViewmodel>(
                builder: (context, viewModel, _) {
                  return StreamBuilder<ShoppingListUiState>(
                    stream: context.read<ShoppingListViewmodel>().uiState,
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
                      final lists = state.items;

                      if (lists.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhuma lista encontrada',
                            style: AppTextStyles.body.copyWith(fontSize: 16),
                          ),
                        );
                      }

                      return Expanded(
                        child: _searchController.text.isEmpty && lists.isEmpty
                            ? Center(
                                child: Text(
                                  'Nenhuma lista encontrada para o filtro',
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
                                items: lists,
                                areItemsTheSame: (oldItem, newItem) =>
                                    oldItem.list.id == newItem.list.id,
                                itemBuilder: (context, animation, item, index) {
                                  return SizeFadeTransition(
                                    sizeFraction: 0.5,
                                    curve: Curves.easeInOut,
                                    animation: animation,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: ListCardComponent(
                                        key: ValueKey(item.list.id),
                                        listWithItem: item,
                                      ),
                                    ),
                                  );
                                },
                              ),
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
