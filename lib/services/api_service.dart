import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';

class ApiService {
  final String _url = "https://api.jsonserve.com/Uw5CrX";

  // Fetch quiz questions
  Future<List<QuizQuestion>> fetchQuizData() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check if the "questions" key exists and is a list
        if (jsonResponse['questions'] != null && jsonResponse['questions'] is List) {
          final List<dynamic> questionList = jsonResponse['questions'];

          // Map the list to QuizQuestion objects
          return questionList
              .map((json) => QuizQuestion.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Invalid data format: "questions" key is missing or not a list.');
        }
      } else {
        throw Exception('Failed to load quiz data: HTTP ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching quiz data: $error');
    }
  }

  // Fetch quiz rules including title, description, negative_marks, and correct_answer_marks
  Future<Map<String, dynamic>> fetchQuizRules() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Extract and return the relevant data
        return {
          'title': jsonResponse['title'] ?? 'Untitled Quiz',
          'description': jsonResponse['description'] ?? 'No description available.',
          'negative_marks': jsonResponse['negative_marks'] ?? '0.0',
          'correct_answer_marks': jsonResponse['correct_answer_marks'] ?? '0.0',
        };
      } else {
        throw Exception('Failed to load quiz rules: HTTP ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching quiz rules: $error');
    }
  }
}
