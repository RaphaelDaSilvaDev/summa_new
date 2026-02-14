import 'package:summa/domain/model/categories.dart';

class CategoriesMapper {
  static Categories fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      icon: map['icon'],
    );
  }

  static Map<String, dynamic> toMap(Categories category) {
    return {
      'id': category.id == 0 ? null : category.id,
      'name': category.name,
      'color': category.color,
      'icon': category.icon,
    };
  }
}
