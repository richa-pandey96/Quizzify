import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../services/api_service.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuizWhiz'),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 242, 250, 13),
          fontSize: 28,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color.fromARGB(255, 160, 116, 237),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().fetchQuizRules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No quiz data available.'));
          }

          final quizRules = snapshot.data!;
          final quizTitle = quizRules['title'] ?? 'Quiz Title';
          final description = (quizRules['description']?.isNotEmpty ?? false)
              ? quizRules['description']
              : 'Prepare yourself for an exciting quiz challenge!';
          final negativeMarks = quizRules['negative_marks'] ?? '0.0';
          final correctAnswerMarks = quizRules['correct_answer_marks'] ?? '0.0';

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Lottie animation
                    Lottie.asset(
                      'assets/animations/quiz_animation.json',
                      width: 400,
                      height: 400,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 20),

                    // Quiz Title
                    Text(
                      quizTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Animated Quiz Description
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          description,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(221, 232, 14, 214),
                            fontWeight: FontWeight.w600,
                          ),
                          speed: const Duration(milliseconds: 10),
                        ),
                        FadeAnimatedText(
                          "Earn exciting Badges!",
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      repeatForever: true,
                      pause: const Duration(milliseconds: 1000),
                    ),
                    const SizedBox(height: 20),

                    // Quiz Rules
                    const Text(
                      'Rules:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '• Correct Answer Marks: $correctAnswerMarks',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '• Negative Marks: $negativeMarks',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Time Duration: 2 minutes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Start Quiz Button without hover animation
                    GestureDetector(
                      onTap: () async {
                        final quizData = await ApiService().fetchQuizData();
                        Provider.of<QuizProvider>(context, listen: false)
                            .loadQuestions(quizData);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuizScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 162, 114, 244),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Start Quiz',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}