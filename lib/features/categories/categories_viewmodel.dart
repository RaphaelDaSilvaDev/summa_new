import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:summa/domain/model/categories.dart';
import 'package:summa/domain/repositories/categories_repository.dart';

class CategoriesUiState {
  final List<Categories> categories;
  const CategoriesUiState({required this.categories});
}

class CategoriesViewmodel extends ChangeNotifier {
  final CategoriesRepository repository;

  final _searchController = BehaviorSubject<String>.seeded('');

  late final Stream<CategoriesUiState> uiState;

  CategoriesViewmodel(this.repository) {
    uiState = Rx.combineLatest2<List<Categories>, String, CategoriesUiState>(
      repository.getAll(),
      _searchController.stream.startWith(''),
      (items, search) {
        final filtered = _applyFilter(items, search);

        return CategoriesUiState(categories: filtered);
      },
    ).shareValue();
  }

  void updateSearch(String value) {
    _searchController.add(value.trim().toLowerCase());
  }

  List<Categories> _applyFilter(List<Categories> list, String search) {
    if (search.isEmpty) return list;

    return list
        .where((item) => item.name.toLowerCase().contains(search))
        .toList();
  }

  Future<int> createCategory(String name) async {
    return await repository.insert(Categories(name: name));
  }

  Future<void> remove(int id) async {
    await repository.delete(id);
  }

  @override
  void dispose() {
    _searchController.close();
    super.dispose();
  }
}
