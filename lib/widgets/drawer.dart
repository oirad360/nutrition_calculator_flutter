import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/constants.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({super.key, this.selectedTile});

  String? selectedTile;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> signOut() async {
    try {
      await _authService.signOut();
      return {
        "res": Constants.OK
      };
    } on FirebaseAuthException catch (e) {
      print(e);
      return {
        "res": Constants.KO,
        "code": e.code
      };
    }
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: StreamBuilder(
        stream: _authService.userChanges,
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
                        if (snapshot.hasData) Text('Benvenuto ${_authService.user!.email}!', style: TextStyle(color: Theme.of(context).colorScheme.secondary),)
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
                    Navigator.pop(context); // must pop before pushing a new screen to close the drawer
                    Navigator.pushNamed(context, '/home', arguments: snapshot.hasData ? Constants.appTitle : 'loggati');
                  }
                },
              ),
              if (!snapshot.hasData) ListTile(
                title: const Text('Accedi', style: TextStyle(fontSize: 20)),
                selected: widget.selectedTile == SelectedTile.auth,
                onTap: () {
                  if (widget.selectedTile != SelectedTile.auth) {
                    Navigator.pop(context); //must pop before pushing a new screen to close the drawer
                    Navigator.pushNamed(context, '/auth');
                  }
                },
              ) else ListTile(
                title: const Text('Esci', style: TextStyle(fontSize: 20)),
                onTap: () {
                  signOut().then((value) => {
                    if (value["res"] == Constants.OK) {
                      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false)
                    }
                  });
                },
              )
            ],
          );
        },
      )
    );
  }
}
