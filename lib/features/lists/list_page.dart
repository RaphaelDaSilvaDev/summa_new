import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';
import 'package:summa/features/lists/component/list_card.dart';
import 'package:summa/features/lists/shopping_list_viewmodel.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: Text('Todas as Listas', style: AppTextStyles.headline1),
              ),

              Positioned(
                top: 100,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: InputTextComponent(
                  onChanged: (value) {
                    context.read<ShoppingListViewmodel>().updateSearch(value);
                  },
                  controller: searchController,
                  hasClear: true,
                  label: "Pesquisar",
                  onClear: () {
                    searchController.clear();
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
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final lists = snapshot.data ?? [];

                  if (lists.isEmpty) {
                    return const Text('Nenhuma lista encontrada');
                  }

                  final filtered = viewModel.applyFilter(lists);

                  if (filtered.isEmpty) {
                    return const Text('Nenhuma lista encontrada para o filtro');
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    separatorBuilder: (_, _) => SizedBox(height: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return ListCardComponent(listWithItem: filtered[index]);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
