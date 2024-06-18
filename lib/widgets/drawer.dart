import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/constants.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

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
              if (!snapshot.hasData) const ListTile(
                title: Text('Accedi', style: TextStyle(fontSize: 20)),
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
