import '../../../../util/util.dart';
import '../upadansonghro.dart';

class ElectricianQuestion {
  int? id;
  String uuid;
  String question;
  String explanation;
  String incorrectAnswer;
  String correctAnswer;
  String topicName;
  String category;
  int level;
  int status;
  int collected;
  int reported;
  int isLike;
  int correctCount;
  int incorrectCount;
  String givenAnswer;
  int isDefault;
  String examTitle;

  ElectricianQuestion({
    this.id,
    required this.uuid,
    required this.question,
    required this.explanation,
    required this.incorrectAnswer,
    required this.correctAnswer,
    required this.topicName,
    required this.category,
    required this.level,
    required this.status,
    required this.collected,
    required this.reported,
    required this.isLike,
    required this.correctCount,
    required this.incorrectCount,
    required this.givenAnswer,
    required this.isDefault,
    required this.examTitle,
  });

  // Convert a Question object into a Map object (for insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'question': question,
      'explanation': explanation,
      'incorrect_answer': incorrectAnswer,
      'correct_answer': correctAnswer,
      'topic_name': topicName,
      'category': category,
      'level': level,
      'status': status,
      'collected': collected,
      'reported': reported,
      'islike': isLike,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'given_answer': givenAnswer,
      'is_default': isDefault,
      'exam_title': examTitle,
    };
  }

  // Convert a Map object (from database) into a Question object
  factory ElectricianQuestion.fromMap(Map<String, dynamic> map) {
    return ElectricianQuestion(
      id: map['id'],
      uuid: map['uuid'],
      question: aesDecrypt(map['question'], myKey),
      explanation: aesDecrypt(map['explanation'], myKey),
      incorrectAnswer: aesDecrypt(map['incorrect_answer'], myKey),
      correctAnswer: aesDecrypt(map['correct_answer'], myKey),
      topicName: aesDecrypt(map['topic_name'], myKey),
      category: aesDecrypt(map['category'], myKey),
      level: map['level'],
      status: map['status'],
      collected: map['collected'],
      reported: map['reported'],
      isLike: map['islike'],
      correctCount: map['correct_count'],
      incorrectCount: map['incorrect_count'],
      givenAnswer: map['given_answer'],
      isDefault: map['is_default'],
      examTitle: map['exam_title'],
    );
  }
}
