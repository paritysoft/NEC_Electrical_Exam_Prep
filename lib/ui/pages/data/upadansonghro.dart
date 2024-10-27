import 'dart:ffi';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../util/util.dart';
import 'model/ElectricianQuestion.dart';

String myKey = dotenv.env["API_KEY"]!;

class UpadanSonghro {

  static final _databaseName = "electrician_update.db";
  static final _databaseVersion = 2;
  static Database? _database;

  // Get database path and copy database from assets if needed
  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database doesn't exist, copy it from assets
    _database = await _initDatabase();
    return _database!;
  }
  final _secureStorage = const FlutterSecureStorage();


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
      CREATE TABLE tbl_electrician_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT,
        question TEXT,
        explanation TEXT,
        incorrect_answer TEXT,
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
        exam_title TEXT
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
          ALTER TABLE tbl_electrician_questions ADD COLUMN new_column_name TEXT
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
    String dbPath = join(documentsDirectory.path, 'electrician_update.db');

    // Check if the database exists in the local storage
    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      // If the database doesn't exist, copy it from assets
      ByteData data = await rootBundle.load('assets/db/electrician_update.db');
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

      final List<Map<String, dynamic>> maps = await db.query('tbl_electrician_questions');
      print('data: getQuestions ${maps.length}');
       return maps;
    } catch (e) {
      print('Error: getQuestions $e');
      return [];
    }
  }

  // Retrieve all questions from the database
  Future<List<ElectricianQuestion>> getAllQuestions() async {
    final db = await database;

    final result = await db.query('tbl_electrician_questions');

    // Convert the List<Map<String, dynamic>> into a List<ElectricianQuestion>
    return result.map((map) => ElectricianQuestion.fromMap(map)).toList();
  }

  // Method to fetch all questions filtered by category with null safety
  Future<List<ElectricianQuestion>> getQuestionsByCategory(String category) async {
    final db = await database;

    final List<Map<String, dynamic>>? maps = await db.query(
      'tbl_electrician_questions',
      where: 'category = ?', // SQL 'where' clause to filter by category
      whereArgs: [category], // The actual category to filter by
    );

    // Ensure maps is not null and contains data
    if (maps == null || maps.isEmpty) {
      return [];
    }

    // Convert List<Map<String, dynamic>> to List<ElectricianQuestion>
    return maps.map((map) => ElectricianQuestion.fromMap(map)).toList();
  }

  void fetchQuestionsByCategory( String category) async {
    final upadanSonghro = await  UpadanSonghro();
  //  final db = await initializeDB();
    List<ElectricianQuestion> questions = await upadanSonghro.getQuestionsByCategory(category);

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
      'tbl_electrician_questions',
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
  Future<void> updateQuestion(
      ElectricianQuestion question, String givenAnswer, int correctCount, int incorrectCount) async {
    try {
      final db = await database;

      // Fetch existing data for the specific question by uuid
      final existingData = await db.query(
        'tbl_electrician_questions',
        where: 'uuid = ?',
        whereArgs: [question.uuid],
      );

      if (existingData.isEmpty) {
        print("Error: No question found with uuid ${question.id}");
        return;
      }

      // Merge current data with the new update values
      final currentData = existingData.first;
      final updatedData = {
        ...currentData,
        'given_answer': givenAnswer,
        'correct_count': correctCount,
        'incorrect_count': incorrectCount,
      };

      // Update only the row with the specified uuid
      final updatedCount = await db.update(
        'tbl_electrician_questions',
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
      'tbl_electrician_questions',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result.isNotEmpty;
  }

  Future<void> closeDB() async {
    final db = await database;

    await db.close();
  }

  // Function to retrieve unique categories
  Future<List<String>> getUniqueCategories() async {
    final db = await database;

    // Perform a distinct query to get unique categories
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT DISTINCT category FROM tbl_electrician_questions');

    // Convert the result into a list of category strings
    List<String> categories = result.map((row) => aesDecrypt(row['category'], myKey) as String).toList();

    return categories;
  }


//   Future<Database> initializeDB() async {
//     // Get the database path
//     var databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'mydb.db');
//     // Check if the database file exists
//     bool exists = await File(path).exists();
//     if (!exists) {
//       // If not, copy it from the assets
//       try {
//         print('Copying database from assets...');
//         ByteData data = await rootBundle.load('assets/db/mydb.db');
//         List<int> bytes =
//         data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//         await File(path).writeAsBytes(bytes, flush: true);
//         print('Database copied.');
//       } catch (e) {
//         print('Error copying database: $e');
//       }
//     }
//     return openDatabase(path);
//   }
//
//   Future<List<Map<String, dynamic>>> getAndInsertQuestions() async {
//     try {
//       final db = await initializeDB();
//       List<Map<String, dynamic>> maps =
//       await db.query('t_pp_journeyman_electrician_questions');
//       //dbHelper.insertNewData();
//       print("maps journeyman ${maps}");
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
//
//         var uuid = Uuid().v4();
//
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
//             map["exam_name"] ?? "");
//       }
//       return maps;
//     } catch (e) {
//       print('Error: getQuestions $e');
//       return [];
//     }
//   }
}


