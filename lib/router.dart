import 'package:nutrition_calculator_flutter/screens/home.dart';
import 'package:nutrition_calculator_flutter/screens/auth_page.dart';
import 'package:nutrition_calculator_flutter/screens/add_food.dart';
import 'package:nutrition_calculator_flutter/constants.dart';
import 'package:flutter/material.dart';

import 'models/food.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        if (args is String) {
          return MaterialPageRoute(builder: (context) => MyHomePage(title: args));
        }
        return MaterialPageRoute(builder: (context) => const MyHomePage(title: Constants.appTitle));
      case '/auth':
        return MaterialPageRoute(builder: (context) => const AuthPage());
      case '/addFood':
        if (args is Food) {
          return MaterialPageRoute(builder: (context) => AddFood(food: args));
        }
        return MaterialPageRoute(builder: (context) => AddFood());
      default:
        return MaterialPageRoute(
          builder: (context) => const Placeholder(),
        );
    }
  }
}