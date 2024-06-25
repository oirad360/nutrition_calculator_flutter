import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/models/my_meal.dart';

import '../models/food.dart';
import '../models/meal.dart';


class Meals extends StatelessWidget {
  Meals({super.key, required this.meals, required this.foods});

  List<Meal>? meals;
  List<Food>? foods;
  String calculateNutrition(List<FoodCalculate> foodCalculate) {
    double calories = 0;
    double fat = 0;
    double carbs = 0;
    double protein = 0;
    for (var fc in foodCalculate) {
      final food = foods?.firstWhere((element) => element.id == fc.foodId);
      final quantity = fc.quantity;
      calories += food!.calories * (quantity/food.quantity);
      fat += food.fat! * (quantity/food.quantity);
      carbs += food.carbs! * (quantity/food.quantity);
      protein += food.protein! * (quantity/food.quantity);
    }
    return 'calories: ${calories - calories.truncate() > 0 ? calories : calories.toInt()}kcal\n'
        'fat: ${fat - fat.truncate() > 0 ? fat : fat.toInt()}g, carbs: ${carbs - carbs.truncate() > 0 ? carbs : carbs.toInt()}g, protein: ${protein - protein.truncate() > 0 ? protein : protein.toInt()}g';
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: meals!.map((meal) => ListTile(
          title: Text(meal.name),
          subtitle: Text(calculateNutrition(meal.foods)),
        )).toList()
    );
  }
}
