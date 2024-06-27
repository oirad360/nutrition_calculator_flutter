import 'package:flutter/material.dart';
import '../models/food.dart';

class FoodTable extends StatelessWidget {
  FoodTable({super.key, required this.foods, required this.addFoodCalculate, required this.deleteFood, required this.updateFood});

  List<Food>? foods;
  void Function(double quantity, Food food) addFoodCalculate;
  void Function(String foodID) deleteFood;
  void Function(Food food) updateFood;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: foods!.map((food) => ExpansionTile(
          title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('calories: ${food.calories - food.calories.truncate() > 0 ? food.calories : food.calories.toInt()}kcal\n'
          'fat: ${food.fat! - food.fat!.truncate() > 0 ? food.fat : food.fat?.toInt()}g, '
          'carbs: ${food.carbs! - food.carbs!.truncate() > 0 ? food.carbs : food.carbs?.toInt()}g, '
          'protein: ${food.protein! - food.protein!.truncate() > 0 ? food.protein : food.protein?.toInt()}g\n'
          'quantity: ${food.quantity - food.quantity.truncate() > 0 ? food.quantity : food.quantity.toInt()}${food.unitOfMeasure.toShortString()}'),
          expandedAlignment: Alignment.centerLeft,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (food.description != null && food.description != '') Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(food.description!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15, top: 5, bottom: 5),
                      child: TextButton(onPressed: () {
                        addFoodCalculate(food.quantity, food);
                      }, child: const Icon(Icons.calculate)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(onPressed: () {
                        updateFood(food);
                      }, child: const Icon(Icons.border_color)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(onPressed: () {
                        deleteFood(food.id);
                      }, child: const Icon(Icons.delete_forever)),
                    ),
                  ],
                ),
              ],
            )
          ],
        )).toList()
    );
  }
}
