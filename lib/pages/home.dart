import 'package:flutter/cupertino.dart';
import 'package:todo_list/const/route_argument.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/model/login_center.dart';

class HomePage extends StatelessWidget {
  void _goToLoginOrTodoEntry(BuildContext context) async {
    String currentUserKey = await LoginCenter.instance().currentUserKey();
    if (currentUserKey.isEmpty) {
      Navigator.of(context).pushReplacementNamed(LOGIN_PAGE_URL);
    } else {
      Navigator.of(context).pushReplacementNamed(
        TODO_ENTRY_PAGE_URL,
        arguments: TodoEntryArgument(currentUserKey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _goToLoginOrTodoEntry(context);
    return Container();
  }
}
