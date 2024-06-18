import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/constants.dart';
import 'package:nutrition_calculator_flutter/screens/home.dart';

import '../screens/auth_page.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({super.key, this.selectedTile});

  String? selectedTile;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Future<void> signOut() async {
    try {
      await AuthService().signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(Constants.appTitle, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 30)),
                        if (snapshot.hasData) Text('Benvenuto ${AuthService().user!.email}!', style: TextStyle(color: Theme.of(context).colorScheme.secondary),)
                      ],
                    ),
                  )
                ),
              ),
              ListTile(
                title: const Text('Home', style: TextStyle(fontSize: 20)),
                selected: widget.selectedTile == SelectedTile.home,
                onTap: () {
                  if (widget.selectedTile != SelectedTile.home) {
                    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const MyHomePage(title: Constants.appTitle)));
                  }
                },
              ),
              if (!snapshot.hasData) ListTile(
                title: const Text('Accedi', style: TextStyle(fontSize: 20)),
                selected: widget.selectedTile == SelectedTile.accedi,
                onTap: () {
                  if (widget.selectedTile != SelectedTile.accedi) {
                    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const AuthPage()));
                  }
                },
              ) else ListTile(
                title: const Text('Esci', style: TextStyle(fontSize: 20)),
                onTap: () {
                  signOut();
                },
              )
            ],
          );
        },
      )
    );
  }
}
