import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/constants.dart';
import 'package:nutrition_calculator_flutter/widgets/drawer.dart';
import 'package:email_validator/email_validator.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final Map _data = {
    'email': {
      'value': '',
      'validity': true
    },
    'password': {
      'value': '',
      'validity': true
    }
  };
  bool _isLogin = true;
  String? _errorMessage;
  bool _showLoading = false;

  Future<Map<String, String?>> signIn({required String email, required String password}) async {
    setState(() {
      _showLoading = true;
    });
    try {
      await AuthService().signInWithEmailAndPassword(email: email, password: password);
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
      await AuthService().createUserWithEmailAndPassword(email: email, password: password);
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          validator: (value) {
                            setState(() {
                              _data['email']['validity'] = value != null && value.isNotEmpty && EmailValidator.validate(value);
                            });
                            return value == null || value.isEmpty ?
                                'Inserisci l\'email' :
                                !EmailValidator.validate(value) ?
                                'Inserisci un\'email valida' :
                                null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _data['email']['value'] = value!;
                            });
                          },
                          textInputAction: TextInputAction.next,
                          cursorColor: Theme.of(context).colorScheme.tertiary,
                          cursorErrorColor: Colors.red,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            label: const Text('Email'),
                            labelStyle: TextStyle(color:  _data['email']['validity'] ? Theme.of(context).colorScheme.tertiary : Colors.red),
                            errorStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          validator: (value) {
                            setState(() {
                              _data['password']['validity'] = value != null && value.isNotEmpty;
                            });
                            return value != null && value.isNotEmpty ? null : 'Inserisci la password';
                          },
                          onSaved: (value) {
                            _data['password']['value'] = value!;
                          },
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          cursorColor: Theme.of(context).colorScheme.tertiary,
                          cursorErrorColor: Colors.red,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            label: const Text('Password'),
                            labelStyle: TextStyle(color:  _data['password']['validity'] ? Theme.of(context).colorScheme.tertiary : Colors.red),
                            errorStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                          ),
                        ),
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
                              signIn(email: _data['email']['value'], password: _data['password']['value']).then((value) => {
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
                              signUp(email: _data['email']['value'], password: _data['password']['value']).then((value) => {
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
