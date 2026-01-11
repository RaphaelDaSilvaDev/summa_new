import 'package:go_router/go_router.dart';
import 'package:summa/features/items/item_page.dart';
import 'package:summa/features/lists/list_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ListPage()),
    GoRoute(
      path: '/item/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ItemPage(listId: int.parse(id));
      },
    ),
  ],
);
