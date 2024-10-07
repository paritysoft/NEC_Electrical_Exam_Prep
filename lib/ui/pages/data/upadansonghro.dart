import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'model/ElectricianQuestion.dart';
String myKey = dotenv.env["API_KEY"]!;

class UpadanSonghro {


  static Database? _database;

  // Get database path and copy database from assets if needed
  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database doesn't exist, copy it from assets
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the path to the app's document directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, 'electrician.db');

    // Check if the database exists in the local storage
    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      // If the database doesn't exist, copy it from assets
      ByteData data = await rootBundle.load('assets/db/electrician.db');
      List<int> bytes = data.buffer.asUint8List();

      // Write the copied database file to the device
      await File(dbPath).writeAsBytes(bytes);
    }

    // Open the database
    return await openDatabase(dbPath);
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
  Future<void> updateQuestion(ElectricianQuestion question) async {
    final db = await database;

    await db.update(
      'tbl_electrician_questions',
      question.toMap(),
      where: 'uuid = ?',
      whereArgs: [question.id],
    );
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

}


String aesDecrypt(String encryptedText, String key) {
  // Check if the input is null or empty
  if (encryptedText == null || encryptedText.isEmpty) {
    return ''; // Return a default value or message
  }

  try {
    final keyBytes = Key.fromUtf8(key); // Ensure your key length matches AES requirements
    final iv = IV.fromLength(16);       // ECB mode doesn't require IV, but you can set a dummy one
    final encrypter = Encrypter(AES(keyBytes, mode: AESMode.ecb, padding: 'PKCS7'));

    // Perform decryption
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  } catch (e) {
    return ''; // Handle decryption failure
  }
}
// AES Encryption function
String encryptAES(String plainText, String key) {
  // Check if the input plainText is null or empty
  if (plainText == null || plainText.isEmpty) {
    return ''; // Return a default value or error message
  }

  // Check if the key is null, empty, or invalid
  if (key == null || key.isEmpty || key.length != 16) {
    return ''; // Check for a valid key
  }

  try {
    // Convert the key and plain text to bytes
    final keyBytes = Key.fromUtf8(key); // Ensure key length matches AES requirements
    final iv = IV.fromLength(16);       // Initialization Vector with fixed length (ECB doesn't need it)

    // Use AES algorithm with ECB mode and PKCS7 padding
    final encrypter = Encrypter(AES(keyBytes, mode: AESMode.ecb, padding: 'PKCS7'));

    // Encrypt the plain text
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64; // Return encrypted text as Base64
  } catch (e) {
    return ''; // Handle encryption failure
  }
}
