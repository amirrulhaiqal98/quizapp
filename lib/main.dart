import 'package:flutter/material.dart';
import 'package:quizzapp/models/question_model.dart';
import './screens/home_screen.dart'; // import file screen
import './models/db_connection.dart';

void main() {
  var db = DBconnect();
  // db.addQuestion(Question(id: '20', title: 'What is  20 X 100 ?', options: {
  //   '100': false,
  //   '200': true,
  //   '300': false,
  //   '500': false,
  // }));
  db.fetchQuestion();
  //run App method
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
