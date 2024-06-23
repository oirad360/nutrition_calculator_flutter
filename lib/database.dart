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

  Stream<QuerySnapshot> getUserFood(String userUID) {
    return _food.where('userUID', isEqualTo: userUID).snapshots();
  }

}