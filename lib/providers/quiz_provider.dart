import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizProvider with ChangeNotifier {
  late List<QuizQuestion> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool isQuizFinished = false;
    Timer? _timer;
  int remainingSeconds = 120; // 

  List<String> userAnswers = [];

  void startTimer() {
    stopTimer(); 
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        _submitQuiz();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void loadQuestions(List<QuizQuestion> quizData) {
    questions = quizData;
    resetQuiz(); // Ensure the quiz is in a fresh state
    startTimer(); 
    notifyListeners();
  }

  void submitAnswer(String answer) {
     if (currentQuestionIndex < questions.length) {
      // Replace answer if already exists for the current question
      if (userAnswers.length > currentQuestionIndex) {
        userAnswers[currentQuestionIndex] = answer;
      } else {
        userAnswers.add(answer);
      }
      print('User Answers: $userAnswers');
      
      nextQuestion();
      calculateScore(); // Update the score after each answer
      notifyListeners(); 
      
    }
    
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
    } else {
      _submitQuiz(); // Automatically submit quiz if at the last question
    }
    notifyListeners();
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
    
    notifyListeners();
    }
  }

  void _submitQuiz() {
    stopTimer(); 
    isQuizFinished = true;
    calculateScore();
    notifyListeners();
  }

  void calculateScore() {
  score = 0; // Reset score
  for (int i = 0; i < questions.length; i++) {
    if (i < userAnswers.length) {
      print('Checking answer for Question ${i + 1}:');
      print('User Answer: ${userAnswers[i]}');

      // Find the correct option based on is_correct flag
      var correctOption = questions[i].options.firstWhere(
        (option) => option.isCorrect,
        orElse: () => Option(description: '', isCorrect: false), // Return a dummy option if no correct option is found
      );

      print('Correct Option: ${correctOption.description}');

      // Compare user answer with correct option
      if (userAnswers[i] == correctOption.description) {
        score += 4; // Add 4 marks for correct answer
      } else {
        score -= 1; // Deduct 1 mark for incorrect answer
      }
    }
  }

  // Ensure the score doesn't go below 0
  if (score < 0) {
    score = 0;
  }

  print('Score Calculated: $score');
}


  void resetQuiz() {
    stopTimer(); // Ensure any previous timer is stopped
    currentQuestionIndex = 0;
    score = 0;
    isQuizFinished = false;
    userAnswers.clear();
    remainingSeconds = 120; // Reset timer to initial value
    notifyListeners();
  }
  /// Disposes the timer when the provider is no longer needed
  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}