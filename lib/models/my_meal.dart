import 'food.dart';

class MyMeal {
  String name;
  List<MyFoodCalculate> foods;

  MyMeal({required this.name, required this.foods});

  @override
  String toString() {
    return 'MyMeal{name: $name, foods: $foods}';
  }
}

class MyFoodCalculate {
  Food? food;
  double quantity;

  MyFoodCalculate({required this.food, required this.quantity});

  @override
  String toString() {
    return 'MyFoodCalculate{food: $food, quantity: $quantity}';
  }
}