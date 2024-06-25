import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/models/meal.dart';
import 'package:nutrition_calculator_flutter/screens/calculate.dart';
import 'package:nutrition_calculator_flutter/screens/food_table.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';
import 'package:nutrition_calculator_flutter/widgets/tab_horizontal.dart';
import '../constants.dart';
import '../database.dart';
import '../models/food.dart';

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
  late String _mealName;
  int _tabIndex = 0;
  List<Map<String, dynamic>> _foodsCalculate = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  void _addMeal(String userUID, String name, List<Map<String, dynamic>> foods) async {
    // use Future.wait to wait all futures resolution
    List<FoodCalculate> newEntries = await Future.wait(foods.map((e) async {
      return FoodCalculate(food: await _dbService.getFoodRef(userUID, e['food'].id), quantity: e['food'].quantity);
    }).toList());

    _dbService.addMeal(_authService.user!.uid, name, newEntries).then((snapshot) {
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          title: Text('New meal added!'),
        );
      });
    });
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
              controller: _tabController,
              labelPadding: const EdgeInsets.symmetric(horizontal: 10),
              unselectedLabelColor: Colors.black45,
              labelColor: Theme.of(context).colorScheme.secondary,
              tabs: const [
                TabHorizontal(icon: Icons.table_chart, text: 'Food Table'),
                TabHorizontal(icon: Icons.calculate, text: 'Calculate'),
                TabHorizontal(icon: Icons.food_bank_rounded, text: 'Meals'),
              ],
            ),
          ),
          drawer: MyDrawer(selectedTile: SelectedTile.home),
          body: authSnapshot.hasData ? TabBarView(
                    controller: _tabController,
                    children: [
                      StreamBuilder(
                          stream: _dbService.getUserFood(_authService.user!.uid),
                          builder: (context, foodSnapshot) {
                            if (foodSnapshot.hasData) return FoodTable(foods: foodSnapshot.data, addFoodCalculate: _addFoodCalculate);
                            if (foodSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).colorScheme.primary,
                                  )
                              );
                            }
                            return const Center(child: Text('Add some food!'));
                          }
                      ),
                      if(_foodsCalculate.isNotEmpty) Calculate(
                        foods: _foodsCalculate,
                        deleteFoodCalculate: _deleteFoodCalculate,
                        updateFoodCalculate: _updateFoodCalculate,
                          updateMealName: _updateMealName,
                        addMeal: () {
                          _addMeal(_authService.user!.uid, _mealName, _foodsCalculate);
                        }
                      )
                      else const Center(child: Text('Long press on a record from your food table to calculate a meal!', textAlign: TextAlign.center,)),
                      const Center(
                        child: Text('Meals'),
                      ),
                    ]
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
