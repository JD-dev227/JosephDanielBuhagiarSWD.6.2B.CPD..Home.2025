import 'package:flutter/material.dart';
import 'package:ichiraku/screens/scan.screen.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_screen.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iCiracku',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/scan': (context) => ScanScreen(),
        '/recipe': (context) => RecipeScreen(
              title: '',
              description: '',
            ),
      },
    );
  }
}
