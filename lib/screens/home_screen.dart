import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/question_model.dart'; //our question model
import '../widgets/question_widget.dart'; //question widget
import '../widgets/next_button.dart';

//create a homeScreen widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Question> _question = [
    Question(
      id: '10',
      title: 'What is 2 + 2 ?',
      options: {'5': false, '30': false, '4': true, '10': false},
    ),
    Question(
      id: '10',
      title: 'What is 10 + 20 ?',
      options: {'50': false, '30': true, '40': false, '10': false},
    )
  ];
  // //create index loop thought _questions
  int index = 0;

  //create a function to  display the  next question
  void nextQuestion() {
    if (index == _question.length - 1) {
      return;
    } else {
      setState(() {
        index++; //when the index will change to 1. rebuild the app
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //change background color

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: background,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            QuestionWidget(
              indexAction: index,
              question: _question[index].title,
              totalQuestions: _question.length,
            ),
            const Divider(
              color: Colors.white,
            )
          ],
        ),
      ),

      //use the floating action button
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: nextQuestion, //the above function
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
