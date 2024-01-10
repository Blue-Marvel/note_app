import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:todo/domain/model.dart';

class TodoDB {
  static const int _version = 1;
  static const String _dbName = "Todo";

  ///Create
  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute("""
  CREATE TABLE 
  Note(
    id INTEGER PRIMARY KEY, 
    title TEXT NOT NULL, 
    description TEXT NOT NULL,
    );
"""), version: _version);
  }

  ///Add
  static Future<int> addTodo({required Map<String, String> todoData}) async {
    final db = await _getDB();
    return await db.insert(
      'Todo',
      {'title': todoData["title"], 'description': todoData["description"]},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///Update
  static Future<int> updateTodo(NoteModel todo) async {
    final db = await _getDB();
    return await db.update('Todo', todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Delete
  static Future<int> deleteTodo(NoteModel todo) async {
    final db = await _getDB();
    return await db.delete(
      'Todo',
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  ///Read
  static Future<List<NoteModel>>getAllTodos() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> dbMap = await db.query('Todo');

    return List.generate(
        dbMap.length, (index) => NoteModel.fromMap(dbMap[index]));
  }
}
