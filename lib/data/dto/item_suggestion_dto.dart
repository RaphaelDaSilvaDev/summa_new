class ItemSuggestionDto {
  final String name;
  final String unit;
  final int? categoryId;
  final String? icon;

  const ItemSuggestionDto({
    required this.name,
    required this.unit,
    this.categoryId,
    this.icon,
  });
}
