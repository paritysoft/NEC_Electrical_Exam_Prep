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