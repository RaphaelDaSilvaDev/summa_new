import 'package:flutter/material.dart';
import 'package:summa/domain/model/shopping_list_with_items.dart';
import 'package:summa/domain/repositories/shopping_list_repository.dart';

class ShoppingListViewmodel extends ChangeNotifier {
  final ShoppingListRepository repository;

  late final Stream<List<ShoppingListWithItems>> listStream;

  ShoppingListViewmodel(this.repository) {
    print("Instância do ViewModel criada: $hashCode");
    listStream = repository.getAll();
  }

  String _query = "";

  void updateSearch(String value) {
    print(value);
    _query = value.trim().toLowerCase();
    notifyListeners();
  }

  Stream<List<ShoppingListWithItems>> get baseStream => listStream;

  List<ShoppingListWithItems> applyFilter(List<ShoppingListWithItems> lists) {
    print(_query);
    if (_query.isEmpty) return lists;

    print("search");

    return lists
        .where(
          (listWithItem) =>
              listWithItem.list.name.toLowerCase().contains(_query),
        )
        .toList();
  }
}
