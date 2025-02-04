import 'package:flutter/material.dart';

import '../page_index.dart';
import 'juzimi_home.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Image.asset("images/splash.jpg", fit: BoxFit.fitWidth),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    child: CloseButton(),
                    margin: EdgeInsets.only(top: 30)),
                Container(
                    child: Column(children: <Widget>[
                      Text('摘 ~ 抄', style: TextStyle(fontSize: 20.0)),
                      Gaps.vGap20,
                      Text('你喜欢 的 每一句', style: TextStyle(fontSize: 20.0))
                    ]),
                    margin: EdgeInsets.only(top: 100))
              ]),
              Container(
                  child: FlatButton(
                      onPressed: () =>
                          pushReplacement(context, JuzimiHomePage()),
                      child: Text('进入',
                          style:
                              TextStyle(fontSize: 30.0, color: Colors.grey))),
                  margin: EdgeInsets.only(bottom: 50.0))
            ])
      ]),
    );
  }
}
