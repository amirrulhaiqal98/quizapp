import 'package:flutter/material.dart';
import './screens/home_screen.dart'; // import file screen

void main() {
  runApp(const MyApp());
}

//create myApp widget

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //remove debug banner
      debugShowCheckedModeBanner: false,
      //set a homepage, but in seperate file for homeScreen
      home: HomeScreen(),
    );
  }
}
