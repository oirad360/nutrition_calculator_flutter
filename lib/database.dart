import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<List<Food>> getFood(String userUID) {
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

  Future<void> updateFood(String userUID, Food food) {
    return _db.collection('user').doc(userUID).collection('foods')
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: (Food food, options) => food.toFirestore()
        ).doc(food.id).update(food.toFirestore());
  }

  Future<void> deleteFood(String userUID, String foodID) async {
    var userRef = _db.collection('user').doc(userUID);
    // Step 1: Query per trovare i pasti che contengono foodID nel campo 'foodIds'
    var mealsQuerySnapshot = await userRef.collection('meals')
        .where('foodIds', arrayContains: foodID)
        .withConverter(
        fromFirestore: Meal.fromFirestore,
        toFirestore: (Meal meal, options) => meal.toFirestore()
    ).get();

    var batch = _db.batch();

    for (var mealDoc in mealsQuerySnapshot.docs) {
      var meal = mealDoc.data();
      var updatedFoods = meal.foods.where((food) => food.foodId != foodID).toList();
      var updatedFoodIds = meal.foodIds.where((id) => id != foodID).toList();
      meal.foods = updatedFoods;
      meal.foodIds = updatedFoodIds;

      if (updatedFoodIds.isEmpty) {
        batch.delete(mealDoc.reference);
      } else {
        batch.update(mealDoc.reference, meal.toFirestore());
      }
    }

    batch.delete(userRef.collection('foods').doc(foodID));

    await batch.commit();
  }


  Future<DocumentReference<Meal>> addMeal(String userUID, Meal meal) async {
    return _db.collection('user').doc(userUID).collection('meals')
        .withConverter(
        fromFirestore: Meal.fromFirestore,
        toFirestore: (Meal meal, options) => meal.toFirestore()
    ).add(meal);
  }

  Stream<List<Meal>> getMeals(String userUID) {
    return _db.collection('user').doc(userUID).collection('meals')
        .withConverter(
          fromFirestore: Meal.fromFirestore,
          toFirestore: (Meal meal, options) => meal.toFirestore()
        ).snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final meal = doc.data();
          return Meal(
            foodIds: meal.foodIds,
            id: doc.id,
            name: meal.name,
            foods: meal.foods
          );
        }).toList());
  }

  Future<void> updateMeal(String userUID, Meal meal) {
    return _db.collection('user').doc(userUID).collection('meals')
          .withConverter(
            fromFirestore: Meal.fromFirestore,
            toFirestore: (Meal meal, options) => meal.toFirestore()
          ).doc(meal.id).update(meal.toFirestore());
  }

  Future<void> deleteMeal(String userUID, String mealID) {
    return _db.collection('user').doc(userUID).collection('meals').doc(mealID).delete();
  }

  // Stream<List<MyMeal>> getUserMeals(String userUID) {
  //   return _db.collection('user').doc(userUID).collection('meals')
  //       .withConverter<Meal>(
  //     fromFirestore: Meal.fromFirestore,
  //     toFirestore: (Meal meal, options) => meal.toFirestore(),
  //   ).snapshots().asyncMap((snapshot) async {
  //     return await Future.wait(snapshot.docs.map((doc) async {
  //       final meal = doc.data();
  //       final foodList = await Future.wait(meal.foods.map((foodCalculate) async {
  //         final foodDoc = await foodCalculate.food.get();
  //         return MyFoodCalculate(food: foodDoc.data(), quantity: foodCalculate.quantity);
  //       }).toList());
  //       return MyMeal(name: meal.name, foods: foodList);
  //     }).toList());
  //   });
  // }

}