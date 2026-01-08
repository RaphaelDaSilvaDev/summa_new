import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_spacing.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/input_text.dart';
import 'package:summa/features/lists/component/list_card.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final searchController = TextEditingController();

  List<Widget> itens = List.of([
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
    ListCardComponent(),
  ]);

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
                  controller: searchController,
                  hasClear: true,
                  label: "Pesquisar",
                  onClear: () => searchController.clear(),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 40),

        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            separatorBuilder: (_, _) => SizedBox(height: 12),
            itemCount: itens.length,
            itemBuilder: (context, index) {
              return itens[index];
            },
          ),
        ),
      ],
    );
  }
}
