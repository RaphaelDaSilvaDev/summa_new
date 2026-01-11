import 'package:summa/domain/model/shopping_item.dart';

abstract class ShoppingItemRepository {
  Stream<List<ShoppingItem>> getAllByList(int listId);

  Future<ShoppingItem?> getItemById(int id);

  Future<void> update(ShoppingItem item, int listId);

  Future<void> delete(int id, int listId);

  Future<int> insert(ShoppingItem item, int listId);
}
