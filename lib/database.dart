import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/food.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _food = FirebaseFirestore.instance.collection('food').withConverter(
    fromFirestore: Food.fromFirestore,
    toFirestore: (Food food, options) => food.toFirestore(),
  );

  Future<DocumentReference<Food>> addFood(Food food) async {
    return await _food.add(food);
  }

  Stream<List<Food>> getUserFood(String userUID) {
    return _food.where('userUID', isEqualTo: userUID)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
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