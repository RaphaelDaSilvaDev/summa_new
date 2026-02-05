class ShoppingItem {
  final int id;
  String name;
  double quantity;
  String unit;
  int? unitPrice;
  bool isDone;

  ShoppingItem({
    this.id = 0,
    required this.name,
    this.quantity = 0.0,
    required this.unit,
    this.unitPrice,
    this.isDone = false,
  });

  int get totalPriceInCents {
    return (quantity * (unitPrice ?? 0)).toInt();
  }
}
