import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/constants.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(Constants.appTitle, style: Theme.of(context).textTheme.headlineLarge,)
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
