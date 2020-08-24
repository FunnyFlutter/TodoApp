import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_list/component/dialog.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/model/network_client.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final picker = ImagePicker();

  bool canRegister;
  File image;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    canRegister = false;
  }

  void _checkInputValid(String _) {
    bool isInputValid = _emailController.text.contains('@') &&
        _passwordController.text.length >= 6 &&
        _passwordController.text == _repeatPasswordController.text;
    if (isInputValid == canRegister) {
      return;
    }
    setState(() {
      canRegister = isInputValid;
    });
  }

  void _gotoLogin() {
    Navigator.of(context).pushReplacementNamed(LOGIN_PAGE_URL);
  }

  void _getImage() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile.path);
    });
  }

  void _register() async {
    if (!canRegister) {
      return;
    }
    String email = _emailController.text;
    String password = _passwordController.text;
    showDialog(
      context: context,
      builder: (buildContext) => ProgressDialog(text: '请求中'),
    );
    String result = await NetworkClient.instance().register(
      email,
      password,
      image: image,
    );
    Navigator.of(context).pop();
    if (result.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SimpleAlertDialog(
          title: '服务器返回信息',
          content: '注册失败，错误信息为：\n$result',
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacementNamed(TODO_ENTRY_PAGE_URL);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            //利用MediaQuery来获取屏幕的高度
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Center(
                        child: GestureDetector(
                          onTap: _getImage,
                          child: FractionallySizedBox(
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 48,
                                  backgroundImage: image == null
                                      ? AssetImage(
                                          'assets/images/default_avatar.png',
                                        )
                                      : FileImage(image),
                                ),
                                Positioned(
                                  right: 20,
                                  top: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(17),
                                      ),
                                      color: Color.fromARGB(255, 80, 210, 194),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 34,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            widthFactor: 0.4,
                            heightFactor: 0.4,
                          ),
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
                            padding: EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: '请输入邮箱',
                                    labelText: '邮箱',
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (String value) {
                                    FocusScope.of(context).nextFocus();
                                  },
                                  onChanged: _checkInputValid,
                                  controller: _emailController,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: '请输入六位以上的密码',
                                    labelText: '密码',
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (String value) {
                                    FocusScope.of(context).nextFocus();
                                  },
                                  obscureText: true,
                                  onChanged: _checkInputValid,
                                  controller: _passwordController,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: '再次输入密码',
                                    labelText: '确认密码',
                                  ),
                                  obscureText: true,
                                  onChanged: _checkInputValid,
                                  controller: _repeatPasswordController,
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
                              onPressed: canRegister ? _register : null,
                              child: Text(
                                '注册并登录',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              disabledColor: Color.fromRGBO(69, 202, 160, 0.5),
                              color: Color.fromRGBO(69, 202, 181, 1),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 24, right: 24, top: 12, bottom: 12),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('已有账号？'),
                                  InkWell(
                                    child: Text('立即登录'),
                                    onTap: _gotoLogin,
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}
