import 'package:flutter/material.dart';
import 'package:summa/data/repository/shopping_list_repository_impl.dart';
import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/domain/repositories/shopping_item_repository.dart';
import 'package:summa/domain/repositories/shopping_list_repository.dart';

class ShoppingItemViewmodel extends ChangeNotifier {
  final ShoppingItemRepository repository;
  final ShoppingListRepository listRepository;
  final int listId;

  late final Stream<List<ShoppingItem>> itemStream;

  ShoppingItemViewmodel(this.repository, this.listRepository, this.listId) {
    itemStream = repository.getAllByList(listId);
  }

  String _query = "";

  void updateSearch(String value) {
    _query = value.trim().toLowerCase();
    notifyListeners();
  }

  Stream<List<ShoppingItem>> get baseStream => itemStream;

  List<ShoppingItem> applyFilter(List<ShoppingItem> listItems) {
    if (_query.isEmpty) return listItems;

    return listItems
        .where((item) => item.name.toLowerCase().contains(_query))
        .toList();
  }

  Future<void> create({
    required String name,
    required String unit,
    required double quantity,
    int? newListId,
  }) async {
    await repository.insert(
      ShoppingItem(name: name, unit: unit, quantity: quantity),
      newListId ?? listId,
    );

    if (listRepository is ShoppingListRepositoryImpl) {
      (listRepository as ShoppingListRepositoryImpl).refresh();
    }
  }

  Stream<List<ShoppingItem>> getAllByList(int listId) {
    return repository.getAllByList(listId);
  }

  Future<void> update({
    required int itemId,
    String? name,
    double? quantity,
    String? unit,
    int? unitPrice,
    bool? isDone,
  }) async {
    ShoppingItem? item = await repository.getItemById(itemId);

    if (item != null) {
      item.name = name ?? item.name;
      item.quantity = quantity ?? item.quantity;
      item.unit = unit ?? item.unit;
      item.unitPrice = unitPrice ?? item.unitPrice;
      item.isDone = isDone ?? item.isDone;

      await repository.update(item, listId);

      if (listRepository is ShoppingListRepositoryImpl) {
        (listRepository as ShoppingListRepositoryImpl).refresh();
      }
    }
  }
}
