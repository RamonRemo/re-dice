import 'package:flutter/material.dart';
import 'package:re_dice/app/services/preferences_service.dart';
import 'package:re_dice/app/view/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await PreferencesService.init();
  } catch (e) {
    debugPrint('Error initializing preferences: $e');
    // Continue anyway - the app can work without preferences
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const Home(),
    );
  }
}
