import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/constants.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';
import 'package:nutrition_calculator_flutter/widgets/my_text_input.dart';
import 'package:email_validator/email_validator.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final Map _data = {
    'email': '',
    'password': ''
  };
  bool _isLogin = true;
  String? _errorMessage;
  bool _showLoading = false;
  final AuthService _authService = AuthService();

  Future<Map<String, String?>> signIn({required String email, required String password}) async {
    setState(() {
      _showLoading = true;
    });
    try {
      await _authService.signInWithEmailAndPassword(email: email, password: password);
      return {
        "res": Constants.OK
      };
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showLoading = false;
      });
      return {
        "res": Constants.KO,
        "code": e.code
      };
    }
  }

  Future<Map<String, String?>> signUp({required String email, required String password}) async {
    setState(() {
      _showLoading = true;
    });
    try {
      await _authService.createUserWithEmailAndPassword(email: email, password: password);
      return {
        "res": Constants.OK
      };
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showLoading = false;
      });
      return {
        "res": Constants.KO,
        "code": e.code
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
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
      drawer: MyDrawer(selectedTile: SelectedTile.auth),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Text(Constants.appTitle, style: TextStyle(color: Colors.white, fontSize: 37)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextInput(
                        label: 'Email',
                        validator: (value) => value == null || value.isEmpty ?
                          'Inserisci l\'email' :
                          !EmailValidator.validate(value) ?
                          'Inserisci un\'email valida' :
                          null,
                        onSaved: (value) => _data['email'] = value!,
                      ),
                      MyTextInput(
                        label: 'Password',
                        obscureText: true,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'Inserisci la password',
                        onSaved: (value) => _data['password'] = value!,
                      ),
                      if(_errorMessage != null) Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.center),
                      if(_showLoading) CircularProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        color: Colors.white,
                      ) else Column(
                        children: [
                          ElevatedButton(onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                _showLoading = true;
                              });
                              _isLogin ?
                              signIn(email: _data['email'], password: _data['password']).then((value) => {
                                if (value['res'] == Constants.OK) {
                                  Navigator.popUntil(context, (route) => false),
                                  Navigator.pushNamed(context, '/home')
                                } else {
                                  setState(() {
                                    _errorMessage = Constants.authErrorMessage[value['code']];
                                    _showLoading = false;
                                  })
                                }
                              }) :
                              signUp(email: _data['email'], password: _data['password']).then((value) => {
                                if (value['res'] == Constants.OK) {
                                  Navigator.popUntil(context, (route) => false),
                                  Navigator.pushNamed(context, '/home')
                                } else {
                                  setState(() {
                                    _errorMessage = Constants.authErrorMessage[value['code']];
                                    _showLoading = false;
                                  })
                                }
                              });
                            }
                          }, child: Text(_isLogin ? 'Accedi' : 'Registrati')),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Theme.of(context).colorScheme.secondary.withOpacity(0.5); // Colore dell'overlay quando viene premuto
                                  }
                                  return Colors.transparent;
                                }),
                                animationDuration: const Duration(milliseconds: 500)
                              ),
                              child: Text(_isLogin ? 'Non ti sei ancora registrato? Registrati' : 'Ti sei già registrato? Accedi',
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.center,)
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
