import 'package:flutter/material.dart';
import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/domain/repositories/shopping_item_repository.dart';

class ShoppingItemViewmodel extends ChangeNotifier {
  final ShoppingItemRepository repository;
  final int listId;

  late final Stream<List<ShoppingItem>> itemStream;

  ShoppingItemViewmodel(this.repository, this.listId) {
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
  }
}
