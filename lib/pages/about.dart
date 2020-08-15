import 'package:flutter/material.dart';
import 'package:todo_list/component/image_hero.dart';
import 'package:todo_list/const/route_url.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 12,
                        bottom: 12,
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(LOGIN_PAGE_URL);
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
