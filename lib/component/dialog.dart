import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Container(width: 20, height: 20),
            Text('请求中...'),
          ],
        ),
      ),
    );
  }
}

class SimpleAlertDialog extends StatelessWidget {
  const SimpleAlertDialog({Key key, this.title, this.content}) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,
        maxLines: 3,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
