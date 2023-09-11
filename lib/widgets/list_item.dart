import 'package:flutter/material.dart';
import 'package:todo_app/models/to_do.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.toDoItem});

  final ToDo toDoItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                toDoItem.title,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    toDoItem.formatedDate,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  Icon(
                    priorityIcon[toDoItem.priority],
                    color: Theme.of(context).iconTheme.color,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
