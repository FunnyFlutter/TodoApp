import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/component/delete_todo_dialog.dart';
import 'package:todo_list/const/route_argument.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/model/todo_list.dart';
import 'package:provider/provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage();

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  TodoList todoList;
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    todoList = context.read<TodoList>();
    todoList.addListener(_updateTodoList);
  }

  void _updateTodoList() {
    TodoListChangeInfo changeInfo = todoList.value;
    if (changeInfo.type == TodoListChangeType.Update) {
      setState(() {});
    } else if (changeInfo.type == TodoListChangeType.Delete) {
      Todo todo = changeInfo.todoList[changeInfo.insertOrRemoveIndex];
      animatedListKey.currentState.removeItem(changeInfo.insertOrRemoveIndex, (
        BuildContext context,
        Animation<double> animation,
      ) {
        return SizeTransition(
          sizeFactor: animation,
          child: TodoItem(todo: todo),
        );
      });
    } else if (changeInfo.type == TodoListChangeType.Insert) {
      animatedListKey.currentState.insertItem(changeInfo.insertOrRemoveIndex);
    } else {
      // do nothing
    }
  }

  @override
  void dispose() {
    todoList.removeListener(_updateTodoList);
    super.dispose();
  }

  void addTodo(Todo todo) {
    todoList.add(todo);
  }

  void removeTodo(Todo todo) async {
    bool result = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteTodoDialog(
            todo: todo,
          );
        });
    if (result) {
      todoList.remove(todo.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('清单'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => todoList.syncWithNetwork(),
        child: AnimatedList(
          key: animatedListKey,
          initialItemCount: todoList.length,
          itemBuilder: (
            BuildContext context,
            int index,
            Animation<double> animation,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: TodoItem(
                todo: todoList.list[index],
                onTap: (Todo todo) async {
                  await Navigator.of(context).pushNamed(
                    EDIT_TODO_PAGE_URL,
                    arguments: EditTodoPageArgument(
                      openType: OpenType.Preview,
                      todo: todo,
                    ),
                  );
                  todoList.update(todo);
                },
                onFinished: (Todo todo) {
                  todo.isFinished = !todo.isFinished;
                  todoList.update(todo);
                },
                onStar: (Todo todo) {
                  todo.isStar = !todo.isStar;
                  todoList.update(todo);
                },
                onLongPress: removeTodo,
              ),
            );
          },
        ),
      ),
    );
  }
}

typedef TodoEventCallback = Function(Todo todo);

class TodoItem extends StatelessWidget {
  final Todo todo;
  final TodoEventCallback onStar;
  final TodoEventCallback onFinished;
  final TodoEventCallback onTap;
  final TodoEventCallback onLongPress;

  const TodoItem({
    Key key,
    this.todo,
    this.onStar,
    this.onFinished,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: todo.isFinished ? 0.3 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: 2,
              color: todo.priority.color,
            ),
          ),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        height: 110,
        child: GestureDetector(
          onTap: () => onTap(todo),
          onLongPress: () => onLongPress(todo),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => onFinished(todo),
                        child: Image.asset(
                          todo.isFinished ? 'assets/images/rect_selected.png' : 'assets/images/rect.png',
                          width: 25,
                          height: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(todo.title),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => onStar(todo),
                    child: Container(
                      child: Image.asset(
                        todo.isStar ? 'assets/images/star.png' : 'assets/images/star_normal.png',
                      ),
                      width: 25,
                      height: 25,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/group.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      todo.timeString,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
