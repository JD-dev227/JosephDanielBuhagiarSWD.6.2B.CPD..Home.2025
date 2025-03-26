import 'package:flutter/material.dart';
import 'package:ichiraku/screens/gallery_screen.dart';
import 'package:ichiraku/screens/scan.screen.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize notifications
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICiracku: Recipe Finder',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/scan': (context) => ScanScreen(),
        // RecipeScreen now gets its arguments via the route settings
        '/recipe': (context) => RecipeScreen(),
        '/gallery': (context) => GalleryScreen(),
      },
    );
  }
}
