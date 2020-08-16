import 'package:todo_list/model/todo.dart';

class RegisterPageArgument {
  final String className;
  final String url;

  RegisterPageArgument(this.className, this.url);
}

enum OpenType {
  Add,
  Edit,
  Preview,
}

class EditTodoPageArgument {
  final OpenType openType;
  final Todo todo;

  EditTodoPageArgument({this.openType, this.todo});
}

class LocationDetailArgument {
  final Location location;

  LocationDetailArgument(this.location);
}
