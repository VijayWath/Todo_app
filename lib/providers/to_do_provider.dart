import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/to_do.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Priority stringToPriority(String priority) {
  if (priority == 'low') {
    return Priority.low;
  } else if (priority == 'high') {
    return Priority.high;
  } else {
    print('Invalid priority string: $priority');
    return Priority.low;
  }
}

Future<Database> getTodoDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbpath, 'toDo.db'),
      onCreate: (db, version) {
    print("Creating toDo table");
    return db.execute(
        'CREATE TABLE toDo(id TEXT PRIMARY KEY,title TEXT,priority TEXT, date DATETIME)');
  }, version: 1);
  return db;
}

class ToDoNotifier extends StateNotifier<List<ToDo>> {
  ToDoNotifier() : super(const []);

  Future<void> loadToDo() async {
    final db = await getTodoDatabase();
    final data = await db.query('toDo');

    final toDo = data
        .map(
          (row) => ToDo(
            id: row['id'] as String,
            priority: stringToPriority(row['priority'] as String),
            title: row['title'] as String,
            timeStamp: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
          ),
        )
        .toList();

    state = toDo;
  }

  void addToDo(ToDo newToDo) async {
    final db = await getTodoDatabase();
    db.insert('toDo', {
      'id': newToDo.id,
      'title': newToDo.title,
      'date': newToDo.timeStamp.millisecondsSinceEpoch,
      'priority': newToDo.priority.toString().split('.').last,
    });

    state = [newToDo, ...state];
  }

  void removeTodo(ToDo toDo) async {
    final db = await getTodoDatabase();
    db.delete('toDo', where: 'id = ?', whereArgs: [toDo.id]);

    state = state.where((element) => element.id != toDo.id).toList();
  }
}

final toDoProvider = StateNotifierProvider<ToDoNotifier, List<ToDo>>(
  (ref) => ToDoNotifier(),
);
