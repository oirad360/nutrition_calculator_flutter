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
              children: snapshot.data!.map((data) => ListTile(
                  title: Text(data.name),
                  subtitle: Text('calories: ${data.calories - data.calories.truncate() > 0 ? data.calories : data.calories.toInt()}kcal\n'
                      'fat: ${data.fat! - data.fat!.truncate() > 0 ? data.fat : data.fat?.toInt()}g, '
                      'carbs: ${data.carbs! - data.carbs!.truncate() > 0 ? data.carbs : data.carbs?.toInt()}g, '
                      'protein: ${data.protein! - data.protein!.truncate() > 0 ? data.protein : data.protein?.toInt()}g\n'
                      'quantity: ${data.quantity.toString()+data.unitOfMeasure.toShortString()}'),
              )).toList()
          );
        } else {
          return const Text('Add some food!');
        }

      }
    );
  }
}
