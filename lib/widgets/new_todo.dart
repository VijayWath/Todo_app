import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/to_do.dart';
import 'package:todo_app/providers/to_do_provider.dart';

class NweToDo extends ConsumerStatefulWidget {
  const NweToDo({super.key});

  @override
  ConsumerState<NweToDo> createState() => _NweToDoState();
}

class _NweToDoState extends ConsumerState<NweToDo> {
  var newTodoText = TextEditingController();
  var selectedPriority = Priority.low;

  @override
  void dispose() {
    newTodoText.dispose();
    super.dispose();
  }

  void onSave() {
    final enterdTodoText = newTodoText.text;

    if (enterdTodoText.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    newTodoText.clear();
    Navigator.of(context).pop();

    final newTodo = ToDo(
      priority: selectedPriority,
      title: enterdTodoText,
      timeStamp: DateTime.now(),
    );

    ref.read(toDoProvider.notifier).addToDo(newTodo);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
          child: Column(children: [
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Todo Text'),
              controller: newTodoText,
            ),
            const SizedBox(
              height: 15,
            ),
            DropdownButton<Priority>(
              value: selectedPriority,
              items: Priority.values
                  .map(
                    (priority) => DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(
                        priority.name.toLowerCase(),
                      ),
                    ),
                  )
                  .toList(), // Convert the Iterable to a List using toList()
              onChanged: (selectedValue) {
                setState(() {
                  selectedPriority = selectedValue!;
                });
              },
            ),
            ElevatedButton.icon(
              label: const Text('Save'),
              onPressed: onSave,
              icon: const Icon(Icons.add),
            ),
          ]),
        ),
      ),
    );
  }
}
