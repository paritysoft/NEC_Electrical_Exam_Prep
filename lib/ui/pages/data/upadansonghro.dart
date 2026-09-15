import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../../models/activity_data.dart';
import '../../../util/util.dart';
import 'DatabaseHelper.dart';
import 'model/CategoryQuestionData.dart';
import 'model/ElectricianQuestion.dart';

String myKey = dotenv.env["API_KEY"]!;
const secretKey = "yourgameyourgame";

class UpadanSonghro {
  static final _databaseName = "mydb.db";
  static final tblName = "tbl_acnp_questions";
  static final _databaseVersion = 2;
  static Database? _database;

  // Get database path and copy database from assets if needed
  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database doesn't exist, copy it from assets
    _database = await _initDatabase();
    return _database!;
  }

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: false),
  );

  // Future<Database> _initDatabase() async {
  //   // Fetch the encryption password securely
  //   String? password = await _secureStorage.read(key: your_db_pass);
  //
  //   // If no password exists, generate and store one securely
  //   if (password == null) {
  //     password = yourDBKey; // Replace with a generated one
  //     await _secureStorage.write(key: your_db_pass, value: password);
  //   }
  //
  //   // Open the encrypted database with the password
  //   String path = join(await getDatabasesPath(), _databaseName);
  //   return await openDatabase(
  //     path,
  //     password: password, // Use encrypted database
  //     version: _databaseVersion,
  //     onCreate: _onCreate,
  //     onUpgrade: _onUpgrade,
  //   );
  // }

  // Create the initial database schema
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tblName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT,
        question TEXT,
        explanation TEXT,
        incorrect_answer1 TEXT,
        incorrect_answer2 TEXT,
        incorrect_answer3 TEXT,
        correct_answer TEXT,
        topic_name TEXT,
        category TEXT,
        level INTEGER,
        status INTEGER,
        collected INTEGER,
        reported INTEGER,
        islike INTEGER,
        correct_count INTEGER,
        incorrect_count INTEGER,
        given_answer TEXT,
        is_default INTEGER,
        exam_title TEXT,
        answered_date TEXT
      )
    ''');
    print("Table created successfully.");
  }

  // Handle database upgrade when schema changes
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Example of adding new columns or handling migrations
      if (oldVersion == 1 && newVersion == 2) {
        await db.execute('''
          ALTER TABLE $tblName ADD COLUMN new_column_name TEXT
        ''');
        print("Database upgraded from version $oldVersion to $newVersion");
      }
    }
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the path to the app's document directory

    String? password = await _secureStorage.read(key: your_db_pass);

    // If no password exists, generate and store one securely
    if (password == null) {
      password = yourDBKey; // Replace with a generated one
      await _secureStorage.write(key: your_db_pass, value: password);
    }
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, tblName);

    // Check if the database exists in the local storage
    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      // If the database doesn't exist, copy it from assets
      ByteData data = await rootBundle.load('assets/db/mydb.db');
      List<int> bytes = data.buffer.asUint8List();

      // Write the copied database file to the device
      await File(dbPath).writeAsBytes(bytes);
    }

    // Open the database
    return await openDatabase(
      dbPath,
      password: password, // Use encrypted database
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> checkTables() async {
    final db = await database;

    // Query to list all tables
    List<Map<String, dynamic>> tables =
        await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');

    // Print all the table names
    tables.forEach((table) {
      print('Table: ${table['name']}');
    });
  }

  Future<List<Map<String, dynamic>>> getQuestions() async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> maps = await db.query('$tblName');
      print('data: getQuestions ${maps.length}');
      return maps;
    } catch (e) {
      print('Error: getQuestions $e');
      return [];
    }
  }

  Future<List<ActivityData>> getActivityDataByDays(int days) async {
    final Database db = await database;
    final String query = '''
      SELECT 
        DATE(answered_date) as date, 
        SUM(correct_count + incorrect_count) as answeredQuestions,
        CASE 
          WHEN SUM(correct_count + incorrect_count) = 0 THEN 0.0 
          ELSE CAST(SUM(correct_count) AS FLOAT) / (SUM(correct_count) + SUM(incorrect_count))
        END as accuracyRate
      FROM $tblName
      WHERE answered_date >= DATE('now', '-$days days')
      GROUP BY DATE(answered_date)
      ORDER BY date ASC;
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(query);

    // Debugging Output
    print("DB Raw Data: $results");

    return results.map((row) {
      final double accuracy = (row['accuracyRate'] as num?)?.toDouble() ?? 0.0;

      return ActivityData(
        DateTime.parse(row['date']),
        row['answeredQuestions'] as int? ?? 0, // Default to 0 if null
        accuracy * 100, // Convert to percentage
      );
    }).toList();
  }


  Future<Map<String, int>> getCompletionStats() async {
    final db = await database;

    final totalQuery = await db.rawQuery('SELECT COUNT(*) AS total FROM $tblName');
    final answeredQuery = await db.rawQuery('''
    SELECT COUNT(*) AS answered 
    FROM $tblName 
    WHERE given_answer IS NOT NULL AND given_answer != ''
  ''');

    int totalQuestions = Sqflite.firstIntValue(totalQuery) ?? 0;
    int answeredQuestions = Sqflite.firstIntValue(answeredQuery) ?? 0;
    int remainingQuestions = totalQuestions - answeredQuestions;

    return {
      'total': totalQuestions,
      'answered': answeredQuestions,
      'remaining': remainingQuestions,
    };
  }

// Function to retrieve unique categories
  Future<List<String>> getUniqueCategories() async {
    final db = await database;

    // Perform a distinct query to get unique categories
    List<Map<String, dynamic>> result =
    await db.rawQuery('SELECT DISTINCT category FROM $tblName');

    // Convert the result into a list of category strings
    // List<String> categories = result
    //     .map((row) => aesDecrypt(row['topic_name'] , myKey))
    //     .toList();

    List<String> topics = result
        .map((row) {
      final category = row['category'];
      print("category  ${result.first['category']}");

      return category != null ? aesDecrypt(category, myKey) : null;
    })
        .where((decrypted) => decrypted != null)
        .cast<String>()
        .toList();

    return topics;
  }
  // Retrieve all questions from the database
  Future<List<ElectricianQuestion>> getAllQuestions() async {
    final db = await database;

    final result = await db.query('$tblName');

    // Convert the List<Map<String, dynamic>> into a List<ElectricianQuestion>
    return result.map((map) => ElectricianQuestion.fromMap(map)).toList();
  }

  // Method to fetch all questions filtered by category with null safety
  Future<List<ElectricianQuestion>> getQuestionsByCategory(String category) async {
    try {
      final categoryAes = encryptAES(category, myKey);
      final db = await database;

      final List<Map<String, dynamic>> maps = await db.query(
        tblName,
        where: 'category = ?',
        whereArgs: [categoryAes],
      );

      if (maps.isEmpty) {
        print('No questions found for category: $category');
        return [];
      }
      return maps.map((map) => ElectricianQuestion.fromMap(map)).toList();
    } catch (e) {
      print('Error querying questions by category: $e');
      return [];
    }
  }

  void fetchQuestionsByCategory(String category) async {
    final upadanSonghro = await UpadanSonghro();
    //  final db = await initializeDB();
    List<ElectricianQuestion> questions =
        await upadanSonghro.getQuestionsByCategory(category);

    if (questions.isEmpty) {
      print('No questions found for category: $category');
    } else {
      for (var question in questions) {
        print('Question: ${question.question}, Category: ${question.category}');
      }
    }
  }

  // Retrieve a specific question by its UUID
  Future<ElectricianQuestion?> getQuestionByUUID(String uuid) async {
    final db = await database;

    final result = await db.query(
      '$tblName',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (result.isNotEmpty) {
      return ElectricianQuestion.fromMap(result.first);
    } else {
      return null;
    }
  }

// Update an existing question
  Future<void> updateQuestion(ElectricianQuestion question, String givenAnswer,
      int correctCount, int incorrectCount) async {
    try {
      final db = await database;

      // Fetch existing data for the specific question by uuid
      final existingData = await db.query(
        '$tblName',
        where: 'uuid = ?',
        whereArgs: [question.uuid],
      );

      if (existingData.isEmpty) {
        print("Error: No question found with uuid ${question.id}");
        return;
      }
      // Get the current date
      String currentDate = DateTime.now().toIso8601String().split('T').first;
      // Merge current data with the new update values
      final currentData = existingData.first;
      final updatedData = {
        ...currentData,
        'given_answer': givenAnswer,
        'correct_count': correctCount,
        'incorrect_count': incorrectCount,
        'answered_date': currentDate, // Store the date in answered_date
      };

      // Update only the row with the specified uuid
      final updatedCount = await db.update(
        '$tblName',
        updatedData,
        where: 'uuid = ?',
        whereArgs: [question.uuid],
      );

      print("Rows updated: $updatedCount");
    } catch (e) {
      print("Error updating question: $e");
    }
  }

  Future<bool> checkIfQuestionExists(String uuid) async {
    final db = await database;
    final result = await db.query(
      '$tblName',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result.isNotEmpty;
  }

  Future<int> getAnsweredCount(int days) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT COUNT(*) as count FROM $tblName
    WHERE answered_date >= date('now', '-$days day')
  ''');
    return result.first['count'] as int;
  }

  Future<void> closeDB() async {
    final db = await database;

    await db.close();
  }

  // Function to retrieve unique categories
  Future<List<String>> getUniqueTopics() async {
    final db = await database;

    // Perform a distinct query to get unique categories
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT DISTINCT topic_name FROM $tblName');

    // Convert the result into a list of category strings
    // List<String> categories = result
    //     .map((row) => aesDecrypt(row['topic_name'] , myKey))
    //     .toList();

    List<String> topics = result
        .map((row) {
      final topicName = row['topic_name'];
      print("topicName  ${result.first['topic_name']}");

      return topicName != null ? aesDecrypt(topicName, myKey) : null;
    })
        .where((decrypted) => decrypted != null)
        .cast<String>()
        .toList();

    return topics;
  }

  Future<List<CategoryQuestionData>> getCategoryQuestionData() async {
    final db = await database;

    final List<Map<String, dynamic>> queryResult = await db.rawQuery('''
    SELECT 
      category,
      SUM(correct_count) as correctCount,
      SUM(incorrect_count) as incorrectCount,
      COUNT(*) - SUM(correct_count + incorrect_count) as unansweredCount
    FROM 
      $tblName
    GROUP BY 
      category
  ''');

    return queryResult.map((row) {
      return CategoryQuestionData(
        category: row['category'] as String,
        correctCount: row['correctCount'] as int,
        incorrectCount: row['incorrectCount'] as int,
        unansweredCount: row['unansweredCount'] as int,
      );
    }).toList();
  }

  Future<Database> initializeDB() async {
    // Get the database path
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mydb.db');
    // Check if the database file exists
    bool exists = await File(path).exists();
    if (!exists) {
      // If not, copy it from the assets
      try {
        print('Copying database from assets...');
        ByteData data = await rootBundle.load('assets/db/mydb.db');
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        print('Database copied.');
      } catch (e) {
        print('Error copying database: $e');
      }
    }
    return openDatabase(path);
  }
//
//   Future<List<Map<String, dynamic>>> insertDataFromJson() async {
//     try {
//       //dbHelper.insertNewData();
//       print("maps data ${quizzesJsonList}");
//       List<Map<String, dynamic>> modifiableMaps = List.from(quizzesJsonList);
//
// // Shuffle the modifiable list
//       modifiableMaps.shuffle(Random());
//       print("maps data insertDataFromJson ${modifiableMaps}");
//
//       for (var map in modifiableMaps) {
//         print(map); // This prints the entire map
//         var question = "${map["question"]}";
//         final questionEnc = encryptAES(question, myKey);
//         var explanation = "${map["explanation"]}";
//         final explanationEnc = encryptAES(explanation, myKey);
//         String incorrect_answer = "${map["incorrect_answer"]}";
//         final incorrect_answerEnc = encryptAES(incorrect_answer, myKey);
//         String correct_answer = "${map["correct_answer"]}";
//         final correct_answerEnc = encryptAES(correct_answer, myKey);
//         var topic_name = "${map["topic_name"]}";
//         final topic_nameEnc = encryptAES(topic_name, myKey);
//
//         print('incorrect_answer: getQuestions $question  $incorrect_answer');
//         var uuid = Uuid().v4();
//         String currentDate = DateTime.now().toIso8601String().split('T').first;
//         DatabaseHelper.instance.insertSampleData(
//             uuid,
//             questionEnc,
//             explanationEnc,
//             incorrect_answerEnc,
//             correct_answerEnc,
//             topic_nameEnc,
//             topic_nameEnc,
//             map["level"] ?? 0,
//             map["status"] ?? 0,
//             map["collected"] ?? 0,
//             map["reported"] ?? 0,
//             map["like_state"] ?? 0,
//             map["correct"] ?? 0,
//             map["incorrect_count"] ?? 0,
//             map["answer"] ?? "",
//             map["is_default"] ?? 0,
//             map["exam_name"] ?? "",
//             currentDate);
//       }
//       return modifiableMaps;
//     } catch (e) {
//       print('Error: getQuestions $e');
//       return [];
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getAndInsertQuestions() async {
//     try {
//       final db = await initializeDB();
//       List<Map<String, dynamic>> maps =
//           await db.query('t_pp_journeyman_electrician_questions');
//       //dbHelper.insertNewData();
//       print("maps journeyman ${maps}");
//
//       List<Map<String, dynamic>> modifiableMaps = List.from(maps);
//
// // Shuffle the modifiable list
//       modifiableMaps.shuffle(Random());
//       print("maps journeyman Random ${modifiableMaps}");
//
//       for (var map in modifiableMaps) {
//         print(map); // This prints the entire map
//         var question = "${map["question"]}";
//         final questionDec = aesDecrypt(question, secretKey);
//         final questionEnc = encryptAES(questionDec, myKey);
//         var explanation = "${map["explanation"]}";
//         final explanationAes = aesDecrypt(explanation, secretKey);
//         final explanationEnc = encryptAES(explanationAes, myKey);
//         var incorrect_answer = "${map["incorrect_answer"]}";
//         final incorrect_answerAes = aesDecrypt(incorrect_answer, secretKey);
//         final incorrect_answerEnc = encryptAES(incorrect_answerAes, myKey);
//         var correct_answer = "${map["correct_answer"]}";
//         final correct_answerAes = aesDecrypt(correct_answer, secretKey);
//         final correct_answerEnc = encryptAES(correct_answerAes, myKey);
//         var topic_name = "${map["topic_name"]}";
//         // final topic_nameAes = aesDecrypt(topic_name, secretKey);
//         final topic_nameEnc = encryptAES(topic_name, myKey);
//         var category = "${map["category"]}";
//         // final categoryAes = aesDecrypt(category, secretKey);
//         final categoryEnc = encryptAES(category, myKey);
//         print(
//             'incorrect_answer: getQuestions $incorrect_answerAes  $correct_answerAes');
//         var uuid = Uuid().v4();
//         String currentDate = DateTime.now().toIso8601String().split('T').first;
//         DatabaseHelper.instance.insertSampleData(
//             uuid,
//             questionEnc,
//             explanationEnc,
//             incorrect_answerEnc,
//             correct_answerEnc,
//             topic_nameEnc,
//             categoryEnc,
//             map["level"] ?? 0,
//             map["status"] ?? 0,
//             map["collected"] ?? 0,
//             map["reported"] ?? 0,
//             map["like_state"] ?? 0,
//             map["correct"] ?? 0,
//             map["incorrect_count"] ?? 0,
//             map["answer"] ?? "",
//             map["is_default"] ?? 0,
//             map["exam_name"] ?? "",
//             currentDate);
//       }
//       return maps;
//     } catch (e) {
//       print('Error: getQuestions $e');
//       return [];
//     }
//   }
}
