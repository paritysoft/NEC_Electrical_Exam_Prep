import 'package:flutter/material.dart';
import 'dart:math';

import '../ui/pages/data/model/ElectricianQuestion.dart';

const app_title = "Electrician Test Prep 2025";
const sizeBox16 = 16.0;
const padding20 = 20.0;
class AdaptiveFontSize {
  static double getFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    const double baseScreenWidth = 375.0; // Standard screen width
    double scaleFactor = screenWidth / baseScreenWidth;
    return baseFontSize * scaleFactor;
  }
}

const onboardT1 = "Master Your Electrical Knowledge";
const onboardD1 = "Get ready for your upcoming electrician certification with expertly crafted questions, detailed explanations, and real-time feedback to help you succeed.";
const onboardT2 = "Personalized Study Plans";
const onboardD2 = "Tailor your learning experience to your pace. Focus on the areas you need the most practice in and track your progress toward your goals.";
const onboardT3 = "Realistic Exam Simulations";
const onboardD3 = "Experience true-to-life exam simulations that mirror the actual test format, preparing you for success on the big day with ease.";
const onboardT4 = "Track Your Progress";
const onboardD4 = "Monitor your performance, identify areas for improvement, and celebrate your achievements as you advance through each stage of the quiz.";




// Assuming ElectricianQuestion is your model class and db.getAllQuestions() returns a Future<List<ElectricianQuestion>>
Future<List<ElectricianQuestion>> getRandomQuestions(List<ElectricianQuestion> questions, int count) async {
  // Fetch all the questions
 // List<ElectricianQuestion> questions = await db.getAllQuestions();

  // Check if there are fewer than 10 questions
  if (questions.length <= count) {
    return questions; // Return all if there are 10 or fewer
  }

  // Create a Random instance
  Random random = Random();

  // Create an empty set to store unique indices
  Set<int> selectedIndices = {};

  // Randomly select 10 unique indices
  while (selectedIndices.length < count) {
    selectedIndices.add(random.nextInt(questions.length));
  }

  // Get the random 10 questions
  List<ElectricianQuestion> randomQuestions = selectedIndices.map((index) => questions[index]).toList();

  return randomQuestions;
}
