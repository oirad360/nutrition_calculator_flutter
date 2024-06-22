import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutrition_calculator_flutter/models/food.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';

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
    'calories': 0.0,
    'fat': 0.0,
    'carbs': 0.0,
    'protein': 0.0,
    'quantity': 0.0,
    'unitOfMeasure': UnitOfMeasure.g
  };
  List<DropdownMenuItem> _dropDownList =<DropdownMenuItem>[
    DropdownMenuItem(value: UnitOfMeasure.g, child: Text('g')),
    DropdownMenuItem(value: UnitOfMeasure.ml, child: Text('ml')),
    DropdownMenuItem(value: UnitOfMeasure.portion, child: Text('portions'))
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
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyTextInput(
                    label: 'Calories',
                    type: InputType.Decimal,
                    onSaved: (value) => _data['calories'] = double.parse(value!),
                  ),
                  MyTextInput(
                    label: 'Fat',
                    type: InputType.Decimal,
                    onSaved: (value) => _data['fat'] = double.parse(value!),
                  ),
                  MyTextInput(
                    label: 'Carbs',
                    type: InputType.Decimal,
                    onSaved: (value) => _data['carbs'] = double.parse(value!),
                  ),
                  MyTextInput(
                    label: 'Protein',
                    type: InputType.Decimal,
                    onSaved: (value) => _data['protein'] = double.parse(value!),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          label: 'Quantity',
                          type: InputType.Decimal,
                          onSaved: (value) => _data['quantity'] = double.parse(value!),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 109),
                        child: DropdownButtonFormField(
                          items: _dropDownList,
                          onChanged: (value) => _data['unitOfMeasure'] = value,
                          value: _data['unitOfMeasure'],
                          decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
