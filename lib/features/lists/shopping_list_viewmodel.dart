import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/domain/model/shopping_list.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';
import 'package:summa/domain/repositories/shopping_item_repository.dart';
import 'package:summa/domain/repositories/shopping_list_repository.dart';

class ShoppingListUiState {
  final List<ShoppingListWithItems> items;

  const ShoppingListUiState({required this.items});
}

class ShoppingListViewmodel extends ChangeNotifier {
  final ShoppingListRepository repository;
  final ShoppingItemRepository itemRepository;

  final _seachController = BehaviorSubject<String>.seeded('');

  late final Stream<ShoppingListUiState> uiState;

  ShoppingListViewmodel(this.repository, {required this.itemRepository}) {
    uiState =
        Rx.combineLatest2<
          List<ShoppingListWithItems>,
          String,
          ShoppingListUiState
        >(repository.getAll(), _seachController.stream.startWith(''), (
          items,
          search,
        ) {
          final filtered = _applyFilter(items, search);

          return ShoppingListUiState(items: filtered);
        });
  }

  void updateSearch(String value) {
    _seachController.add(value.trim().toLowerCase());
  }

  List<ShoppingListWithItems> _applyFilter(
    List<ShoppingListWithItems> lists,
    String search,
  ) {
    if (search.isEmpty) return lists;

    return lists
        .where(
          (listWithItem) =>
              listWithItem.list.name.toLowerCase().contains(search),
        )
        .toList();
  }

  Future<int> createList(String name, DateTime? date) async {
    return await repository.insert(ShoppingList(name: name, plannedAt: date));
  }

  Future<int> duplicateListWithItems({
    required String name,
    DateTime? date,
    required List<ShoppingItem> items,
  }) async {
    final newListId = await createList(name, date);

    for (final item in items) {
      final ShoppingItem newItem = ShoppingItem(
        name: item.name,
        unit: item.unit,
        quantity: item.quantity,
      );
      await itemRepository.insert(newItem, newListId);
    }

    repository.refresh();

    return newListId;
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

  @override
  void dispose() {
    _seachController.close();
    super.dispose();
  }
}
