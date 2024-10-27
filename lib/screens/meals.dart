import 'package:flutter/material.dart';
import '../models/food.dart';
import '../models/meal.dart';

class Meals extends StatefulWidget {
  Meals({super.key, required this.meals, required this.foods, required this.deleteMeal, required this.fillUpdateMeal, required this.addMealToDiary});

  List<Meal>? meals;
  List<Food>? foods;
  void Function(String mealID) deleteMeal;
  void Function(Meal meal, bool isNew) fillUpdateMeal;
  void Function(String mealId) addMealToDiary;

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  String _calculateMealNutrition(List<FoodCalculate> foodCalculate) {
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
    return 'calories: ${calories.toStringAsFixed(2)}kcal\n' // padding is broken (idk, maybe this string is the problem)
        'fat: ${fat.toStringAsFixed(2)}g, '
        'carbs: ${carbs.toStringAsFixed(2)}g, '
        'protein: ${protein.toStringAsFixed(2)}g\n'
        'quantity: ${quantity.toStringAsFixed(2)}${food.unitOfMeasure.toShortString()}';

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
        List<Widget> children = _buildFoodDetails(meal.foods);
        children.add(
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: TextButton(onPressed: () {
                    widget.fillUpdateMeal(meal, false);
                  }, child: const Icon(Icons.border_color)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: TextButton(onPressed: () {
                    widget.fillUpdateMeal(meal, true);
                  }, child: const Icon(Icons.copy)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: TextButton(onPressed: () {
                    widget.deleteMeal(meal.id);
                  }, child: const Icon(Icons.delete_forever)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: TextButton(onPressed: () {
                    widget.addMealToDiary(meal.id);
                  }, child: const Icon(Icons.book)),
                ),
              ],
            ),
          ),
        );
        return ExpansionTile(
          title: Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(_calculateMealNutrition(meal.foods)),
          children: children,
        );
      }).toList(),
    );
  }
}
