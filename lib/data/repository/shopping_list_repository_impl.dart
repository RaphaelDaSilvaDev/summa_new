import 'dart:async';

import 'package:summa/core/database/database_provider.dart';
import 'package:summa/data/mapper/shopping_item_mapper.dart';
import 'package:summa/data/mapper/shopping_list_mapper.dart';
import 'package:summa/domain/model/shopping_list.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';
import 'package:summa/domain/repositories/shopping_list_repository.dart';

class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final _constroller =
      StreamController<List<ShoppingListWithItems>>.broadcast();

  ShoppingListRepositoryImpl() {
    _emitLists();
  }

  Future<void> _emitLists() async {
    final db = await DatabaseProvider.database;

    final listResult = await db.query('shopping_lists');

    final result = <ShoppingListWithItems>[];

    for (final listMap in listResult) {
      final list = ShoppingListMapper.fromMap(listMap);

      final itemsResult = await db.query(
        'shopping_items',
        where: 'id = ?',
        whereArgs: [list.id],
      );

      final items = itemsResult
          .map((e) => ShoppingItemMapper.fromMap(e))
          .toList();

      result.add(ShoppingListWithItems(list: list, items: items));
    }

    _constroller.add(result);
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseProvider.database;

    await db.delete('shopping_lists', where: 'id = ?', whereArgs: [id]);

    await _emitLists();
  }

  @override
  Stream<List<ShoppingListWithItems>> getAll() {
    return _constroller.stream;
  }

  @override
  Future<ShoppingList?> getListById(int listId) async {
    final db = await DatabaseProvider.database;

    final result = await db.query(
      'shopping_lists',
      where: 'id = ?',
      whereArgs: [listId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return ShoppingListMapper.fromMap(result as Map<String, dynamic>);
  }

  @override
  Future<ShoppingListWithItems?> getListWithItems(int listId) async {
    final db = await DatabaseProvider.database;

    final listResult = await db.query(
      'shopping_lists',
      where: 'id = ?',
      whereArgs: [listId],
      limit: 1,
    );

    if (listResult.isEmpty) return null;

    final list = ShoppingListMapper.fromMap(listResult.first);

    final itemResult = await db.query(
      'shopping_items',
      where: 'listId = ?',
      whereArgs: [listId],
    );

    final items = itemResult.map((e) => ShoppingItemMapper.fromMap(e)).toList();

    return ShoppingListWithItems(list: list, items: items);
  }

  @override
  Future<int> insert(ShoppingList list) async {
    final db = await DatabaseProvider.database;

    final id = await db.insert(
      'shopping_lists',
      ShoppingListMapper.toMap(list),
    );

    await _emitLists();
    return id;
  }

  @override
  Future<void> update(ShoppingList list) async {
    final db = await DatabaseProvider.database;

    await db.update(
      'shopping_lists',
      ShoppingListMapper.toMap(list),
      where: 'id = ?',
      whereArgs: [list.id],
    );

    await _emitLists();
  }
}
