import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list/config/colors.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/pages/edit_todo.dart';
import 'package:todo_list/pages/home.dart';
import 'package:todo_list/pages/locationi_detail.dart';
import 'package:todo_list/pages/login.dart';
import 'package:todo_list/pages/register.dart';
import 'package:todo_list/pages/todo_entry.dart';
import 'package:todo_list/pages/webview.dart';

void main() => runApp(MyApp());

final Map<String, WidgetBuilder> routes = {
  HOME_PAGE_URL: (context) => HomePage(),
  LOGIN_PAGE_URL: (context) => LoginPage(),
  REGISTER_PAGE_URL: (context) => RegisterPage(),
  TODO_ENTRY_PAGE_URL: (context) => TodoEntryPage(),
  EDIT_TODO_PAGE_URL: (context) => EditTodoPage(),
  LOCATION_DETAIL_PAGE_URL: (context) => LocationDetailPage(),
  WEB_VIEW_PAGE_URL: (context) => WebViewPage(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: PRIMARY_COLOR,
        indicatorColor: ACCENT_COLOR,
        accentColor: PRIMARY_COLOR,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh', 'CN'),
      ],
      home: routes[HOME_PAGE_URL](context),
      onGenerateRoute: (RouteSettings settings) {
        if ([REGISTER_PAGE_URL, LOGIN_PAGE_URL].contains(settings.name)) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, _, __) => routes[settings.name](context),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        } else if ([EDIT_TODO_PAGE_URL].contains(settings.name)) {
          return CupertinoPageRoute<Todo>(
            builder: routes[settings.name],
            settings: settings,
            fullscreenDialog: true,
          );
        }
        return MaterialPageRoute(
          builder: routes[settings.name],
          settings: settings,
        );
      },
    );
  }
}
