import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      id: '20',
      title: 'What is 10 + 20 ?',
      options: {'50': false, '30': true, '40': false, '10': false},
    )
  ];
  int index = 0;
  bool isPressed = false;
  int score = 0;
  bool isAlreadySelected = false;

  void nextQuestion() {
    if (index == _question.length - 1) {
      //this is the block when game end
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score, //total points the user got
                questionLength: _question.length,
                onPressed: startOver, //how of how many questions
              ));
      return;
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select any option'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  // create a function to start over
  void startOver() {
    setState(() {
      //to loop through _questions
      index = 0;
      //create a score variable
      score = 0;
      //create a boolean value to check if the user has clicked
      isPressed = false;
      //function to display next questions
      bool isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child:
                Text('Score : $score ', style: const TextStyle(fontSize: 18.0)),
          )
        ],
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
            ),
            const SizedBox(height: 25.0),
            for (int i = 0; i < _question[index].options.length; i++)
              GestureDetector(
                onTap: () {
                  checkAnswerAndUpdate(
                      _question[index].options.values.toList()[i]);
                },
                child: OptionCard(
                  option: _question[index].options.keys.toList()[i],
                  color: isPressed
                      ? _question[index].options.values.toList()[i] == true
                          ? Colors.green
                          : Colors.red
                      : Colors.white,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: nextQuestion,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
