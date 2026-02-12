import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/constants/app_icons.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_radius.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/input_popup_menu.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/core/widgets/app_icon.dart';
import 'package:summa/core/widgets/banner_ad.dart';
import 'package:summa/core/widgets/circular_button.dart';
import 'package:summa/domain/model/categories.dart';
import 'package:summa/features/categories/categories_viewmodel.dart';
import 'package:summa/features/categories/component/category_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late TextEditingController _categorieController;
  late TextEditingController _categorieSearchController;
  late FocusNode _categorieFocusNode;
  String? _categorieNameError;
  String _iconController = AppIcons.allKeys.first;
  int _colorController = AppColors.blueDark.toARGB32();

  @override
  void initState() {
    super.initState();
    _categorieController = TextEditingController();
    _categorieSearchController = TextEditingController();
    _categorieFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _categorieController.dispose();
    _categorieSearchController.dispose();
    _categorieFocusNode.dispose();

    _categorieFocusNode.requestFocus();
    super.dispose();
  }

  void _createItem() async {
    if (_categorieController.text.isNotEmpty) {
      setState(() {
        _categorieNameError = null;
      });

      await context.read<CategoriesViewmodel>().createCategory(
        _categorieController.text,
      );

      _categorieController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _categorieFocusNode.requestFocus();
      });
    } else {
      setState(() {
        _categorieNameError = "Campo obrigatório";
      });
    }
  }

  List<CategoryCard> cards = [
    CategoryCard(category: Categories(name: "Padaria")),
    CategoryCard(category: Categories(name: "Grãos")),
    CategoryCard(category: Categories(name: "Teste")),
    CategoryCard(category: Categories(name: "AHHHHH")),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.gray900,
          title: Text('Categorias'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 90,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      0,
                      AppSpacing.lg,
                      0,
                    ),
                    decoration: BoxDecoration(color: AppColors.gray900),
                    child: null,
                  ),

                  Positioned(
                    top: 10,
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: InputTextComponent(
                            controller: _categorieController,
                            errorText: _categorieNameError,
                            focusNode: _categorieFocusNode,
                            label: 'Categoria',
                            hintText: 'Nome da categoria',
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: AppColors.gray500,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: AppColors.gray300,
                              width: 2,
                            ),
                          ),
                          child: InputPopupMenuWidget<String>(
                            menuSelect: (value) => {
                              setState(() {
                                _iconController = value;
                              }),
                            },
                            selectedValue: AppIcon(
                              icon: AppIcons.icons[_iconController]!,
                              size: 18,
                            ),
                            items: AppIcons.allKeys.map((key) {
                              return PopupMenuItem(
                                value: key,
                                child: Center(
                                  child: AppIcon(
                                    icon: AppIcons.icons[key]!,
                                    size: 18,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: AppColors.gray500,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: AppColors.gray300,
                              width: 2,
                            ),
                          ),
                          child: InputPopupMenuWidget<int>(
                            menuSelect: (value) => {
                              setState(() {
                                _colorController = value;
                              }),
                            },
                            selectedValue: CircleAvatar(
                              backgroundColor: Color(_colorController),
                              maxRadius: 12,
                            ),
                            items: popupColors,
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
                controller: _categorieSearchController,
                hasClear: true,
                label: "Pesquisar",
                hintText: "Nome do item",
                onChanged: (value) {
                  context.read<CategoriesViewmodel>().updateSearch(value);
                },
                onClear: () {
                  _categorieSearchController.clear();
                  context.read<CategoriesViewmodel>().updateSearch("");
                },
              ),
            ),

            Expanded(
              child: Consumer<CategoriesViewmodel>(
                builder: (context, viewModel, child) {
                  return StreamBuilder<CategoriesUiState>(
                    stream: context.read<CategoriesViewmodel>().uiState,
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
                      final categoriesList = state.categories;

                      if (categoriesList.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhuma categoria encontrado',
                            style: AppTextStyles.body.copyWith(fontSize: 16),
                          ),
                        );
                      }

                      List<ListItem> listWithAds = [];

                      for (int i = 0; i < categoriesList.length; i++) {
                        if (i != 0 && i % 3 == 0) {
                          listWithAds.add(AdPlaceholder('ad_$i'));
                        }
                        listWithAds.add(ItemData(categoriesList[i]));
                      }

                      return Column(
                        children: [
                          Expanded(
                            child:
                                _categorieSearchController.text.isEmpty &&
                                    categoriesList.isEmpty
                                ? Center(
                                    child: Text(
                                      'Nenhuma categoria encontrado para o filtro',
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
                                    areItemsTheSame: (oldItem, newItem) {
                                      if (oldItem is ItemData &&
                                          newItem is ItemData) {
                                        return oldItem.item.id ==
                                            newItem.item.id;
                                      }

                                      if (oldItem is AdPlaceholder &&
                                          newItem is AdPlaceholder) {
                                        return oldItem.id == newItem.id;
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
                                                  ? CategoryCard(
                                                      key: ValueKey(
                                                        item.item.id,
                                                      ),
                                                      category: item.item,
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

  List<PopupMenuItem<dynamic>> get popupColors {
    return [
      PopupMenuItem(
        value: AppColors.blueDark.toARGB32(),
        child: Center(
          child: CircleAvatar(
            backgroundColor: AppColors.blueDark,
            maxRadius: 12,
          ),
        ),
      ),
      PopupMenuItem(
        value: AppColors.pinkDark.toARGB32(),
        child: Center(
          child: CircleAvatar(
            backgroundColor: AppColors.pinkDark,
            maxRadius: 12,
          ),
        ),
      ),
      PopupMenuItem(
        value: AppColors.orangeDark.toARGB32(),
        child: Center(
          child: CircleAvatar(
            backgroundColor: AppColors.orangeDark,
            maxRadius: 12,
          ),
        ),
      ),
      PopupMenuItem(
        value: AppColors.yellowDark.toARGB32(),
        child: Center(
          child: CircleAvatar(
            backgroundColor: AppColors.yellowDark,
            maxRadius: 12,
          ),
        ),
      ),
      PopupMenuItem(
        value: AppColors.greenDark.toARGB32(),
        child: Center(
          child: CircleAvatar(
            backgroundColor: AppColors.greenDark,
            maxRadius: 12,
          ),
        ),
      ),
    ];
  }
}

abstract class ListItem {}

class ItemData extends ListItem {
  final Categories item;
  ItemData(this.item);
}

class AdPlaceholder extends ListItem {
  final String id;
  AdPlaceholder(this.id);
}
