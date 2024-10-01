import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'DatabaseHelper.dart';
const secretKey = "yourgameyourgame";
const myKey = "itmyloveitmylove";
class UpadanSonghro {
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

  Future<void> checkTables() async {
    final db = await initializeDB();

    // Query to list all tables
    List<Map<String, dynamic>> tables =
        await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');

    // Print all the table names
    tables.forEach((table) {
      print('Table: ${table['name']}');
    });
  }

  // Future<List<Map<String, dynamic>>> getQuestions() async {
  //   final db = await initializeDB();
  //   // Query the t_pp_journeyman_electrician_questions table
  //   final List<Map<String, dynamic>> maps = await db.query('t_pp_journeyman_electrician_questions');
  //
  //   debugPrint('electrician_questions: ${maps.length}');
  //
  //   return maps;
  // }

  Future<List<Map<String, dynamic>>> getAndInsertQuestions() async {
    try {
      final db = await initializeDB();
      final List<Map<String, dynamic>> maps =
          await db.query('t_pp_journeyman_electrician_questions');


      //dbHelper.insertNewData();


      for (var map in maps) {
        print(map); // This prints the entire map

        var question = "${map["question"]}";
        final questionDec = aesDecrypt(question, secretKey);
        final questionEnc = encryptAES(questionDec, myKey);

        var explanation = "${map["explanation"]}";
        final explanationAes = aesDecrypt(explanation, secretKey);
        final explanationEnc = encryptAES(explanationAes, myKey);

        var incorrect_answer = "${map["incorrect_answer"]}";
        final incorrect_answerAes = aesDecrypt(incorrect_answer, secretKey);
        final incorrect_answerEnc = encryptAES(incorrect_answerAes, myKey);

        var correct_answer = "${map["correct_answer"]}";
        final correct_answerAes = aesDecrypt(correct_answer, secretKey);
        final correct_answerEnc = encryptAES(correct_answerAes, myKey);

        var topic_name = "${map["topic_name"]}";
       // final topic_nameAes = aesDecrypt(topic_name, secretKey);
        final topic_nameEnc = encryptAES(topic_name, myKey);


        var category = "${map["category"]}";
       // final categoryAes = aesDecrypt(category, secretKey);
        final categoryEnc = encryptAES(category, myKey);


        DatabaseHelper.instance.insertSampleData(
            map["uuid"],
            questionEnc,
            explanationEnc,
            incorrect_answerEnc,
            correct_answerEnc,
            topic_nameEnc,
            categoryEnc,
            map["level"] ?? 0,
            map["status"] ?? 0,
            map["collected"] ?? 0,
            map["reported"] ?? 0,
            map["like_state"] ?? 0,
            map["correct"] ?? 0,
            map["incorrect_count"] ?? 0,
            map["answer"] ?? "",
            map["is_default"] ?? 0,
            map["exam_name"] ?? "");
      }
       return maps;
    } catch (e) {
      print('Error: getQuestions $e');
      return [];
    }
  }

  Future<void> closeDB() async {
    final db = await initializeDB();
    await db.close();
  }
}

// String aesDecrypt(String encryptedText, String key) {
//   final keyBytes = Key.fromUtf8(key); // 16-byte (128-bit) key
//   final encrypter =
//       Encrypter(AES(keyBytes, mode: AESMode.ecb, padding: 'PKCS7'));
//
//   final encrypted = Encrypted.fromBase64(encryptedText); // Base64 encoded input
//   final decrypted = encrypter.decrypt(encrypted);
//
//   return decrypted;
// }

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
