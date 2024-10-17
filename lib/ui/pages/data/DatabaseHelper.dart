import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../util/util.dart';
import 'model/ElectricianQuestion.dart';

class DatabaseHelper {
  static final _databaseName = "electrician_update.db";
  static final _databaseVersion = 1; // Increment this when upgrading schema

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  final _secureStorage = const FlutterSecureStorage();
  static Database? _database;

  // Access the database, create it if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database

  // Initialize the encrypted database
  Future<Database> _initDatabase() async {
    // Fetch the encryption password securely
    String? password = await _secureStorage.read(key: your_db_pass);

    // If no password exists, generate and store one securely
    if (password == null) {
      password = yourDBKey; // Replace with a generated one
      await _secureStorage.write(key: your_db_pass, value: password);
    }

    // Open the encrypted database with the password
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      password: password, // Use encrypted database
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }


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



  // Insert new sample data into the database
  Future<void> insertSampleData(
      String uuid,
      String question,
      String explanation,
      String incorrect_answer,
      String correct_answer,
      String topic_name,
      String category,
      int level,
      int status,
      int collected,
      int reported,
      int islike,
      int correct_count,
      int incorrect_count,
      String given_answer,
      int is_default,
      String exam_title) async {
    final db = await database;
    int result = await db.insert('tbl_electrician_questions', {
      'uuid': uuid,
      'topic_name': topic_name,
      'category': category,
      'question': question,
      'explanation': explanation,
      'incorrect_answer': incorrect_answer,
      'correct_answer': correct_answer,
      'level': level,
      'status': status,
      'collected': collected,
      'reported': reported,
      'islike': islike,
      'correct_count': correct_count,
      'incorrect_count': incorrect_count,
      'given_answer': given_answer,
      'is_default': is_default,
      'exam_title': exam_title
    });
    print('Insert result: $result'); // Should print the row ID
  }

  // Update data by UUID
  Future<void> updateDataByUuid(
      String uuid,
      String question,
      String explanation,
      String incorrect_answer,
      String correct_answer,
      String topic_name,
      String category,
      int level,
      int status,
      int collected,
      int reported,
      int islike,
      int correct_count,
      int incorrect_count,
      String given_answer,
      int is_default,
      String exam_title) async {
    final db = await database;
    int result = await db.update('tbl_electrician_questions', {
      'question': question,
      'explanation': explanation,
      'incorrect_answer': incorrect_answer,
      'correct_answer': correct_answer,
      'topic_name': topic_name,
      'category': category,
      'level': level,
      'status': status,
      'collected': collected,
      'reported': reported,
      'islike': islike,
      'correct_count': correct_count,
      'incorrect_count': incorrect_count,
      'given_answer': given_answer,
      'is_default': is_default,
      'exam_title': exam_title
    }, where: 'uuid = ?', whereArgs: [uuid]);
    print('Update result: $result'); // Should print number of affected rows
  }

  // Fetch all data from the table
  // Future<List<Map<String, dynamic>>> getAllData() async {
  //   final db = await database;
  //   return await db.query('tbl_electrician_questions');
  // }

  // Delete data by UUID
  Future<void> deleteDataByUuid(String uuid) async {
    final db = await database;
    int result =
    await db.delete('tbl_electrician_questions', where: 'uuid = ?', whereArgs: [uuid]);
    print('Delete result: $result'); // Should print number of affected rows
  }

  Future<void> deleteDatabase(String path) async {
    path = join(await getDatabasesPath(), "electrician_update.db");
    await deleteDatabase(path);
    print("Database deleted");
  }

  // Retrieve all questions from the database
  Future<List<ElectricianQuestion>> getAllQuestions() async {
    final db = await instance.database;
    final result = await db.query('tbl_electrician_questions');

    // Convert the List<Map<String, dynamic>> into a List<ElectricianQuestion>
    return result.map((map) => ElectricianQuestion.fromMap(map)).toList();
  }

  // Method to fetch all questions filtered by category with null safety
  Future<List<ElectricianQuestion>> getQuestionsByCategory(String category) async {
    final List<Map<String, dynamic>>? maps = await _database?.query(
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

  void fetchQuestionsByCategory(DatabaseHelper dbHelper, String category) async {
    List<ElectricianQuestion> questions = await dbHelper.getQuestionsByCategory(category);

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
    final db = await instance.database;
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
  Future<void> updateQuestion(ElectricianQuestion question) async {
    final db = await instance.database;
    await db.update(
      'tbl_electrician_questions',
      question.toMap(),
      where: 'uuid = ?',
      whereArgs: [question.id],
    );
  }

  // Delete a question by its ID
  Future<void> deleteQuestion(int id) async {
    final db = await instance.database;
    await db.delete(
      'tbl_electrician_questions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
