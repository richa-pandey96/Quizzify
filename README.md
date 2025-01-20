
# Project Title

The Quiz App is a Flutter-based application designed to deliver a dynamic and interactive quiz experience. Users can answer multiple-choice questions, track their progress with a timer, and receive a score based on their performance. The app features animations and sound effects to enhance user engagement.



## Acknowledgements

Flutter Community: For providing resources and solutions that helped in overcoming challenges during development.
Open Source Libraries and Tools: Such as Provider and Lottie, which significantly enhanced the functionality and user experience of the app.


## Screenshots

![App Screenshot](https://ibb.co/JyMzpxY)
![App Screenshot](https://ibb.co/DV54dcZ)
![App Screenshot](https://ibb.co/1T87mfF)
![App Screenshot](https://ibb.co/Rbf6rqm)
![App Screenshot](https://ibb.co/DpT5DxH)


## Key Features
Dynamic Question Loading: Supports fetching quiz questions dynamically.

State Management: Uses Provider for managing quiz logic and state.

Timer: Includes a countdown timer for quiz completion.

Score Calculation: Automatically calculates scores, with

+4 points for correct answers.

-1 point for incorrect answers.

Ensures the final score does not fall below 0.

Responsive Navigation: Navigate between questions with options to go forward and backward.

Animations and Sounds: Engaging animations and sound effects for feedback and results.

Scoring System: Users are scored based on the number of correct answers they provide.

Badge System: Badges are awarded based on the final score, providing rewards for users' performance.

Master of Knowledge (40 points)

Quick Learner (35–39 points)

Knowledge Seeker (30–34 points)

You Can Do Better! (Below 30 points)

Animations: Fun Lottie animations are displayed with the badges to create a rewarding visual experience.

Confetti Celebration: Confetti is triggered at the end of each quiz to celebrate the user’s achievement.

Audio Feedback: A celebratory sound is played upon earning a badge.
Timer: A countdown timer to add challenge and urgency to the quiz.

Progress Bar: A progress bar shows how far users have progressed in the quiz.

Quiz Summary: After completion, users see a detailed summary of their score, badge, and explanations for correct/incorrect answers.

Restart Option: Users can retake the quiz to improve their score and earn different badges.

Encouragement: A 'Keep Trying' badge is awarded for lower scores to motivate users to try again.
## Tech Stack
Flutter: For building the user interface and app functionality.

Lottie: For displaying beautiful and engaging animations.

Dart: Programming language used to build the app.
## Folder Structure
The app follows a modular structure for better scalability and maintainability:

assets/
  animations/
    knowledge_seeker.json

    master_badge.json
    quick_learner.json
    quiz_animation.json
    try_again.json
  sounds/

    celebration_sound.mp3.wav
models/

  quiz_question.dart

providers/

  quiz_provider.dart

screens/

  home_screen.dart

  quiz_screen.dart

  result_screen.dart
  
services/

  api_service.dart
main.dart



## Folder/Files Explanation

assets/: Contains animations (JSON files for Lottie) and sound effects.

models/quiz_question.dart: Defines the structure of quiz questions and their options.

providers/quiz_provider.dart: Manages quiz state, including navigation, timer, and score calculation.

screens/:

home_screen.dart: The starting point of the app.

quiz_screen.dart: Displays questions and handles user interaction.

result_screen.dart: Shows the final results with animations and scores.

services/api_service.dart: Handles fetching quiz data from an API.

main.dart: Entry point of the application.
## Dependencies
The app uses the following dependencies:

Provider: State management.

Lottie: For animations.

Other Flutter Core Packages

Make sure to include the following in your pubspec.yaml file:

dependencies:

  flutter:
    sdk: flutter

  provider: ^6.0.5
  
  lottie: ^2.3.2
## Installation

Clone the repository to your local machine:

git clone <repository_url>

Navigate to the project directory:

cd quiz-app

Fetch dependencies:

flutter pub get

Run the app:

flutter run
## How to Play

The app will present a series of questions on various topics.

Answer as many questions as possible within the given time limit.

Based on your performance, you will receive a badge.

The "Master of Knowledge" badge is awarded for perfect scores.

Other badges encourage users to keep improving their scores.

Celebrate your achievements with confetti and sounds after completing the quiz!
## Animations and Sounds

Animations: Lottie animations are displayed for different scenarios (e.g., quiz completion, achievements).

Sound Effect: A celebration sound (celebration_sound.mp3.wav) plays upon successful completion of the quiz.
## Customization

Questions: Modify or load new quiz data in api_service.dart.

Timer Duration: Change the timer duration in quiz_provider.dart by updating remainingSeconds.

Scoring Logic: Adjust score calculation logic in the calculateScore() method inside quiz_provider.dart.
## Future Enhancements

Add More Levels:
Introduce multiple levels of quizzes, each with increasing difficulty. Unlock levels based on user performance to encourage progression.

Gamification Features:

Leaderboard: Implement a global or local leaderboard to allow users to compete with others.
Experience Points (XP): Introduce a leveling system where users earn XP for answering questions correctly and completing quizzes.
User Authentication:
Allow users to create accounts and track their quiz progress, scores, and achievements.

Quiz Categories:
Add categorized quizzes, such as Science, History, or Pop Culture, to cater to user preferences.