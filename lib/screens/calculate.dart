import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/widgets/my_text_input.dart';
import '../models/food.dart';
import '../models/meal.dart';

class Calculate extends StatefulWidget {
  Calculate({super.key, this.mealName = '', this.mealID = '', required this.deleteFoodCalculate, required this.updateFoodCalculate, required this.updateMealName, required this.addMeal, this.foods, required this.updateMeal, required this.undoUpdate});

  List<Map<String, dynamic>>? foods;
  String mealID;
  String mealName;
  void Function(String foodId) deleteFoodCalculate;
  void Function(String foodId, double quantity) updateFoodCalculate;
  void Function(String mealName) updateMealName;
  void Function() updateMeal;
  void Function() addMeal;
  void Function() undoUpdate;

  @override
  State<Calculate> createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {
  String? _mealName;
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
    return 'calories: ${calories - calories.truncate() > 0 ? calories.toStringAsFixed(2) : calories.toInt()}kcal\n'
        'fat: ${fat - fat.truncate() > 0 ? fat.toStringAsFixed(2) : fat.toInt()}g, carbs: ${carbs - carbs.truncate() > 0 ? carbs.toStringAsFixed(2) : carbs.toInt()}g, protein: ${protein - protein.truncate() > 0 ? protein.toStringAsFixed(2) : protein.toInt()}g';
  }

  String _formatNutritionalValues(Food food, double quantity) {
    double calories = food.calories * (quantity / food.quantity);
    double fat = food.fat! * (quantity / food.quantity);
    double carbs = food.carbs! * (quantity / food.quantity);
    double protein = food.protein! * (quantity / food.quantity);
    return 'calories: ${calories - calories.truncate() > 0 ? calories.toStringAsFixed(2) : calories.toInt()}kcal\n'
        'fat: ${fat - fat.truncate() > 0 ? fat.toStringAsFixed(2) : fat.toInt()}g, carbs: ${carbs - carbs.truncate() > 0 ? carbs.toStringAsFixed(2) : carbs.toInt()}g, protein: ${protein - protein.truncate() > 0 ? protein.toStringAsFixed(2) : protein.toInt()}g';
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _mealName = widget.mealName;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            MyTextInputFormField(
              label: 'Insert a name to save this meal',
              border: const UnderlineInputBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              initialValue: _mealName,
              maxLength: 75,
              onChanged: (value) {
              setState(() {
                _mealName = value;
                if (value != null && value != '') widget.updateMealName(value);
              });
            },),
            Expanded(
              child: ListView(
                  children: widget.foods!.map((entry) {
                    final food = entry['food'] as Food;
                    final quantity = entry['quantity'] as double;
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatNutritionalValues(food, quantity)),
                          SizedBox(
                            width: 135,
                            child: MyTextInputFormField(
                              label: 'Quantity (${food.unitOfMeasure.toShortString()})',
                              onChanged: (value) {
                                if (value != null && value != '') widget.updateFoodCalculate(food.id, double.parse(value));
                              },
                              type: InputType.Decimal,
                              border: const UnderlineInputBorder(),
                              initialValue: quantity - quantity.truncate() > 0 ? quantity.toString() : quantity.toInt().toString(),)
                          )
                        ],
                      ),
                      trailing: TextButton(child: const Icon(Icons.delete), onPressed: () {
                        widget.deleteFoodCalculate(food.id);
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
                child: Text(_calculateNutrition(widget.foods), textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20))
              ),
            ),
          ],
        ),
        if (_mealName != null && _mealName!.isNotEmpty) Positioned(
          bottom: 130,
          child: ElevatedButton(onPressed: () {
            if (widget.mealID != '') {
              widget.updateMeal();
            } else {
              widget.addMeal();
            }
          }, child: widget.mealID != '' ? const Icon(Icons.border_color) : const Icon(Icons.save)),
        ),
        if (widget.mealID != '') Positioned(
          bottom: 130,
          right: 50,
          child: ElevatedButton(onPressed: () {
            widget.undoUpdate();
          }, child: const Icon(Icons.undo)),
        )
      ],
    );
  }
}
