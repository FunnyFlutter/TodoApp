import 'package:flutter/material.dart';
import 'package:todo_list/model/todo_list.dart';

class TodoListInheritedWidget extends InheritedWidget {
  final TodoList todoList;

  TodoListInheritedWidget({this.todoList, Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(TodoListInheritedWidget oldWidget) {
    return oldWidget.todoList == todoList;
  }

  static TodoListInheritedWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TodoListInheritedWidget>();
}
