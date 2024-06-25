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
    return 'calories: ${calories - calories.truncate() > 0 ? calories : calories.toInt()}kcal\n'
        'fat: ${fat - fat.truncate() > 0 ? fat : fat.toInt()}g, carbs: ${carbs - carbs.truncate() > 0 ? carbs : carbs.toInt()}g, protein: ${protein - protein.truncate() > 0 ? protein : protein.toInt()}g';
  }

  List<Widget> _buildFoodDetails(List<FoodCalculate> foodCalculate) {
    return foodCalculate.map((fc) {
      final food = widget.foods?.firstWhere((element) => element.id == fc.foodId);
      final quantity = fc.quantity;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          '${food!.name} \n'
              'Calories: ${(food.calories * (quantity / food.quantity)).toStringAsFixed(2)}kcal\n'
              'Fat: ${(food.fat! * (quantity / food.quantity)).toStringAsFixed(2)}g, '
              'Carbs: ${(food.carbs! * (quantity / food.quantity)).toStringAsFixed(2)}g, '
              'Protein: ${(food.protein! * (quantity / food.quantity)).toStringAsFixed(2)}g\n'
              'Quantity: ${quantity.toStringAsFixed(2)}, ',
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.meals!.map((meal) {
        return ExpansionTile(
          title: Text(meal.name),
          subtitle: Text(_calculateNutrition(meal.foods)),
          children: _buildFoodDetails(meal.foods),
          expandedAlignment: Alignment.centerLeft,
        );
      }).toList(),
    );
  }
}
