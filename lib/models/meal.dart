import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {

  List<FoodCalculate> foods;
  String name;
  String id;

  Meal({required this.foods, required this.name, this.id = '',});

  factory Meal.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Meal(
      id: snapshot.id,
      name: data?['name'],
      foods: (data?['foods'] as List<dynamic>)
          .map((item) => FoodCalculate.fromFirestore(item))
          .toList()
    );
  }


  @override
  String toString() {
    return 'Meal{id: $id, name: $name, foods: $foods}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "foods": foods.map((e) => {
        "foodId": e.foodId,
        "quantity": e.quantity
      })
    };
  }
}

class FoodCalculate {
  String foodId;
  double quantity;

  FoodCalculate({required this.foodId, required this.quantity});

  factory FoodCalculate.fromFirestore(Map<String, dynamic> data) {
    return FoodCalculate(
      foodId: data['foodId'] ?? '',
      quantity: (data['quantity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "foodId": foodId,
      "quantity": quantity,
    };
  }

  @override
  String toString() {
    return 'FoodCalculate{foodId: $foodId, quantity: $quantity}';
  }
}