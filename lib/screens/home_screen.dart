import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';
import '../models/db_connection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //create an object for DBconnect
  var db = DBconnect();

  // final List<Question> _question = [
  //   Question(
  //     id: '10',
  //     title: 'What is 2 + 2 ?',
  //     options: {'5': false, '30': false, '4': true, '10': false},
  //   ),
  //   Question(
  //     id: '20',
  //     title: 'What is 10 + 20 ?',
  //     options: {'50': false, '30': true, '40': false, '10': false},
  //   )
  // ];
  late Future _questions;

  Future<List<Question>> getData() async {
    return db.fetchQuestion();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  int index = 0;
  bool isPressed = false;
  int score = 0;
  bool isAlreadySelected = false;

  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      //this is the block when game end
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score, //total points the user got
                questionLength: questionLength,
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
    // use the futureBuilder Widget
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              backgroundColor: background,
              appBar: AppBar(
                title: const Text('Quiz App'),
                backgroundColor: background,
                shadowColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text('Score : $score ',
                        style: const TextStyle(fontSize: 18.0)),
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
                      question: extractedData[index].title,
                      totalQuestions: extractedData.length,
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    const SizedBox(height: 25.0),
                    for (int i = 0;
                        i < extractedData[index].options.length;
                        i++)
                      GestureDetector(
                        onTap: () {
                          checkAnswerAndUpdate(
                              extractedData[index].options.values.toList()[i]);
                        },
                        child: OptionCard(
                          option: extractedData[index].options.keys.toList()[i],
                          color: isPressed
                              ? extractedData[index]
                                          .options
                                          .values
                                          .toList()[i] ==
                                      true
                                  ? Colors.green
                                  : Colors.red
                              : Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20.0),
                Text(
                  'Please Wait while Questions are loading..',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                  ),
                )
              ],
            ),
          );
        }

        return const Center(
          child: Text('No Data'),
        );
      },
    );
  }
}
