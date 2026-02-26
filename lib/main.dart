import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const EnglishTutorApp());
}

class EnglishTutorApp extends StatelessWidget {
  const EnglishTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Prep 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
        ),

      ),
      home: const HomeScreen(),
    );
  }
}
