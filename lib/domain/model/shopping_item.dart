class ShoppingItem {
  final int id;
  final String name;
  final double quantity;
  final String unit;
  final int? unitPrice;
  final bool isDone;

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
