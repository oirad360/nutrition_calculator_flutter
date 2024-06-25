import 'package:flutter/material.dart';
import '../models/food.dart';
import '../models/meal.dart';

class Meals extends StatefulWidget {
  Meals({super.key, required this.meals, required this.foods});

  List<Meal>? meals;
  List<Food>? foods;

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  String _calculateNutrition(List<FoodCalculate> foodCalculate) {
    double calories = 0;
    double fat = 0;
    double carbs = 0;
    double protein = 0;
    for (var fc in foodCalculate) {
      final food = widget.foods?.firstWhere((element) => element.id == fc.foodId);
      final quantity = fc.quantity;
      calories += food!.calories * (quantity / food.quantity);
      fat += food.fat! * (quantity / food.quantity);
      carbs += food.carbs! * (quantity / food.quantity);
      protein += food.protein! * (quantity / food.quantity);
    }
    return 'calories: ${calories - calories.truncate() > 0 ? calories.toStringAsFixed(2) : calories.toInt()}kcal\n'
        'fat: ${fat - fat.truncate() > 0 ? fat.toStringAsFixed(2) : fat.toInt()}g, carbs: ${carbs - carbs.truncate() > 0 ? carbs.toStringAsFixed(2) : carbs.toInt()}g, protein: ${protein - protein.truncate() > 0 ? protein.toStringAsFixed(2) : protein.toInt()}g';
  }

  String _formatNutritionalValues(Food food, double quantity) {
    double calories = (food.calories * (quantity / food.quantity));
    double fat = (food.fat! * (quantity / food.quantity));
    double carbs = (food.carbs! * (quantity / food.quantity));
    double protein = (food.protein! * (quantity / food.quantity));
    return 'calories: ${calories - calories.truncate() > 0 ? calories.toStringAsFixed(2) : calories.toInt()}kcal\n'
        'fat: ${fat.toStringAsFixed(2)}g, ' // if i put ${fat - fat.truncate() > 0 ? fat.toStringAsFixed(2) : fat.toInt()} padding doesn't work (idk)
        'carbs: ${carbs - carbs.truncate() > 0 ? carbs.toStringAsFixed(2) : carbs.toInt()}g, '
        'protein: ${protein - protein.truncate() > 0 ? protein.toStringAsFixed(2) : protein.toInt()}g\n'
        'quantity: ${quantity - quantity.truncate() > 0 ? quantity.toStringAsFixed(2) : quantity.toInt()}${food.unitOfMeasure.toShortString()}';

  }

  List<Widget> _buildFoodDetails(List<FoodCalculate> foodCalculate) {
    return foodCalculate.map((fc) {
      final food = widget.foods?.firstWhere((element) => element.id == fc.foodId);
      final quantity = fc.quantity;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food!.name, style: const TextStyle(fontWeight: FontWeight.bold),),
            Text(_formatNutritionalValues(food, quantity)),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.meals!.map((meal) {
        return ExpansionTile(
          title: Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(_calculateNutrition(meal.foods)),
          expandedAlignment: Alignment.centerLeft,
          children: _buildFoodDetails(meal.foods),
        );
      }).toList(),
    );
  }
}
