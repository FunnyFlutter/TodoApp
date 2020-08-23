import 'package:flutter/material.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';

class ReporterPage extends StatefulWidget {
  const ReporterPage({Key key, this.todoList}) : super(key: key);

  final TodoList todoList;

  @override
  _ReporterPageState createState() => _ReporterPageState();
}

class _ReporterPageState extends State<ReporterPage> {
  TodoList _todoList;

  int _finishedTodoCount = 0;
  int _delayedTodoCount = 0;

  List<Todo> _todosOfThisMonth = [];

  int currentMonth = 1;

  @override
  void initState() {
    super.initState();
    _todoList = widget.todoList;
    _initTodosOfThisMonth();
    _todoList.addListener(_updateData);
  }

  @override
  void dispose() {
    _todoList.removeListener(_updateData);
    super.dispose();
  }

  void _reset() {
    _finishedTodoCount = 0;
    _delayedTodoCount = 0;
    _todosOfThisMonth.clear();
  }

  /// month: [1..12]
  void _initTodosOfThisMonth() {
    _todoList.list.forEach((todo) {
      if (todo.date != null && todo.date.month == currentMonth) {
        _todosOfThisMonth.add(todo);
        TodoStatus status = todo.status;
        if (status == TodoStatus.finished) {
          _finishedTodoCount += 1;
        }
        if (status == TodoStatus.delay) {
          _delayedTodoCount += 1;
        }
      }
    });
  }

  void _updateData() {
    setState(() {
      _reset();
      _initTodosOfThisMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务回顾'),
      ),
      body: Center(
        child: Text(
          this.runtimeType.toString(),
        ),
      ),
    );
  }
}
