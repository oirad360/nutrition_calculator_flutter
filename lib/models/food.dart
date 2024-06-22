enum UnitOfMeasure {
  g,
  ml,
  portion
}

class Food {
  String name;
  String? description;
  double? calories;
  double? fat;
  double? carbs;
  double? protein;
  double quantity;
  UnitOfMeasure unitOfMeasure;

  Food({required this.name, required this.quantity, required this.unitOfMeasure, this.description, this.calories, this.fat, this.carbs, this.protein});
}