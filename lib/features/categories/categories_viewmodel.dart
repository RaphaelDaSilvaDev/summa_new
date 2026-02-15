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
  final _uiStateController = BehaviorSubject<CategoriesUiState>();

  Stream<CategoriesUiState> get uiState => _uiStateController.stream;

  CategoriesViewmodel(this.repository) {
    Rx.combineLatest2<List<Categories>, String, CategoriesUiState>(
      repository.getAll(),
      _searchController.stream.startWith(''),
      (items, search) {
        final filtered = _applyFilter(items, search);

        return CategoriesUiState(categories: filtered);
      },
    ).pipe(_uiStateController);
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

  Future<int> createCategory({
    required String name,
    required int color,
    required String icon,
  }) async {
    return await repository.insert(
      Categories(name: name, color: color, icon: icon),
    );
  }

  Future<void> remove(int id) async {
    await repository.delete(id);
  }

  Future<void> update({
    required int id,
    String? name,
    String? icon,
    int? color,
  }) async {
    Categories? category = await repository.getCategoryById(id);

    if (category != null) {
      category.name = name ?? category.name;
      category.icon = icon ?? category.icon;
      category.color = color ?? category.color;

      await repository.update(category);
    }
  }

  @override
  void dispose() {
    _searchController.close();
    _uiStateController.close();
    super.dispose();
  }
}
