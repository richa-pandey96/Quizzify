import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart'; 
import 'providers/quiz_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuizWhiz',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.white, // Set text color here
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
          
        ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
