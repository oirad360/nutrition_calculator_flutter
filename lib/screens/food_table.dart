import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/database.dart';

import '../models/food.dart';

class FoodTable extends StatefulWidget {
  const FoodTable({super.key});

  @override
  State<FoodTable> createState() => _FoodTableState();
}

class _FoodTableState extends State<FoodTable> {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _dbService.getUserFood(_authService.user!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              children: snapshot.data!.map((food) => ListTile(
                  title: Text(food.name),
                  subtitle: Text('calories: ${food.calories - food.calories.truncate() > 0 ? food.calories : food.calories.toInt()}kcal\n'
                      'fat: ${food.fat! - food.fat!.truncate() > 0 ? food.fat : food.fat?.toInt()}g, '
                      'carbs: ${food.carbs! - food.carbs!.truncate() > 0 ? food.carbs : food.carbs?.toInt()}g, '
                      'protein: ${food.protein! - food.protein!.truncate() > 0 ? food.protein : food.protein?.toInt()}g\n'
                      'quantity: ${food.quantity - food.quantity.truncate() > 0 ? food.quantity : food.quantity.toInt()}${food.unitOfMeasure.toShortString()}'),
              )).toList()
          );
        } else if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ));
        } else {
          return const Center(child: Text('Add some food!'));
        }

      }
    );
  }
}
