import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list/component/todo_list_inherited_widget.dart';
import 'package:todo_list/const/route_argument.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/extension/date_time.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key key}) : super(key: key);

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
    _todoList = context.read<TodoList>();
    _initDate2TodoMap();
    _todoList.addListener(_updateData);
    _calendarController = CalendarController();
    _initialDay = DateTime.now().dayTime;
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

  void _onTap(Todo todo) async {
    Todo changedTodo = await Navigator.of(context).pushNamed(EDIT_TODO_PAGE_URL,
        arguments: EditTodoPageArgument(openType: OpenType.Preview, todo: todo));
    if (changedTodo == null) {
      return;
    }
    _todoList.update(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('日历'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            calendarController: _calendarController,
            locale: 'zh_CN',
            events: _date2TodoMap,
            headerStyle: HeaderStyle(),
            calendarStyle: CalendarStyle(
              todayColor: Colors.transparent,
              todayStyle: TextStyle(color: Colors.black),
            ),
            initialSelectedDay: _initialDay,
            onDaySelected: (DateTime day, List events) {
              this.setState(() {
                _todosToShow = events.cast<Todo>();
              });
            },
          ),
          Expanded(
            child: _buildTaskListArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskListArea() {
    return ListView.builder(
      itemCount: _todosToShow.length,
      itemBuilder: (context, index) {
        Todo todo = _todosToShow[index];
        return GestureDetector(
          onTap: () => _onTap(todo),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    color: todo.status.color,
                    height: 10,
                    width: 10,
                    margin: EdgeInsets.all(10),
                  ),
                  Text(todo.title),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 15,
                      color: Color(0xffb9b9bc),
                    ),
                    Text(
                      ' ${todo.startTime.hour} - ${todo.endTime.hour}',
                      style: TextStyle(color: Color(0xffb9b9bc)),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Color(0xffececed),
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              )
            ],
          ),
        );
      },
    );
  }
}
