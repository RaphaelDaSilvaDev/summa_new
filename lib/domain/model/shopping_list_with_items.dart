import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/domain/model/shopping_list.dart';

class ShoppingListWithItems {
  final ShoppingList list;
  final List<ShoppingItem> items;

  ShoppingListWithItems({required this.list, required this.items});

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalPriceInCents);

  int get totalIsDone => items.where((item) => item.isDone).length;
}
