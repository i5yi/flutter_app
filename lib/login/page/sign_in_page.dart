import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/global/custom_icon.dart';
import 'package:flutter_app/home_page.dart';
import 'package:flutter_app/login/page/forgot_password_page.dart';
import 'package:flutter_app/login/ui/submit_button.dart';
import 'package:flutter_app/login/ui/third_login_button.dart';
import 'package:flutter_app/utils/loading_util.dart';
import 'package:flutter_app/utils/route_util.dart';
import 'package:flutter_app/utils/sp_util.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isShowPassWord = false;
  bool isShowLoading = false;

  var _emailController = TextEditingController();
  var _pwdController = TextEditingController();

  Timer timer;

  /**
   * 利用FocusNode和FocusScopeNode来控制焦点
   * 可以通过FocusNode.of(context)来获取widget树中默认的FocusScopeNode
   */
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 23),
      child: Container(
        child: Stack(
          /// 注意这里要设置溢出如何处理，设置为visible的话，可以看到孩子，设置为clip的话，若溢出会进行裁剪
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: <Widget>[
            Column(children: <Widget>[
              /// 创建表单
              _buildLoginTextForm(),

              /// 忘记密码
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FlatButton(
                      color: Color(0x00000000),
                      shape: const StadiumBorder(),
                      onPressed: () {
                        pushNewPage(context, ForgotPasswordPage());
                      },
                      child: Text("忘记密码？",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              decoration: TextDecoration.underline)))),

              /// Or 横线
              Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 100.0,
                            height: 1.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.white10, Colors.white]),
                            )),
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text('Or',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white))),
                        Container(
                            width: 100.0,
                            height: 1.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.white, Colors.white10]),
                            ))
                      ])),

              /// 第三方登录按钮
              Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ThirdLoginButton(
                            onPressed: () {
                              Toast.show("微信", context);
                            },
                            icon: FontAwesomeIcons.weixin),
                        SizedBox(width: 40.0),
                        ThirdLoginButton(
                            onPressed: () {
                              Toast.show("QQ", context);
                            },
                            icon: FontAwesomeIcons.qq)
                      ]))
            ]),

            /// 登录按钮
            Padding(
                padding: const EdgeInsets.only(top: 148.0),
                child: SubmitButton(
                    title: "登录",
                    onTap: () {
                      if (_emailController.text.isEmpty) {
                        Toast.show("邮箱不能为空", context);
                      } else if (!Utils.isEmail(_emailController.text)) {
                        Toast.show("邮箱格式不正确", context);
                      } else if (_pwdController.text.isEmpty) {
                        Toast.show("密码不能为空", context);
                      } else if (_pwdController.text.length < 6) {
                        Toast.show("密码长度不能小于6位！", context);
                      } else {
                        getLoadingWidget();
                        isShowLoading = true;
                        _login();
                      }
                    }))
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTextForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
      width: 300.0,

      /// Flutter提供了一个Form widget，它可以对输入框进行分组，然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// 邮箱输入框
            _buildEmailInput(),

            Container(
              width: 250.0,
              height: 1.0,
              color: Colors.grey[100],
              padding: const EdgeInsets.only(top: 10.0),
            ),

            /// 密码
            _buildPasswordInput(),

            Container(
              width: 250.0,
              height: 1.0,
              color: Colors.grey[100],
              margin: const EdgeInsets.only(bottom: 40.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: TextFormField(
        controller: _emailController,
        maxLines: 1,

        /// 输入类型
        keyboardType: TextInputType.emailAddress,

        /// 是否自动更正
        autocorrect: false,

        /// 是否自动获得焦点
        autofocus: false,

        /// 是否禁用textfield:如果为false, textfield将被“禁用”
        enabled: true,

        /// 键盘动作按钮点击之后执行的代码： 光标切换到指定的输入框
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(passwordFocusNode),
        decoration: InputDecoration(
          icon: Icon(Icons.email, color: Colors.black),
          hintText: "请输入邮箱",
          border: InputBorder.none,
        ),

        /// 文本样式
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: TextFormField(
        controller: _pwdController,
        keyboardType: TextInputType.text,

        /// 关联焦点
        focusNode: passwordFocusNode,

        /// 装饰器
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.black),
          hintText: "请输入密码",
          border: InputBorder.none,
          suffixIcon: IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
                isShowPassWord
                    ? CustomIcon.show_password
                    : CustomIcon.hidden_password,
                color: Colors.black),
            onPressed: () => showPassword(),
          ),
        ),

        /// 控制键盘的功能键 指enter键，比如此处设置为next时，enter键显示的文字内容为 下一步
        textInputAction: TextInputAction.done,

        /// 最大行数
        maxLines: 1,

        /// 是否需要用******显示
        obscureText: !isShowPassWord,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    );
  }

  void showPassword() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  void _login() async {
    SpUtil.setBool("isLogin", true);
    timer = Timer(Duration(seconds: 1), () {
      if (isShowLoading) {
        Navigator.of(context).pop();
      }
      pushAndRemovePage(context, HomePage());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }
}
