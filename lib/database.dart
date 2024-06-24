import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/food.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<DocumentReference<Food>> addFood(String userUID, Food food) async {
    return await _db.collection('user').doc(userUID).collection('foods')
        .withConverter(
          fromFirestore: Food.fromFirestore,
          toFirestore: (Food food, options) => food.toFirestore()
        ).add(food);
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
}