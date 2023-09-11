import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/done_to_do_provider.dart';
import 'package:todo_app/providers/to_do_provider.dart';
import 'package:todo_app/screens/done_todo.dart';

import 'package:todo_app/screens/to_do.dart';
import 'package:todo_app/widgets/new_todo.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  late Future<void> donetoDoFuture;
  late Future<void> toDoFuture;
  int selectedPageIndex = 0;

  @override
  void initState() {
    donetoDoFuture = ref.read(doneToDoProvider.notifier).loadDoneTodo();
    toDoFuture = ref.read(toDoProvider.notifier).loadToDo();
    super.initState();
  }

  void addNewTodo() {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (ctx) => const NweToDo());
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = FutureBuilder(
      future: toDoFuture,
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : const ToDoScreen(),
    );

    if (selectedPageIndex == 1) {
      currentScreen = FutureBuilder(
        future: donetoDoFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const DoneToDoScreen(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: addNewTodo,
            icon: const Icon(Icons.add),
          ),
        ],
        title: Text(
          'ToDo App',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Theme.of(context).colorScheme.primaryContainer),
        ),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      ),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPageIndex,
        onTap: (index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'ToDo',
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Done',
            icon: Icon(Icons.done),
          ),
        ],
      ),
    );
  }
}
