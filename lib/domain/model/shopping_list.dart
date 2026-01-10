import 'package:intl/intl.dart';
import 'package:summa/domain/model/shopping_item.dart';

class ShoppingList {
  final int id;
  String name;
  final List<ShoppingItem> items;
  final DateTime createdAt;
  DateTime? plannedAt;
  bool isActive;

  ShoppingList({
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

  String get formatDateDayMonth {
    if (plannedAt != null) {
      return DateFormat('dd/MM').format(plannedAt!);
    }

    return "Adicionar data";
  }
}
