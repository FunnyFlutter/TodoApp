import 'package:flutter/material.dart';
import 'package:todo_list/config/colors.dart';
import 'package:todo_list/const/route_argument.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';
import 'package:todo_list/pages/reporter.dart';
import 'package:todo_list/pages/todo_list.dart';
import 'package:todo_list/utils/generate_todo.dart';

import 'about.dart';
import 'calendar.dart';

class TodoEntryPage extends StatefulWidget {
  const TodoEntryPage({Key key}) : super(key: key);

  @override
  _TodoEntryPageState createState() => _TodoEntryPageState();
}

class _TodoEntryPageState extends State<TodoEntryPage> {
  int currentIndex;
  List<Widget> pages;
  GlobalKey<TodoListPageState> todoListPageState = GlobalKey<TodoListPageState>();
  TodoList todoList;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    todoList = TodoList(generateTodos(3));
    pages = <Widget>[
      TodoListPage(key: todoListPageState, todoList: todoList),
      CalendarPage(todoList: todoList),
      Container(),
      ReporterPage(todoList: todoList),
      AboutPage(),
    ];
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    String imagePath, {
    double size,
    bool singleImage = false,
  }) {
    if (singleImage) {
      return BottomNavigationBarItem(
        icon: Image(
          width: size,
          height: size,
          image: AssetImage(imagePath),
        ),
        label: '',
      );
    }
    ImageIcon activeIcon = ImageIcon(
      AssetImage(imagePath),
      size: size,
      color: activeTabIconColor,
    );
    ImageIcon inactiveImageIcon = ImageIcon(
      AssetImage(imagePath),
      size: size,
      color: inactiveTabIconColor,
    );
    return BottomNavigationBarItem(
      activeIcon: activeIcon,
      icon: inactiveImageIcon,
      label: '',
    );
  }

  _onTabChange(int index) async {
    if (index == 2) {
      Todo todo = await Navigator.of(context).pushNamed(
        EDIT_TODO_PAGE_URL,
        arguments: EditTodoPageArgument(
          openType: OpenType.Add,
        ),
      );
      if (todo != null) {
        index = 0;
        todoListPageState.currentState.addTodo(todo);
      }
      return;
    }
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabChange,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem('assets/images/lists.png'),
          _buildBottomNavigationBarItem('assets/images/calendar.png'),
          _buildBottomNavigationBarItem(
            'assets/images/add.png',
            size: 50,
            singleImage: true,
          ),
          _buildBottomNavigationBarItem('assets/images/report.png'),
          _buildBottomNavigationBarItem('assets/images/about.png'),
        ],
      ),
      body: IndexedStack(
        children: pages,
        index: currentIndex,
      ),
    );
  }
}
