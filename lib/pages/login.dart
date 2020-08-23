import 'package:flutter/material.dart';
import 'package:todo_list/component/dialog.dart';
import 'package:todo_list/component/fractionally_sized_trasition.dart';
import 'package:todo_list/component/image_hero.dart';
import 'package:todo_list/const/route_argument.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/model/network_client.dart';
import 'package:todo_list/utils/network.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool canLogin;
  bool useHero;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    canLogin = true;
    useHero = true;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    Animation<double> parentAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceIn,
    );
    Tween<double> tween = Tween<double>(begin: 0.4, end: 0.5);
    _animation = tween.animate(parentAnimation);
    _animationController.forward().then((value) => _animationController.reverse());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkInputValid(String _) {
    // 这里的参数写成 _ 是表示在这里我们没有使用这个参数，这是一种比较约定俗称的写法
    bool isInputValid =
        _emailController.text.contains('@') && _passwordController.text.length >= 6;
    if (isInputValid == canLogin) {
      return;
    }
    setState(() {
      canLogin = isInputValid;
    });
  }

  void _gotoRegister() {
    Navigator.of(context).pushNamed(
      REGISTER_PAGE_URL,
      arguments: RegisterPageArgument(
        'LoginPage',
        LOGIN_PAGE_URL,
      ),
    );
  }

  void _login() async {
    if (!canLogin) {
      return;
    }
    if (await checkConnectivityResult(context) == false) {
      return;
    }
    String email = _emailController.text;
    String password = _passwordController.text;
    showDialog(
      context: context,
      builder: (buildContext) => ProgressDialog(text: '请求中'),
    );
    String result = await NetworkClient.instance().login(email, password);
    Navigator.of(context).pop();
    if (result.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SimpleAlertDialog(
          title: '服务器返回信息',
          content: '登录失败，错误信息为：\n$result',
        ),
      );
      return;
    }
    setState(() {
      useHero = false;
    });
    Navigator.of(context).pushReplacementNamed(TODO_ENTRY_PAGE_URL);
  }

  @override
  Widget build(BuildContext context) {
    String markAssetName = 'assets/images/mark.png';
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
                        child: FractionallySizedTransition(
                          child: useHero
                              ? ImageHero.asset(markAssetName)
                              : Image.asset(markAssetName),
                          factor: _animation,
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
                                  obscureText: true,
                                  onChanged: _checkInputValid,
                                  controller: _passwordController,
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
                              onPressed: canLogin ? _login : null,
                              child: Text(
                                '登录',
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
                                  Text('没有账号？'),
                                  InkWell(
                                    child: Text('立即注册'),
                                    onTap: _gotoRegister,
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
