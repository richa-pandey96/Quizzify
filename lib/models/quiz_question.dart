class QuizQuestion {
  final String topic;
  final String description;
  final List<Option> options;
  final String correctOption;  
  String detailedDescription; 

  QuizQuestion({
    required this.topic,
    required this.description,
    required this.options,
    required this.correctOption,
    this.detailedDescription = ''  
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      topic: json['topic'] ?? 'No topic provided', // Default value if null
      description: json['description'] ?? 'No description provided', // Default value if null
      options: (json['options'] as List<dynamic>?)
              ?.map((optionJson) => Option.fromJson(optionJson))
              .toList() ??
          [], correctOption: '', // Empty list if options is null
    );
  }
}

class Option {
  final String description;
  final bool isCorrect; 

  Option({
    required this.description,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      description: json['description'],
      isCorrect: json['is_correct'] == true, 
    );
  }
}