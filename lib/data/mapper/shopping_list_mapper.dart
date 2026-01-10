import 'package:summa/domain/model/shopping_list.dart';

class ShoppingListMapper {
  static ShoppingList fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'] as int,
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
      plannedAt: map['plannedAt'] != null
          ? DateTime.parse(map['plannedAt'])
          : null,
      isActive: map['isActive'] == 1,
    );
  }

  static Map<String, dynamic> toMap(ShoppingList list) {
    return {
      'id': list.id == 0 ? null : list.id,
      'name': list.name,
      'createdAt': list.createdAt.toIso8601String(),
      'plannedAt': list.plannedAt?.toIso8601String(),
      'isActive': list.isActive ? 1 : 0,
    };
  }
}
