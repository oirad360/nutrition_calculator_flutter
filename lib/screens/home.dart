import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';
import 'package:nutrition_calculator_flutter/widgets/tab_horizontal.dart';
import '../constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
        body: TabBarView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const Center(
              child: Text('Calculate'),
            ),
            const Center(
              child: Text('Meals'),
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
