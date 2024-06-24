import 'package:cloud_firestore/cloud_firestore.dart';

enum UnitOfMeasure {
  g,
  ml,
  portion
}

extension UnitOfMeasureExtension on UnitOfMeasure {
  static const Map<UnitOfMeasure, String> _toString = {
    UnitOfMeasure.g: 'g',
    UnitOfMeasure.ml: 'ml',
    UnitOfMeasure.portion: 'portion',
  };

  static const Map<String, UnitOfMeasure> _fromString = {
    'g': UnitOfMeasure.g,
    'ml': UnitOfMeasure.ml,
    'portion': UnitOfMeasure.portion,
  };

  String toShortString() => _toString[this]!;

  static UnitOfMeasure fromShortString(String string) => _fromString[string]!;
}

class Food {
  String id;
  String name;
  String? description;
  double calories;
  double? fat;
  double? carbs;
  double? protein;
  double quantity;
  UnitOfMeasure unitOfMeasure;
  String? _userUID;

  set userUID(String userUID) {
    _userUID = userUID;
  }

  Food({required this.name, required this.quantity, required this.calories, required this.unitOfMeasure, this.id = '', this.description, this.fat, this.carbs, this.protein, String? userUID}) : _userUID = userUID;

  factory Food.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Food(
      id: snapshot.id,
      name: data?['name'],
      description: data?['description'],
      calories: data?['calories'],
      fat: data?['fat'],
      carbs: data?['carbs'],
      protein: data?['protein'],
      quantity: data?['quantity'],
      userUID: data?['userUID'],
      unitOfMeasure: UnitOfMeasureExtension.fromShortString(data?['unitOfMeasure']),
    );
  }


  @override
  String toString() {
    return 'Food{id: $id, name: $name, description: $description, calories: $calories, fat: $fat, carbs: $carbs, protein: $protein, quantity: $quantity, unitOfMeasure: $unitOfMeasure, userUID: $_userUID}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "quantity": quantity,
      "unitOfMeasure": unitOfMeasure.toShortString(),
      "calories": calories,
      "userUID": _userUID,
      if (description != null) "description": description,
      if (fat != null) "fat": fat,
      if (carbs != null) "carbs": carbs,
      if (protein != null) "protein": protein
    };
  }
}