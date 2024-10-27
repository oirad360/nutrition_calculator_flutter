import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/models/meal.dart';
import 'package:nutrition_calculator_flutter/screens/calculate.dart';
import 'package:nutrition_calculator_flutter/screens/diary.dart';
import 'package:nutrition_calculator_flutter/screens/food_table.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';
import 'package:nutrition_calculator_flutter/widgets/tab_horizontal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../database.dart';
import '../models/food.dart';
import 'meals.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  late TabController _tabController;
  String _mealName = '';
  String _mealID = '';
  int _tabIndex = 0;
  List<Food> _foods = [];
  List<Map<String, dynamic>> _foodsCalculate = [];
  final _mealNameController = TextEditingController();
  final Map<String, TextEditingController> _calculateMealControllers = {};
  late final List<String> _diary;

  @override
  void initState() {
    super.initState();
    _loadDiary();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _tabIndex = _tabController.index;
    });
  }

  void _addFoodCalculate(double quantity, Food food) {
    setState(() {
      _foodsCalculate.add({
        'food': food,
        'quantity': quantity
      });
    });
  }

  void _deleteFoodCalculate(String foodId) {
    setState(() {
      _foodsCalculate.removeWhere((entry) => entry['food'].id == foodId);
    });
  }

  void _updateFoodCalculate(String foodId, double quantity) {
    setState(() {
      _foodsCalculate = _foodsCalculate.map((entry) => entry['food'].id != foodId ? entry : {
        'food': entry['food'],
        'quantity': quantity
      }).toList();
    });
  }

  void _updateMealName(String value) {
    setState(() {
      _mealName = value;
    });
  }

  void _addMeal(String name, List<Map<String, dynamic>> foods) async {
    // use Future.wait to wait all futures resolution
    List<String> foodIds = [];
    List<FoodCalculate> newEntries = await Future.wait(foods.map((e) async {
      foodIds.add(e['food'].id);
      return FoodCalculate(foodId: e['food'].id, quantity: e['quantity']);
    }).toList());

    _dbService.addMeal(_authService.user!.uid, Meal(foodIds: foodIds, name: name, foods: newEntries)).then((snapshot) {
      _undoUpdate();
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          title: Text('New meal added!'),
        );
      });
    });
  }

  void _addMealToDiary(String mealId) {
    setState(() {
      _diary.add(mealId);
    });
    _saveDiary();
  }

  void _removeMealFromDiary(int index) {
    setState(() {
      _diary.removeAt(index);
    });
    _saveDiary();
  }

  void _deleteMeal(String mealID) {
    _dbService.deleteMeal(_authService.user!.uid, mealID).then((snapshot) {
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          title: Text('Meal deleted!'),
        );
      });
    });
  }

  void _fillUpdateMeal(Meal meal, bool isNew) {
    setState(() {
      _foodsCalculate = [];
      _calculateMealControllers.clear();
      for (var element in meal.foods) {
        _foodsCalculate.add({
          'food': _foods.firstWhere((food) => food.id == element.foodId),
          'quantity': element.quantity
        });
        _calculateMealControllers[element.foodId] = TextEditingController(text:
          element.quantity - element.quantity.truncate() > 0 ? element.quantity.toString() : element.quantity.toInt().toString()
        );
      }
      _mealName = meal.name;
      _mealID = !isNew ? meal.id : '';
      _mealNameController.text = meal.name;
    });
    _tabController.animateTo(1);
    _tabIndex = 1;
  }

  void _deleteFood(String foodID) {
    _dbService.deleteFood(_authService.user!.uid, foodID).then((snapshot) {
      setState(() {
        _foodsCalculate = _foodsCalculate.where((element) => element['food'].id != foodID).toList();
      });
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          title: Text('Food deleted!'),
        );
      });
    });
  }

  void _updateFood(Food food) async {
    Navigator.pushNamed(context, "/addFood", arguments: food);
  }

  void _updateMeal(String name, List<Map<String, dynamic>> foods) async {
    // use Future.wait to wait all futures resolution
    List<String> foodIds = [];
    List<FoodCalculate> newEntries = await Future.wait(foods.map((e) async {
      foodIds.add(e['food'].id);
      return FoodCalculate(foodId: e['food'].id, quantity: e['quantity']);
    }).toList());

    _dbService.updateMeal(_authService.user!.uid, Meal(foodIds: foodIds, name: name, foods: newEntries, id: _mealID)).then((snapshot) {
      _undoUpdate();
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          title: Text('Meal modified!'),
        );
      });
    });
  }

  void _undoUpdate() {
    setState(() {
      _mealID = '';
      _mealName = '';
      _foodsCalculate = [];
      _mealNameController.text = '';
      _calculateMealControllers.clear();
    });
  }

  Future<void> _loadDiary() async {
    final prefs = await SharedPreferences.getInstance();
    final mealsData = prefs.getString('diaryMeals');
    if (mealsData != null) {
      final List<dynamic> decodedData = jsonDecode(mealsData);
      setState(() {
        _diary = [];
        for (var data in decodedData) {
          _diary.add(data as String);
        }
      });
    }
  }

  Future<void> _saveDiary() async {
    final prefs = await SharedPreferences.getInstance();
    final mealsData = jsonEncode(_diary.toList());
    await prefs.setString('diaryMeals', mealsData);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _authService.userChanges,
        builder: (context, authSnapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              titleTextStyle: Theme.of(context).textTheme.titleLarge,
              title: Text(widget.title),
              elevation: 7,
              shadowColor: Colors.black,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                unselectedLabelColor: Colors.black45,
                labelColor: Theme.of(context).colorScheme.secondary,
                tabs: const [
                  TabHorizontal(icon: Icons.table_chart, text: 'Food Table'),
                  TabHorizontal(icon: Icons.calculate, text: 'Calculate'),
                  TabHorizontal(icon: Icons.food_bank_rounded, text: 'Meals'),
                  TabHorizontal(icon: Icons.book, text: 'Diary'),
                ],
              ),
            ),
            drawer: MyDrawer(selectedTile: SelectedTile.home),
            body: authSnapshot.hasData ? StreamBuilder(
                stream: _dbService.getFood(_authService.user!.uid),
                builder: (context, foodSnapshot) {
                  if (foodSnapshot.hasData) {
                    _foods = foodSnapshot.data as List<Food>;
                  }
                  return TabBarView(
                      controller: _tabController,
                      children: [
                        if (foodSnapshot.hasData && foodSnapshot.data!.isNotEmpty) FoodTable(foods: foodSnapshot.data, addFoodCalculate: _addFoodCalculate, deleteFood: _deleteFood, updateFood: _updateFood,)
                        else if (foodSnapshot.hasData && foodSnapshot.data!.isEmpty) const Center(child: Text('Add some food!'))
                        else if (foodSnapshot.connectionState == ConnectionState.waiting) Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            )
                        ) else const Center(child: Text('Add some food!')),
                        if(_foodsCalculate.isNotEmpty) Calculate(
                          mealID: _mealID,
                          mealName: _mealName,
                          foods: _foodsCalculate,
                          deleteFoodCalculate: _deleteFoodCalculate,
                          updateFoodCalculate: _updateFoodCalculate,
                          updateMealName: _updateMealName,
                          updateMeal: () {
                            _updateMeal(_mealName, _foodsCalculate);
                          },
                          addMeal: () {
                            _addMeal(_mealName, _foodsCalculate);
                          },
                          undoUpdate: _undoUpdate,
                          mealNameController: _mealNameController,
                          controllers: _calculateMealControllers,
                        )
                        else const Center(child: Text('Select a record from your food table to calculate a meal!', textAlign: TextAlign.center,)),
                        StreamBuilder(
                            stream: _dbService.getMeals(_authService.user!.uid),
                            builder: (context, mealSnapshot) {
                              if (mealSnapshot.hasData && mealSnapshot.data!.isNotEmpty) {
                                return Meals(meals: mealSnapshot.data, foods: foodSnapshot.data, deleteMeal: _deleteMeal, fillUpdateMeal: _fillUpdateMeal, addMealToDiary: _addMealToDiary,);
                              } else if (mealSnapshot.hasData && mealSnapshot.data!.isEmpty) {
                                return const Center(child: Text('You didn\'t save any meal!'));
                              }
                              else if (mealSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).colorScheme.primary,
                                    )
                                );
                              }
                              return const Center(child: Text('You didn\'t save any meal!'));
                            }
                        ),
                        StreamBuilder(
                            stream: _dbService.getMeals(_authService.user!.uid),
                            builder: (context, mealSnapshot) {
                              if (mealSnapshot.hasData && mealSnapshot.data!.isNotEmpty && _diary.isNotEmpty) {
                                return Diary(
                                    meals: _diary.map((mealId) => mealSnapshot.data?.firstWhere((meal) => meal.id == mealId)).toList(),
                                    foods: _foods,
                                    removeMealFromDiary: _removeMealFromDiary
                                );
                              } else if (mealSnapshot.hasData && (mealSnapshot.data!.isEmpty || _diary.isNotEmpty)) {
                                return const Center(child: Text('You didn\'t add any meal to your diary!'));
                              }
                              else if (mealSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).colorScheme.primary,
                                    )
                                );
                              }
                              return const Center(child: Text('Login to see your diary!'));
                            }
                        ),
                      ]
                  );
                }
            ) :
            TabBarView(
                controller: _tabController,
                children: const [
                  Center(
                    child: Text('Login to show your foods!'),
                  ),
                  Center(
                    child: Text('Login to calculate your meals!'),
                  ),
                  Center(
                    child: Text('Login to show your meals!'),
                  ),
                  Center(
                    child: Text('Login to show your diary!'),
                  ),
                ]
            ),
            floatingActionButton: _tabIndex == 0 && authSnapshot.hasData ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addFood');
              },
              tooltip: 'Add food',
              child: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
            ) : null,
          );
        }
    );
  }

}
