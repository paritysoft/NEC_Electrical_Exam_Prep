class CategoryQuestionData {
  final String category;
  final int correctCount;
  final int incorrectCount;
  final int unansweredCount;

  CategoryQuestionData({
    required this.category,
    required this.correctCount,
    required this.incorrectCount,
    required this.unansweredCount,
  });
}
