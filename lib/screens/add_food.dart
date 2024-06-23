import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/database.dart';
import 'package:nutrition_calculator_flutter/models/food.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';
import 'package:nutrition_calculator_flutter/widgets/my_dropdown_button.dart';

import '../auth.dart';
import '../widgets/my_text_input.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService = AuthService();
  final Food _food = Food(name: '', quantity: 0, unitOfMeasure: UnitOfMeasure.g, calories: 0, fat: 0, carbs: 0, protein: 0, userUID: '');
  final List<DropdownMenuItem> _dropDownList =<DropdownMenuItem>[
    const DropdownMenuItem(value: UnitOfMeasure.g, child: Text('g')),
    const DropdownMenuItem(value: UnitOfMeasure.ml, child: Text('ml')),
    const DropdownMenuItem(value: UnitOfMeasure.portion, child: Text('portions'))
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        title: const Text('Add food'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 85.0, top: 15.0, bottom: 15.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyTextInputFormField(
                    label: 'Name',
                    initialValue: _food.name,
                    maxLength: 50,
                    onChanged: (value) => {
                      setState(() {
                        _food.name = value!;
                      })
                    },
                  ),
                  MyTextInputFormField(
                    label: 'Calories',
                    type: InputType.Decimal,
                    initialValue: _food.calories.toString(),
                    onChanged: (value) => {
                      setState(() {
                        _food.calories = value != '' ? double.parse(value!) : 0;
                      })
                    },
                  ),
                  MyTextInputFormField(
                    label: 'Fat',
                    type: InputType.Decimal,
                    initialValue: _food.fat.toString(),
                    onChanged: (value) => {
                      setState(() {
                        _food.fat = value != '' ? double.parse(value!) : 0;
                      })
                    },
                  ),
                  MyTextInputFormField(
                    label: 'Carbs',
                    type: InputType.Decimal,
                    initialValue: _food.carbs.toString(),
                    onChanged: (value) => {
                      setState(() {
                        _food.carbs = value != '' ? double.parse(value!) : 0;
                      })
                    },
                  ),
                  MyTextInputFormField(
                    label: 'Protein',
                    type: InputType.Decimal,
                    initialValue: _food.protein.toString(),
                    onChanged: (value) => {
                      setState(() {
                        _food.protein = value != '' ? double.parse(value!) : 0;
                      })
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInputFormField(
                          label: 'Quantity',
                          type: InputType.Decimal,
                          initialValue: _food.quantity.toString(),
                          onChanged: (value) => {
                            setState(() {
                              _food.quantity = value != '' ? double.parse(value!) : 0;
                            })
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 109),
                        child: MyDropdownButtonFormField(
                          dropDownList: _dropDownList,
                          onChanged: (value) => {
                            setState(() {
                              _food.unitOfMeasure = value;
                            })
                          },
                          initialValue: _food.unitOfMeasure,
                        ),
                      ),
                    ],
                  ),
                  MyTextInputFormField(
                    label: 'Description',
                    initialValue: _food.description,
                    maxLength: 500,
                    maxLines: 10,
                    minLines: 1,
                    onChanged: (value) => {
                      setState(() {
                        _food.description = value!;
                      })
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _food.name != '' && _food.calories > 0 && _food.quantity > 0 &&
          (_food.fat! > 0 || _food.carbs! > 0 || _food.protein! > 0) ?
      FloatingActionButton(
        onPressed: () {
          _food.userUID = _authService.user!.uid;
          _dbService.addFood(_food).then((snapshot) => {
            showDialog(context: context, builder: (context) {
              return const AlertDialog(
                title: Text('New food added!'),
              );
            })
          });
        },
        tooltip: 'Add food',
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
      ) : null,
    );
  }
}
