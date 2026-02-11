import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:summa/domain/repositories/shopping_item_repository.dart';
import 'package:summa/domain/repositories/shopping_list_repository.dart';
import 'package:summa/features/categories/categories_page.dart';
import 'package:summa/features/items/item_page.dart';
import 'package:summa/features/items/shopping_item_viewmodel.dart';
import 'package:summa/features/lists/list_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ListPage()),
    GoRoute(
      path: '/item/:listId',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['listId']!);
        return ChangeNotifierProvider(
          create: (context) => ShoppingItemViewmodel(
            context.read<ShoppingItemRepository>(),
            context.read<ShoppingListRepository>(),
            id,
          ),
          child: ItemPage(listId: id),
        );
      },
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesPage(),
    ),
  ],
);
