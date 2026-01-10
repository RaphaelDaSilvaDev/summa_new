import 'package:summa/domain/model/shopping_item.dart';

class ShoppingItemMapper {
  static ShoppingItem fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      unit: map['unit'],
      unitPrice: map['unitPrice'],
      isDone: map['isDone'] == 1,
    );
  }

  static Map<String, dynamic> toMap(ShoppingItem item, int listId) {
    return {
      'id': item.id == 0 ? null : item.id,
      'listId': listId,
      'name': item.name,
      'quantity': item.quantity,
      'unit': item.unit,
      'unitPrice': item.unitPrice,
      'isDone': item.isDone ? 1 : 0,
    };
  }
}
