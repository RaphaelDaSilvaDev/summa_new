import 'package:summa/data/domain/model/Shopping_item.dart';

class Shoppinglist {
  final int id;
  String name;
  final List<ShoppingItem> items;
  final DateTime createdAt;
  DateTime? plannedAt;
  bool isActive;

  Shoppinglist({
    this.id = 0,
    required this.name,
    this.items = const [],
    DateTime? createdAt,
    this.plannedAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  int get totalPrice {
    return items.fold<int>(0, (sum, item) => sum + item.totalPriceInCents);
  }
}
