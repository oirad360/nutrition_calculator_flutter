import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  List<Map<String, dynamic>> foods;
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
      "foods": foods
    };
  }
}