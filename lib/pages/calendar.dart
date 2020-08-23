import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list/extension/date_time.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key key, this.todoList}) : super(key: key);
  final TodoList todoList;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _calendarController;
  TodoList _todoList;
  DateTime _initialDay;
  Map<DateTime, List<Todo>> _date2TodoMap = {};
  List<Todo> _todosToShow = [];

  @override
  void initState() {
    super.initState();
    _todoList = widget.todoList;
    _calendarController = CalendarController();
    _initialDay = DateTime.now().dayTime;
    _initDate2TodoMap();
    _todoList.addListener(_updateData);
  }

  @override
  void dispose() {
    _todoList.removeListener(_updateData);
    _calendarController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _todosToShow.clear();
      _date2TodoMap.clear();
      _initDate2TodoMap();
    });
  }

  void _initDate2TodoMap() {
    _todoList.list.forEach((todo) {
      _date2TodoMap.putIfAbsent(todo.date, () => []);
      _date2TodoMap[todo.date].add(todo);
    });
    _todosToShow.addAll(_date2TodoMap[_initialDay] ?? []);
  }

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
