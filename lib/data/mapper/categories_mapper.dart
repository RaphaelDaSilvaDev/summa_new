import 'package:summa/domain/model/categories.dart';

class CategoriesMapper {
  static Categories fromMap(Map<String, dynamic> map) {
    return Categories(id: map['id'], name: map['name']);
  }

  static Map<String, dynamic> toMap(Categories category) {
    return {'id': category.id, 'name': category.name};
  }
}
