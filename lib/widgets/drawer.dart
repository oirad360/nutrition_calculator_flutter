import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/constants.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: StreamBuilder(
        stream: AuthService().userChanges,
        builder: (context, snapshot) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(child: Text(Constants.appTitle, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 30))),
              ),
              if (!snapshot.hasData) const ListTile(
                title: Text('Login', style: TextStyle(fontSize: 20)),
              )
            ],
          );
        },
      )
    );
  }
}
