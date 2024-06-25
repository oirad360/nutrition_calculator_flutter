import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_calculator_flutter/models/my_meal.dart';
import 'models/food.dart';
import 'models/meal.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<DocumentReference<Food>> addFood(String userUID, Food food) async {
    return _db.collection('user').doc(userUID).collection('foods')
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: (Food food, options) => food.toFirestore()
        ).add(food);
  }

  Future<DocumentReference<Food>> getFoodRef(String userUID, String foodId) async {
    return _db.collection('user').doc(userUID).collection('foods')
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: (Food food, options) => food.toFirestore()
        ).doc(foodId);
  }

  Future<DocumentReference<Meal>> addMeal(String userUID, String name, List<FoodCalculate> entries) async {
    return _db.collection('user').doc(userUID).collection('meals')
        .withConverter(
        fromFirestore: Meal.fromFirestore,
        toFirestore: (Meal meal, options) => meal.toFirestore()
    ).add(Meal(name: name, foods: entries));
  }

  Stream<List<Food>> getUserFood(String userUID) {
    return _db.collection('user').doc(userUID).collection('foods')
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: (Food food, options) => food.toFirestore()
        ).snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final food = doc.data();
          return Food(
            id: doc.id,
            name: food.name,
            quantity: food.quantity,
            calories: food.calories,
            unitOfMeasure: food.unitOfMeasure,
            description: food.description,
            fat: food.fat,
            carbs: food.carbs,
            protein: food.protein,
          );
        }).toList());
  }

  // Stream<List<Meal>> getUserMeals(String userUID) {
  //   return _db.collection('user').doc(userUID).collection('meals')
  //       .withConverter(
  //       fromFirestore: Meal.fromFirestore,
  //       toFirestore: (Meal meal, options) => meal.toFirestore()
  //   ).snapshots().map((snapshot) => snapshot.docs.map((doc) {
  //     final meal = doc.data();
  //     return Meal(
  //         id: doc.id,
  //         name: meal.name,
  //         foods: meal.foods
  //     );
  //   }).toList());
  // }

  Stream<List<MyMeal>> getUserMeals(String userUID) {
    return _db.collection('user').doc(userUID).collection('meals')
        .withConverter<Meal>(
      fromFirestore: Meal.fromFirestore,
      toFirestore: (Meal meal, options) => meal.toFirestore(),
    ).snapshots().asyncMap((snapshot) async {
      return await Future.wait(snapshot.docs.map((doc) async {
        final meal = doc.data();
        final foodList = await Future.wait(meal.foods.map((foodCalculate) async {
          final foodDoc = await foodCalculate.food.get();
          return MyFoodCalculate(food: foodDoc.data(), quantity: foodCalculate.quantity);
        }).toList());
        return MyMeal(name: meal.name, foods: foodList);
      }).toList());
    });
  }

}