import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutrition_calculator_flutter/models/food.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';
import 'package:nutrition_calculator_flutter/widgets/my_dropdown_button.dart';

import '../widgets/my_text_input.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final _formKey = GlobalKey<FormState>();
  final Map _data = {
    'name': '',
    'description': '',
    'calories': 0,
    'fat': 0,
    'carbs': 0,
    'protein': 0,
    'quantity': 0,
    'unitOfMeasure': UnitOfMeasure.g
  };
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
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyTextInputFormField(
                    label: 'Name',
                    initialValue: _data['name'],
                    maxLength: 50,
                    onSaved: (value) => _data['calories'] = value!,
                  ),
                  MyTextInputFormField(
                    label: 'Calories',
                    type: InputType.Decimal,
                    initialValue: _data['calories'].toString(),
                    onSaved: (value) => _data['calories'] = double.parse(value!),
                  ),
                  MyTextInputFormField(
                    label: 'Fat',
                    type: InputType.Decimal,
                    initialValue: _data['fat'].toString(),
                    onSaved: (value) => _data['fat'] = double.parse(value!),
                  ),
                  MyTextInputFormField(
                    label: 'Carbs',
                    type: InputType.Decimal,
                    initialValue: _data['carbs'].toString(),
                    onSaved: (value) => _data['carbs'] = double.parse(value!),
                  ),
                  MyTextInputFormField(
                    label: 'Protein',
                    type: InputType.Decimal,
                    initialValue: _data['protein'].toString(),
                    onSaved: (value) => _data['protein'] = double.parse(value!),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInputFormField(
                          label: 'Quantity',
                          type: InputType.Decimal,
                          initialValue: _data['quantity'].toString(),
                          onSaved: (value) => _data['quantity'] = double.parse(value!),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 109),
                        child: MyDropdownButtonFormField(
                          dropDownList: _dropDownList,
                          onChanged: (value) => _data['unitOfMeasure'] = value,
                          initialValue: _data['unitOfMeasure'],
                        ),
                      ),
                    ],
                  ),
                  MyTextInputFormField(
                    label: 'Description',
                    initialValue: _data['description'],
                    maxLength: 500,
                    maxLines: 10,
                    minLines: 1,
                    onSaved: (value) => _data['description'] = value!,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
