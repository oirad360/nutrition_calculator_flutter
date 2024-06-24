import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/widgets/my_text_input.dart';

import '../database.dart';
import '../models/food.dart';

class Calculate extends StatelessWidget {
  Calculate({super.key, required this.deleteFoodCalculate, required this.updateFoodCalculate, required this.addMeal, this.entries});

  List<Map<String, dynamic>>? entries;
  void Function(String foodId) deleteFoodCalculate;
  void Function(String foodId, double quantity) updateFoodCalculate;
  void Function() addMeal;
  String _calculateNutrition(List<Map<String, dynamic>>? entries) {
    double calories = 0;
    double fat = 0;
    double carbs = 0;
    double protein = 0;
    entries?.forEach((element) {
      final food = element['food'] as Food;
      final quantity = element['quantity'] as double;
      calories += food.calories * (quantity/food.quantity);
      fat += food.fat! * (quantity/food.quantity);
      carbs += food.carbs! * (quantity/food.quantity);
      protein += food.protein! * (quantity/food.quantity);
    });
    return 'calories: ${calories - calories.truncate() > 0 ? calories : calories.toInt()}kcal\n'
        'fat: ${fat - fat.truncate() > 0 ? fat : fat.toInt()}g, carbs: ${carbs - carbs.truncate() > 0 ? carbs : carbs.toInt()}g, protein: ${protein - protein.truncate() > 0 ? protein : protein.toInt()}g';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(
                  children: entries!.map((entry) {
                    final food = entry['food'] as Food;
                    final quantity = entry['quantity'] as double;
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'calories: ${food.calories * (quantity/food.quantity)}kcal\n'
                              'fat: ${food.fat! * (quantity/food.quantity)}g, '
                              'carbs: ${food.carbs! * (quantity/food.quantity)}g, '
                              'protein: ${food.protein! * (quantity/food.quantity)}g'
                          ),
                          SizedBox(
                            width: 135,
                            child: MyTextInputFormField(
                              label: 'Quantity (${food.unitOfMeasure.toShortString()})',
                              onChanged: (value) {
                                if (value != null && value != '') updateFoodCalculate(food.id, double.parse(value));
                              },
                              type: InputType.Decimal,
                              border: const UnderlineInputBorder(),
                              initialValue: quantity - quantity.truncate() > 0 ? quantity.toString() : quantity.toInt().toString(),)
                          )
                        ],
                      ),
                      trailing: TextButton(child: const Text('delete'), onPressed: () {
                        deleteFoodCalculate(food.id);
                      }),
                    );
                  }).toList()
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120, minWidth: double.infinity),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Theme.of(context).colorScheme.primary,
                child: Text(_calculateNutrition(entries), textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20))
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 130,
          child: ElevatedButton(onPressed: () {
            addMeal();
          }, child: const Icon(Icons.save)),
        )
      ],
    );
  }
}
