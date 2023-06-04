import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './question_model.dart';
import 'dart:convert';

class DBconnect {
  //lets first create a function to add question to our database.
  // declare the name of the table you want to create and add .json as suffix
  final url = Uri.parse(
      'https://simplequizapp-321b0-default-rtdb.asia-southeast1.firebasedatabase.app/questions.json'); // pass the address here
  Future<void> addQuestion(Question question) async {
    http.post(url,
        body: json.encode({
          'title': question.title,
          'options': question.options,
        }));
  }

  // fetch data from database
  Future<void> fetchQuestion() async {
    http.get(url).then((response) {
      // the then method resturn a response which is out data
      // to whats inside we have to decode it first
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];

      data.forEach((key, value) {
        var newQuestion = Question(
          id: key, // the encrypted key/ the tile we have gave to our data
          title: value['title'], //title of questions
          options: Map.castFrom(value['options']), //options of the questions
        );
        // add to newQuestions
        newQuestions.add(newQuestion);
      });

      print(newQuestions);
    });
  }
}
