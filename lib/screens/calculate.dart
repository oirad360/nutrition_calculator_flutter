import 'package:flutter/material.dart';

import '../models/food.dart';

class Calculate extends StatelessWidget {
  Calculate({super.key, this.entries});

  List<Map<String, dynamic>>? entries;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: entries!.map((entry) {
          final food = entry['food'] as Food;
          final quantity = entry['quantity'] as double;
          return ListTile(
            title: Text(food.name),
            subtitle: Text('calories: ${food.calories * (quantity/food.quantity)}kcal\n'
                'fat: ${food.fat! * (quantity/food.quantity)}g, '
                'carbs: ${food.carbs! * (quantity/food.quantity)}g, '
                'protein: ${food.protein! * (quantity/food.quantity)}g\n'
                'quantity: ${quantity - quantity.truncate() > 0 ? quantity : quantity.toInt()}${food.unitOfMeasure.toShortString()}'),
          );
        }).toList()
    );
  }
}
