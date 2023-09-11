import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/to_do.dart';
import 'package:todo_app/providers/done_to_do_provider.dart';
import 'package:todo_app/providers/to_do_provider.dart';
import 'package:todo_app/widgets/list_item.dart';

class DoneToDoScreen extends ConsumerStatefulWidget {
  const DoneToDoScreen({super.key});

  @override
  ConsumerState<DoneToDoScreen> createState() => _DoneToDoScreenState();
}

// final List<ToDo> dummy = [
//   ToDo(priority: Priority.high, title: 'Test 1', timeStamp: DateTime.now()),
//   ToDo(priority: Priority.high, title: 'Test 1', timeStamp: DateTime.now()),
//   ToDo(priority: Priority.low, title: 'Test 3', timeStamp: DateTime.now()),
// ];

class _DoneToDoScreenState extends ConsumerState<DoneToDoScreen> {
  void onDoubleTap(ToDo item) async {
    ref.read(doneToDoProvider.notifier).removeDoneTodo(item);
    ref.read(toDoProvider.notifier).addToDo(item);
    await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: const Text('Assigned in ToDo'),
      action: SnackBarAction(
        label: 'undo',
        onPressed: () {
          ref.read(doneToDoProvider.notifier).addDoneToDo(item);
          ref.read(toDoProvider.notifier).removeTodo(item);
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<ToDo> doneTodoList = ref.watch(doneToDoProvider);
    Widget contenet = ListView.builder(
      itemCount: doneTodoList.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onDoubleTap: () {
            onDoubleTap(doneTodoList[index]);
          },
          child: ListItem(
            toDoItem: doneTodoList[index],
          ),
        );
      },
    );

    if (doneTodoList.isEmpty) {
      contenet = const Center(
        child: Text('You can Do it'),
      );
    }
    return Scaffold(body: contenet);
  }
}
