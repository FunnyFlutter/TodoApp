import 'package:flutter/material.dart';
import 'package:todo_list/component/image_hero.dart';
import 'package:todo_list/component/user_key_inerited_widget.dart';
import 'package:todo_list/const/route_argument.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/model/login_center.dart';
import 'package:todo_list/model/network_client.dart';
import 'package:todo_list/model/todo_list.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoList todoList = context.watch<TodoList>();
    String userKey = UserKeyInheritedWidget.of(context).userKey;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('日历'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                  child: FractionallySizedBox(
                    child: ImageHero.asset('assets/images/mark.png'),
                    widthFactor: 0.3,
                    heightFactor: 0.3,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Funny Flutter Todo',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Center(
                            child: Text('版本 1.0.0'),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        '隐私政策',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pushNamed(
                        WEB_VIEW_PAGE_URL,
                        arguments: WebViewArgument(
                          'https://forelax.space/privacy-policy/',
                          '隐私政策',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 12,
                        bottom: 12,
                      ),
                      child: FlatButton(
                        onPressed: () async {
                          await NetworkClient.instance().uploadList(
                            todoList.list,
                            userKey,
                          );
                          await LoginCenter.instance().logout();
                          Navigator.of(context).pushReplacementNamed(LOGIN_PAGE_URL);
                        },
                        color: Colors.red,
                        disabledColor: Colors.red,
                        child: Text(
                          '退出登录',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
