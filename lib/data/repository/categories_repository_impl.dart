import 'dart:async';

import 'package:summa/core/database/database_provider.dart';
import 'package:summa/data/mapper/categories_mapper.dart';
import 'package:summa/domain/model/categories.dart';
import 'package:summa/domain/repositories/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final _controller = StreamController<List<Categories>>.broadcast();

  Future<void> _emitLists() async {
    final db = await DatabaseProvider.database;

    final categoryResult = await db.query('categories', orderBy: 'id');

    final result = categoryResult
        .map((item) => CategoriesMapper.fromMap(item))
        .toList();

    if (!_controller.isClosed) {
      _controller.add(result);
    }
  }

  @override
  Stream<List<Categories>> getAll() {
    _emitLists();
    return _controller.stream;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseProvider.database;

    await db.delete('categories', where: 'id = ?', whereArgs: [id]);

    await _emitLists();
  }

  @override
  Future<Categories?> getCategoryById(int id) async {
    final db = await DatabaseProvider.database;

    final result = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return CategoriesMapper.fromMap(result.first);
  }

  @override
  Future<int> insert(Categories category) async {
    final db = await DatabaseProvider.database;

    final id = await db.insert('categories', CategoriesMapper.toMap(category));

    await _emitLists();

    return id;
  }
}
