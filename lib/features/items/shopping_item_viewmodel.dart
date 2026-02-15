import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:summa/data/dto/item_suggestion_dto.dart';
import 'package:summa/data/repository/shopping_list_repository_impl.dart';
import 'package:summa/domain/model/categories.dart';
import 'package:summa/domain/model/shopping_item.dart';
import 'package:summa/domain/repositories/categories_repository.dart';
import 'package:summa/domain/repositories/shopping_item_repository.dart';
import 'package:summa/domain/repositories/shopping_list_repository.dart';

class ShoppingItemsUiState {
  final List<ShoppingItem> items;
  final int totalInCents;

  const ShoppingItemsUiState({required this.items, required this.totalInCents});
}

class ShoppingItemViewmodel extends ChangeNotifier {
  final ShoppingItemRepository repository;
  final ShoppingListRepository listRepository;
  final CategoriesRepository categoriesRepository;
  final int listId;

  final _searchController = BehaviorSubject<String>.seeded('');
  final _searchItem = BehaviorSubject<String>.seeded('');

  late final Stream<ShoppingItemsUiState> uiState;

  Stream<List<Categories>> get categoriesStream =>
      categoriesRepository.getAll();

  ShoppingItemViewmodel({
    required this.repository,
    required this.listRepository,
    required this.categoriesRepository,
    required this.listId,
  }) {
    uiState =
        Rx.combineLatest2<List<ShoppingItem>, String, ShoppingItemsUiState>(
          repository.getAllByList(listId),
          _searchController.stream.startWith(''),
          (items, search) {
            final filtered = _applyFilter(items, search);

            final total = filtered.fold(
              0,
              (sum, item) => sum + item.totalPriceInCents,
            );

            return ShoppingItemsUiState(items: filtered, totalInCents: total);
          },
        ).asBroadcastStream();
  }

  void updateSearch(String value) {
    _searchController.add(value.trim().toLowerCase());
  }

  List<ShoppingItem> _applyFilter(List<ShoppingItem> listItems, String search) {
    if (search.isEmpty) return listItems;

    return listItems
        .where((item) => item.name.toLowerCase().contains(search))
        .toList();
  }

  Future<void> create({
    required String name,
    required String unit,
    required double quantity,
    int? categoryId,
    int? newListId,
  }) async {
    await repository.insert(
      ShoppingItem(
        name: name,
        unit: unit,
        quantity: quantity,
        categoryId: categoryId,
      ),
      newListId ?? listId,
    );

    _refreshList();
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
    int? category,
  }) async {
    ShoppingItem? item = await repository.getItemById(itemId);

    if (item != null) {
      item.name = name ?? item.name;
      item.quantity = quantity ?? item.quantity;
      item.unit = unit ?? item.unit;
      item.unitPrice = unitPrice ?? item.unitPrice;
      item.isDone = isDone ?? item.isDone;
      item.categoryId = category ?? item.categoryId;

      await repository.update(item, listId);

      _refreshList();
    }
  }

  Future<void> remove(int itemId) async {
    await repository.delete(itemId, listId);
    _refreshList();
  }

  Future<List<ItemSuggestionDto>> getItemSearch(String text) async {
    if (text.isEmpty) return [];
    return await repository.getItemsLikeName(text.trim());
  }

  void _refreshList() {
    if (listRepository is ShoppingListRepositoryImpl) {
      (listRepository as ShoppingListRepositoryImpl).refresh();
    }
  }

  @override
  void dispose() {
    _searchController.close();
    _searchItem.close();
    super.dispose();
  }
}
