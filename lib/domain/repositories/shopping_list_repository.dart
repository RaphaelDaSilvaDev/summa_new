import 'package:summa/domain/model/shopping_list.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';

abstract class ShoppingListRepository {
  Stream<List<ShoppingListWithItems>> getAll();

  Future<int> insert(ShoppingList list);

  Future<void> delete(int id);

  Future<void> update(ShoppingList list);

  Future<ShoppingList?> getListById(int listId);

  Future<ShoppingListWithItems?> getListWithItems(int listId);
}
