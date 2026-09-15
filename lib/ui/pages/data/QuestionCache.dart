import 'dart:math';

import 'package:electrician/ui/pages/data/upadansonghro.dart';

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

  List<ElectricianQuestion> filterQuestionsByCategory(
    List<ElectricianQuestion> questions,
    String topic,
  ) {
    // Use the .where() method to filter by category
    return questions.where((question) => question.topicName == topic).toList();
  }

  List<ElectricianQuestion> filterQuestionsByGivenAnswer(
    List<ElectricianQuestion> questions,
  ) {
    // Return questions where the givenAnswer is empty
    return questions
        .where((question) => question.givenAnswer.isNotEmpty)
        .toList();
  }
}

// Usage in your app
Future<void> loadQuestions() async {
  var questionCache = QuestionCache();

  // If questions are already cached, use them
  if (questionCache.getQuestions() != null) {
    var questions = questionCache.getQuestions();
    print('Using cached questions ${questions?.length}');
  } else {
    // Otherwise, fetch from the database and cache them
    List<ElectricianQuestion> questions = await UpadanSonghro()
        .getAllQuestions();
    questionCache.cacheQuestions(questions);
    print('Caching new questions  ${questions.length}');
  }
}

List<ElectricianQuestion> splitListAtIndices(
  List<ElectricianQuestion> questions,
  int start,
  int index,
) {
  return questions.sublist(start, index);
}

// Assuming ElectricianQuestion is your model class and db.getAllQuestions() returns a Future<List<ElectricianQuestion>>
Future<List<ElectricianQuestion>> getRandomQuestions(
  List<ElectricianQuestion> questions,
  int count,
) async {
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
  List<ElectricianQuestion> randomQuestions = selectedIndices
      .map((index) => questions[index])
      .toList();

  return randomQuestions;
}

List<String> getShuffledOptions(ElectricianQuestion question) {
  // Decode incorrect answers
  //List<String> options = cleanQuizOptions(question.incorrectAnswer +","+" "+ question.correctAnswer);
  // List<String> options ="question.incorrectAnswer1+ ", "+ question.incorrectAnswer2+ ", "+ question.incorrectAnswer3 +", "+ question.correctAnswer ";
  List<String> options = [];
  if (question.incorrectAnswer1.isNotEmpty) {
    options.add(question.incorrectAnswer1);
  }
  if (question.incorrectAnswer2.isNotEmpty) {
    options.add(question.incorrectAnswer2);
  }
  if (question.incorrectAnswer3.isNotEmpty) {
    options.add(question.incorrectAnswer3);
  }

  // Always add the correct answer (assuming it's always non-empty)
  options.add(question.correctAnswer);

  // Shuffle the options
  options.shuffle();
  //print("incorrectAnswer  ${question.incorrectAnswer}  ${question.correctAnswer}   $options");

  return options;
}
// List<String> cleanQuizOptions(String optionsString) {
//   // Remove unwanted characters 【0】, 【1】, etc., as well as quotes and brackets
//
//   print("cleanedString $optionsString      after clean data  ${cleanedString(optionsString)}");
//   // Split the cleaned string by commas to get a list of options
//   List<String> optionsList = cleanedString(optionsString).split('","').map((option) => option.replaceAll('"', '').trim()).toList();
//   return optionsList;
// }
// String cleanedString(String optionsString){
//   return optionsString.replaceAll(RegExp(r'【\d+】'), '').replaceAll('[', '').replaceAll(']', '').trim();
// }

// List<String> cleanQuizOptions(String optionsString) {
//     print("cleanedString $optionsString      after clean data  ${cleanedString(optionsString)}");
//
//   // Clean the string using the helper function
//   String cleaned = cleanedString(optionsString);
//
//   // Remove enclosing brackets if they are present
//   if (cleaned.startsWith('[') && cleaned.endsWith(']')) {
//     cleaned = cleaned.substring(1, cleaned.length - 1);
//   }
//
//   // Split by the comma, then clean up extra whitespace and quotes
//   // List<String> optionsList = cleaned.split(RegExp(r'","|", "'))
//   //     .map((option) => option.replaceAll('"', '').trim())
//   //     .toList();
//
//     List<String> optionsList = cleaned.split(",")
//         .map((option) => option.replaceAll('"', '').trim())
//         .toList();
//   return optionsList;
// }
//
// String cleanedString(String optionsString) {
//   // Remove unwanted characters 【0】, 【1】, etc., as well as quotes and brackets
//   return optionsString.replaceAll(RegExp(r'【\d+】'), '').replaceAll('[', '').replaceAll(']', '').trim();
// }
