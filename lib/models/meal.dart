import 'package:cloud_firestore/cloud_firestore.dart';

import 'food.dart';

class Meal {

  List<FoodCalculate> foods;
  String id;

  Meal({required this.foods, this.id = '',});

  factory Meal.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Meal(
      id: snapshot.id,
      foods: data?['foods']
    );
  }


  @override
  String toString() {
    return 'Meal{id: $id,foods: $foods}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      "foods": foods.map((e) => {
        "food": e.food,
        "quantity": e.quantity
      })
    };
  }
}

class FoodCalculate {
  DocumentReference<Food> food;
  double quantity;

  FoodCalculate({required this.food, required this.quantity});

  @override
  String toString() {
    return 'FoodCalculate{food: $food, quantity: $quantity}';
  }
}