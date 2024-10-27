import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/database.dart';
import 'package:nutrition_calculator_flutter/models/food.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';
import 'package:nutrition_calculator_flutter/widgets/my_dropdown_button.dart';

import '../auth.dart';
import '../widgets/my_text_input.dart';

class AddFood extends StatefulWidget {
  AddFood({super.key, this.food});

  Food? food;

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService = AuthService();
  late Food _food;
  final List<DropdownMenuItem> _dropDownList =<DropdownMenuItem>[
    const DropdownMenuItem(value: UnitOfMeasure.g, child: Text('g')),
    const DropdownMenuItem(value: UnitOfMeasure.ml, child: Text('ml')),
    const DropdownMenuItem(value: UnitOfMeasure.portion, child: Text('portions'))
  ];
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();
  final _proteinController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _food = widget.food ?? Food(name: '', quantity: 0, unitOfMeasure: UnitOfMeasure.g, calories: 0, fat: 0, carbs: 0, protein: 0, description: '');
    _nameController.text = _food.name;
    _caloriesController.text = _food.calories - _food.calories.truncate() > 0 ? _food.calories.toStringAsFixed(2) : _food.calories.truncate().toString();
    _fatController.text = _food.fat! - _food.fat!.truncate() > 0 ? _food.fat!.toStringAsFixed(2) : _food.fat!.truncate().toString();
    _carbsController.text = _food.carbs! - _food.carbs!.truncate() > 0 ? _food.carbs!.toStringAsFixed(2) : _food.carbs!.truncate().toString();
    _proteinController.text = _food.protein! - _food.protein!.truncate() > 0 ? _food.protein!.toStringAsFixed(2) : _food.protein!.truncate().toString();
    _quantityController.text = _food.quantity - _food.quantity.truncate() > 0 ? _food.quantity.toStringAsFixed(2) : _food.quantity.truncate().toString();
    _descriptionController.text = _food.description != null ? _food.description.toString() : '';
  }

  _clearForm() {
    setState(() {
      _food = Food(name: '', quantity: 0, unitOfMeasure: UnitOfMeasure.g, calories: 0, fat: 0, carbs: 0, protein: 0, description: '');
      _nameController.text = '';
      _caloriesController.text = '0';
      _fatController.text = '0';
      _carbsController.text = '0';
      _proteinController.text = '0';
      _quantityController.text = '0';
      _descriptionController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        title: _food.id != '' ? const Text('Modify food') : const Text('Add food'),
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
                    controller:  _nameController,
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
                    controller:  _caloriesController,
                    onChanged: (value) => {
                      setState(() {
                        _food.calories = value != '' ? double.parse(value!) : 0;
                      })
                    },
                  ),
                  MyTextInputFormField(
                    label: 'Fat',
                    type: InputType.Decimal,
                    controller:  _fatController,
                    onChanged: (value) => {
                      setState(() {
                        _food.fat = value != '' ? double.parse(value!) : 0;
                      })
                    },
                  ),
                  MyTextInputFormField(
                    label: 'Carbs',
                    type: InputType.Decimal,
                    controller:  _carbsController,
                    onChanged: (value) => {
                      setState(() {
                        _food.carbs = value != '' ? double.parse(value!) : 0;
                      })
                    },
                  ),
                  MyTextInputFormField(
                    label: 'Protein',
                    type: InputType.Decimal,
                    controller:  _proteinController,
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
                          controller:  _quantityController,
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
                    controller: _descriptionController,
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
      floatingActionButton: _food.name != '' && _food.quantity > 0 &&
          (_food.fat! > 0 || _food.carbs! > 0 || _food.protein! > 0) ?
        FloatingActionButton(
            onPressed: () {
              if (_food.id != '') {
                _dbService.updateFood(_authService.user!.uid, _food).then((snapshot) => {
                  setState(() {
                    _clearForm();
                  }),
                  Navigator.pop(context),
                  showDialog(context: context, builder: (context) {
                    return const AlertDialog(
                      title: Text('Food modified!'),
                    );
                  })
                });
              } else {
                _dbService.addFood(_authService.user!.uid, _food).then((snapshot) => {
                  setState(() {
                    _clearForm();
                  }),
                  showDialog(context: context, builder: (context) {
                    return const AlertDialog(
                      title: Text('New food added!'),
                    );
                  })
                });
              }

            },
            tooltip: _food.id != '' ? 'Modify food' : 'Add food',
            backgroundColor: Theme.of(context).colorScheme.secondary,
            heroTag: 'submitFormButton',
            child: Icon(_food.id != '' ? Icons.border_color : Icons.check, color: Theme.of(context).colorScheme.primary)
        ) : const Offstage()
    );
  }
}
