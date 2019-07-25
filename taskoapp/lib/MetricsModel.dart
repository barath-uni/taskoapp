import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CreateMetricsDB {
  CreateMetricsDB._privateConstructor();
  static final CreateMetricsDB _instance = CreateMetricsDB._privateConstructor();
  static CreateMetricsDB get instance {return _instance;}
  var database;

  void insertMetrics(Metrics metrics) async {
    final Database db = await database;
    await db.insert(
      'Metrics',
      metrics.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Metrics>> metrics() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('Metrics');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Metrics(
        id: maps[i]['id'],
        completed_tasks: maps[i]['completed_tasks'],
        remaining_tasks: maps[i]['remaining_tasks'],
        frequency:  maps[i]['frequency']
      );
    });
  }


  Future<void> deleteMetrics(int id) async {
    final db = await database;
    await db.delete(
      'Metrics',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> get_completed_count()
  async{
    List<Metrics> total_metrics = await metrics();
    if (total_metrics.isNotEmpty)
    {
      return total_metrics[0].completed_tasks;
    }
    return 0;
  }

  Future<int> get_remaining_count()
  async {
    List<Metrics> total_metrics = await metrics();
    if (total_metrics.isNotEmpty)
    {
      return total_metrics[0].remaining_tasks;
    }
    return 0;

  }
  Future<int> get_current_frequency()
  async {
    List<Metrics> total_metrics = await metrics();
    if(total_metrics.isNotEmpty)
      {
        return total_metrics[0].frequency;
      }
    return 0;
  }
  
  void initialise() async {
    database = openDatabase(
        join(await getDatabasesPath(), 'metrics_data.db'),
        onCreate: (db, version) {
          return db.execute("CREATE TABLE metrics(id INTEGER PRIMARY KEY,"
              " completed_tasks INTEGER, remaining_tasks INTEGER, frequency INTEGER)");
        },
        version: 1
    );


  }
}

class Metrics {
  final int id;
  final int completed_tasks;
  final int remaining_tasks;
  final int frequency;

  Metrics({this.id, this.completed_tasks, this.remaining_tasks, this.frequency});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'completed_tasks': completed_tasks,
      'remaining_tasks': remaining_tasks,
      'frequency':frequency
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, completed_tasks: $completed_tasks, remaining_tasks: $remaining_tasks, frequency: $frequency}';
  }
}