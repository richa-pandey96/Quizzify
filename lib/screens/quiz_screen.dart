import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz_question.dart';
import '../services/api_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late Future<List<QuizQuestion>> _quizData;
  bool _questionsLoaded = false;
  late AnimationController _animationController;
  late AudioPlayer _audioPlayer;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _quizData = ApiService().fetchQuizData();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    // Scale animation for the badge

    // Initialize audio player
    _audioPlayer = AudioPlayer();

    // Initialize confetti controller
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuizWhiz',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 160, 116, 237),
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _quizData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No quiz data available.'));
          }

          final quizProvider = Provider.of<QuizProvider>(context, listen: false);
          if (!_questionsLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              quizProvider.loadQuestions(snapshot.data!);
            });
            _questionsLoaded = true;
          }

          return Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              if (quizProvider.isQuizFinished) {
                return _buildQuizSummary(context, quizProvider.score);
              }

              final currentQuestion =
                  quizProvider.questions[quizProvider.currentQuestionIndex];

              return _buildQuizQuestion(context, currentQuestion, quizProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildQuizQuestion(
      BuildContext context, QuizQuestion question, QuizProvider quizProvider) {
    final questionNumber = quizProvider.currentQuestionIndex + 1;
    final totalQuestions = quizProvider.questions.length;
    final progress = questionNumber / totalQuestions;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.deepPurple,
          ),
          SizedBox(height: 10),
          Text(
            'Question $questionNumber of $totalQuestions',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          SizedBox(height: 10),
          Text(question.topic,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
          SizedBox(height: 10),
          Text(question.description,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ...question.options.map((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  quizProvider.submitAnswer(option.description);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: Text(option.description,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: quizProvider.previousQuestion,
                child: Text('Previous'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 162, 114, 244),
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
              ),
              Text('Time: ${_formatTime(quizProvider.remainingSeconds)}',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
              ElevatedButton(
                onPressed: quizProvider.nextQuestion,
                child: Text('Next'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 162, 114, 244),
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSummary(BuildContext context, int score) {
    String badge = '';
    String animationAsset = '';
    

    // Determine badge based on score
    if (score == 40) {
      badge = 'Master of Knowledge';
      animationAsset = 'assets/animations/master_badge.json';
    } else if (score >= 35) {
      badge = 'Quick Learner';
       animationAsset = 'assets/animations/quick_learner.json';
    } else if (score >= 30) {
      badge = 'Knowledge Seeker';
     animationAsset = 'assets/animations/knowledge_seeker.json';
    } else {
      badge = 'You can do better!';
      animationAsset = 'assets/animations/try_again.json';
    }

    // Trigger confetti and animation
    _confettiController.play();
    _animationController.forward();
    _audioPlayer
        .play(AssetSource('sounds/celebration_sound.mp3.wav'))
        .catchError((error) {
      print('Audio error: $error');
    });

    return Center(
      child: Stack(
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Quiz Completed!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              SizedBox(height: 20),
              Text('Your Score: $score', style: TextStyle(fontSize: 20,color: Colors.blueAccent,fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              // Lottie Animation for Badge
            Lottie.asset(
              animationAsset,
              width: 500,
              height: 500,
              fit: BoxFit.contain,
            ),
            Text(
              'Badge: $badge',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 155, 1, 182)),
                  
            ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Provider.of<QuizProvider>(context, listen: false).resetQuiz();
                  Navigator.pop(context);
                },
                child: Text('Restart Quiz'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 162, 114, 244),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}