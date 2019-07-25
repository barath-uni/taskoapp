import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class CreateDB {
  CreateDB._privateConstructor();
  static final CreateDB _instance = CreateDB._privateConstructor();
  static CreateDB get instance {return _instance;}
  var database;

  void insertTask(Task task) async {
    final Database db = await database;
    if(task.task_name != null) {
      await db.insert(
        'Task',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


  Future<List<Task>> tasks() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('Task');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        task_name: maps[i]['task_name'],
        duration: maps[i]['duration'],
      );
    });
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'Task',
      where: "id = ?",
      whereArgs: [id],
    );
  }


  void initialise() async {
    database = openDatabase(
        join(await getDatabasesPath(), 'task_data.db'),
        onCreate: (db, version) {
          return db.execute("CREATE TABLE task(id INTEGER PRIMARY KEY,"
              " task_name TEXT, duration TEXT)");
        },
        version: 1
    );


}
}
class Task {
  final int id;
  final String task_name;
  final String duration;

  Task({this.id, this.task_name, this.duration});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_name': task_name,
      'duration': duration,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, task_name: $task_name, duration: $duration}';
  }
}