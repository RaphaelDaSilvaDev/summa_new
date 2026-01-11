import 'package:flutter/material.dart';
import 'package:summa/domain/model/shopping_list.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';
import 'package:summa/domain/repositories/shopping_list_repository.dart';

class ShoppingListViewmodel extends ChangeNotifier {
  final ShoppingListRepository repository;

  late final Stream<List<ShoppingListWithItems>> listStream;

  ShoppingListViewmodel(this.repository) {
    listStream = repository.getAll();
  }

  String _query = "";

  void updateSearch(String value) {
    _query = value.trim().toLowerCase();
    notifyListeners();
  }

  Stream<List<ShoppingListWithItems>> get baseStream => listStream;

  List<ShoppingListWithItems> applyFilter(List<ShoppingListWithItems> lists) {
    if (_query.isEmpty) return lists;

    return lists
        .where(
          (listWithItem) =>
              listWithItem.list.name.toLowerCase().contains(_query),
        )
        .toList();
  }

  Future<int> createList(String name, DateTime? date) async {
    return await repository.insert(ShoppingList(name: name, plannedAt: date));
  }

  Future<void> update({
    required int listId,
    String? name,
    DateTime? plannedAt,
    bool? isActive,
  }) async {
    ShoppingList? list = await repository.getListById(listId);

    if (list != null) {
      list.plannedAt = plannedAt ?? list.plannedAt;
      list.name = name ?? list.name;
      list.isActive = isActive ?? list.isActive;
      await repository.update(list);
    }
  }

  Future<void> remove(int listId) async {
    await repository.delete(listId);
  }

  Future<ShoppingList?> getList(int listId) async {
    return await repository.getListById(listId);
  }
}
