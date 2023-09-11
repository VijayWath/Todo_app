import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

final uuid = Uuid();

enum Priority {
  high,
  low,
}

const priorityIcon = {
  Priority.high: Icons.priority_high,
  Priority.low: Icons.low_priority
};

class ToDo {
  ToDo(
      {required this.priority,
      required this.title,
      required this.timeStamp,
      String? id})
      : id = id ?? uuid.v4();

  final String title;
  final Priority priority;
  final String id;
  final DateTime timeStamp;

  String get formatedDate {
    return formatter.format(timeStamp);
  }
}
