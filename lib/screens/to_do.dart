import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/to_do.dart';
import 'package:todo_app/providers/done_to_do_provider.dart';
import 'package:todo_app/providers/to_do_provider.dart';
import 'package:todo_app/widgets/list_item.dart';

// final List<ToDo> dummy = [
//   ToDo(priority: Priority.high, title: 'Test 1', timeStamp: DateTime.now()),
//   ToDo(priority: Priority.high, title: 'Test 1', timeStamp: DateTime.now()),
//   ToDo(priority: Priority.low, title: 'Test 3', timeStamp: DateTime.now()),
// ];

class ToDoScreen extends ConsumerStatefulWidget {
  const ToDoScreen({
    super.key,
  });

  @override
  ConsumerState<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends ConsumerState<ToDoScreen> {
  void onDissmisle(direction, ToDo item) {
    if (direction == DismissDirection.startToEnd) {
      ref.read(toDoProvider.notifier).removeTodo(
            item,
          );
      print('added to done');
      ref.read(doneToDoProvider.notifier).addDoneToDo(item);
    }
    if (direction == DismissDirection.endToStart) {
      ref.read(toDoProvider.notifier).removeTodo(
            item,
          );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: Text('Item Removed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              ref.read(toDoProvider.notifier).addToDo(
                    item,
                  );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ToDo> toDoList = ref.watch(toDoProvider);
    Widget content = ListView.builder(
      // reverse: true,
      itemCount: toDoList.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          background: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color.fromARGB(112, 60, 231, 21),
                  Color.fromARGB(192, 60, 231, 21),
                ])),
          ),
          secondaryBackground: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color.fromARGB(192, 217, 29, 16),
                  Color.fromARGB(112, 217, 29, 16)
                ])),
          ),
          key: ValueKey(toDoList[index].id),
          onDismissed: (direction) {
            onDissmisle(direction, toDoList[index]);
          },
          child: ListItem(
            toDoItem: toDoList[index],
          ),
        );
      },
    );

    if (toDoList.isEmpty) {
      content = const Center(
        child: Text(
          'No ToDO Data',
        ),
      );
    }

    return Scaffold(
      body: content,
    );
  }
}
