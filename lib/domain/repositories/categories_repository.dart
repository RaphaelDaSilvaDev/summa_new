import 'package:summa/domain/model/categories.dart';

abstract class CategoriesRepository {
  Stream<List<Categories>> getAll();

  Future<int> insert(Categories category);

  Future<void> delete(int id);

  Future<Categories?> getCategoryById(int id);

  Future<void> update(Categories category);
}
