import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/to_do.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Priority stringToPriority(String priorityString) {
  if (priorityString == 'low') {
    return Priority.low;
  } else if (priorityString == 'high') {
    return Priority.high;
  } else {
    // If the priorityString is invalid, return a default value (e.g., Priority.low).
    // You can also log a warning message here if needed.
    print('Invalid priority string: $priorityString');
    return Priority.low;
  }
}

Future<Database> getDoneToDoDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  print("Database Path: $dbpath");
  final db = await sql.openDatabase(path.join(dbpath, 'doneToDo.db'),
      onCreate: (db, version) {
    print("Creating doneToDo table");
    return db.execute(
        'CREATE TABLE doneToDo(id TEXT PRIMARY KEY,title TEXT,priority TEXT, date DATETIME)');
  }, version: 1);
  return db;
}

class DoneToDoNotifier extends StateNotifier<List<ToDo>> {
  DoneToDoNotifier() : super([]);

  Future<void> loadDoneTodo() async {
    final db = await getDoneToDoDatabase();
    final data = await db.query('doneToDo');

    final doneToDo = data
        .map(
          (row) => ToDo(
            id: row['id'] as String,
            priority: stringToPriority(row['priority'] as String),
            title: row['title'] as String,
            timeStamp: DateTime.fromMillisecondsSinceEpoch(
                row['date'] as int), // Convert int to DateTime
          ),
        )
        .toList();
    state = doneToDo;
  }

  void addDoneToDo(ToDo doneToDo) async {
    final db = await getDoneToDoDatabase();
    print('Inserting data: $doneToDo');
    db.insert('doneToDo', {
      'id': doneToDo.id,
      'title': doneToDo.title,
      'date':
          doneToDo.timeStamp.millisecondsSinceEpoch, // Store timestamp as int
      'priority': doneToDo.priority.toString().split('.').last,
    });
    state = [doneToDo, ...state];
  }

  void removeDoneTodo(ToDo toDo) async {
    final db = await getDoneToDoDatabase();
    print('Deleting data: $toDo');

    db.delete('doneToDo', where: 'id = ?', whereArgs: [toDo.id]);

    state = state.where((element) => element.id != toDo.id).toList();
  }
}

final doneToDoProvider = StateNotifierProvider<DoneToDoNotifier, List<ToDo>>(
  (ref) => DoneToDoNotifier(),
);
