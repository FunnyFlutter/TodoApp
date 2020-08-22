import 'package:flutter/material.dart';
import 'package:todo_list/model/todo_list.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key key, this.todoList}) : super(key: key);
  final TodoList todoList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日历'),
      ),
      body: Center(
        child: Text(
          this.runtimeType.toString(),
        ),
      ),
    );
  }
}
