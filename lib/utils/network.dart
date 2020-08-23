import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

Future<bool> checkConnectivityResult(BuildContext context) async {
  ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('请求失败'),
        content: Text('设备尚未连入网络'),
        actions: <Widget>[
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
    return false;
  }
  return true;
}
