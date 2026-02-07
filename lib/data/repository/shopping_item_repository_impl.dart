import 'dart:async';

import 'package:summa/core/database/database_provider.dart';
import 'package:summa/data/mapper/shopping_item_mapper.dart';
import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/domain/repositories/shopping_item_repository.dart';

class ShoppingItemRepositoryImpl implements ShoppingItemRepository {
  final _controller = StreamController<List<ShoppingItem>>.broadcast();

  Future<void> _emitLists(int listId) async {
    final db = await DatabaseProvider.database;

    final itemResult = await db.query(
      'shopping_items',
      where: 'listId = ?',
      orderBy: 'isDone, id',
      whereArgs: [listId],
    );

    final result = itemResult
        .map((item) => ShoppingItemMapper.fromMap(item))
        .toList();

    if (!_controller.isClosed) {
      _controller.add(result);
    }
  }

  @override
  Future<void> delete(int id, int listId) async {
    final db = await DatabaseProvider.database;

    await db.delete('shopping_items', where: 'id = ?', whereArgs: [id]);

    await _emitLists(listId);
  }

  @override
  Stream<List<ShoppingItem>> getAllByList(int listId) {
    _emitLists(listId);
    return _controller.stream;
  }

  @override
  Future<ShoppingItem?> getItemById(int id) async {
    final db = await DatabaseProvider.database;

    final result = await db.query(
      'shopping_items',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return ShoppingItemMapper.fromMap(result.first);
  }

  @override
  Future<int> insert(ShoppingItem item, int listId) async {
    final db = await DatabaseProvider.database;

    final id = await db.insert(
      'shopping_items',
      ShoppingItemMapper.toMap(item, listId),
    );

    await _emitLists(listId);
    return id;
  }

  @override
  Future<void> update(ShoppingItem item, int listId) async {
    final db = await DatabaseProvider.database;

    await db.update(
      'shopping_items',
      ShoppingItemMapper.toMap(item, listId),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    await _emitLists(listId);
  }
}
