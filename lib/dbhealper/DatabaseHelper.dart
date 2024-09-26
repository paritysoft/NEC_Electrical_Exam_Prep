import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "mydb.db";
  static final _databaseVersion = 1;

  static final table = 't_pp_journeyman_electrician_questions';


  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) {
          db.execute('''
          CREATE TABLE $table (
            "id" integer NOT NULL,
            "uuid" text(100),
            "question" text,
            "explanation" text,
            "incorrect_answer" text,
            "correct_answer" text,
            "topic_name" text(130),
            "category" text(130),
            "quiz" text,
            "image" text,
            "level" integer,
            "status" integer,
            "collected" integer,
            "reported" integer,
            "like_state" integer,
            "correct" integer,
            "incorrect_count" integer,
            "answer" text,
            "default" integer,
            "exam_name" text(100),
            "a" integer,
            PRIMARY KEY ("id")
            )
          ''');
        });
  }
}


