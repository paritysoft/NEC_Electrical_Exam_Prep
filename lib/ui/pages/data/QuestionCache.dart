import 'dart:math';

import 'package:commonquiz/ui/pages/data/upadansonghro.dart';

import 'model/ElectricianQuestion.dart';

class QuestionCache {
  static final QuestionCache _instance = QuestionCache._internal();

  factory QuestionCache() {
    return _instance;
  }

  QuestionCache._internal();

  // Cached data
  List<ElectricianQuestion>? _cachedQuestions;

  // Store the questions in memory
  void cacheQuestions(List<ElectricianQuestion> questions) {
    _cachedQuestions = questions;
  }

  // Retrieve cached questions
  List<ElectricianQuestion>? getQuestions() {
    return _cachedQuestions;
  }

  // Clear the cache (optional, if needed)
  void clearCache() {
    _cachedQuestions = null;
  }


  List<ElectricianQuestion> filterQuestionsByCategory(List<ElectricianQuestion> questions, String category) {
    // Use the .where() method to filter by category
    return questions.where((question) => question.category == category).toList();
  }
}

// Usage in your app
void loadQuestions() async {
  var questionCache = QuestionCache();

  // If questions are already cached, use them
  if (questionCache.getQuestions() != null) {
    var questions = questionCache.getQuestions();
    print('Using cached questions');
  } else {
    // Otherwise, fetch from the database and cache them
    List<ElectricianQuestion> questions = await UpadanSonghro().getAllQuestions();
    questionCache.cacheQuestions(questions);
    print('Caching new questions');
  }
}


List<ElectricianQuestion> splitListAtIndices(List<ElectricianQuestion> questions, int start, int index) {
  return questions.sublist(start, index);
}

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


List<String> getShuffledOptions(ElectricianQuestion question) {
  // Decode incorrect answers
  print("incorrectAnswer  ${question.incorrectAnswer}  ${question.correctAnswer}");
  List<String> options = cleanQuizOptions(question.incorrectAnswer +","+ question.correctAnswer);
  // Shuffle the options
  options.shuffle();

  return options;
}
List<String> cleanQuizOptions(String optionsString) {
  // Remove unwanted characters 【0】, 【1】, etc., as well as quotes and brackets

  // Split the cleaned string by commas to get a list of options
  List<String> optionsList = cleanedString(optionsString).split('","').map((option) => option.replaceAll('"', '').trim()).toList();
  return optionsList;
}
String cleanedString(String optionsString){
  return optionsString.replaceAll(RegExp(r'【\d+】'), '').replaceAll('[', '').replaceAll(']', '').trim();

}