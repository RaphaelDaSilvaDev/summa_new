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

  Stream<List<ShoppingItem>> get baseStream => itemStream;

  Future<void> create({
    required String name,
    required String unit,
    required double quantity,
  }) async {
    await repository.insert(
      ShoppingItem(name: name, unit: unit, quantity: quantity),
      listId,
    );

    if (listRepository is ShoppingListRepositoryImpl) {
      (listRepository as ShoppingListRepositoryImpl).refresh();
    }
  }
}
