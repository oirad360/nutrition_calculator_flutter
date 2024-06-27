import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {

  List<FoodCalculate> foods;
  String name;
  String id;
  List<String> foodIds;

  Meal({required this.foods, required this.name, this.id = '', required this.foodIds});

  factory Meal.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Meal(
      id: snapshot.id,
      foodIds: (data?['foodIds'] as List<dynamic>)
        .map((item) => item as String).toList(),
      name: data?['name'],
      foods: (data?['foods'] as List<dynamic>)
          .map((item) => FoodCalculate.fromFirestore(item))
          .toList()
    );
  }


  @override
  String toString() {
    return 'Meal{id: $id, name: $name, foods: $foods, foodIds: $foodIds}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "foodIds": foodIds,
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