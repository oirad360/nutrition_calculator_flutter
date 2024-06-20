import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calculator_flutter/auth.dart';
import 'package:nutrition_calculator_flutter/constants.dart';
import 'firebase_options.dart';
import 'screens/home.dart';
import 'router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          primary: Colors.amber.shade900,
          secondary: Colors.white,
          tertiary: Colors.black
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber.shade900,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 24),
          bodySmall: TextStyle(color: Colors.black, fontSize: 15),
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: AuthService().userChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  color: Colors.white,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return const MyHomePage(title: Constants.appTitle);
          } else {
            return const MyHomePage(title: 'loggati');
          }
        },
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
