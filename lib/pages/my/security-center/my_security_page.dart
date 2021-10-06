import 'package:flutter/material.dart';
import 'package:flutter_app_yt/utils/merInfo.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class MySecurityPage extends StatefulWidget {
  @override
  _MySecurityPageState createState() => _MySecurityPageState();
}

class _MySecurityPageState extends State<MySecurityPage> {
  String userName;

  Future<void> _getMemName() async {
    var _userName = await MerInfo.getMemName();
    setState(() {
      userName = _userName;
    });
  }

  @override
  void initState() {
    super.initState();
    _getMemName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopBackIcon(),
        title: Text(Translations.of(context).text('title_my-security-list')),
        //安全中心
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xff232836),
        height: 224,
        margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
        padding: EdgeInsets.fromLTRB(12, 0, 5, 0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/my-security-modify-password',
                    arguments: 1);
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xff444C61)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //修改登录密码
                    Text(Translations.of(context)
                        .text('my_security_list_modify_account_pwd')),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffAAAAAA),
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/my-security-modify-password',
                    arguments: 2);
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xff444C61)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //修改交易密码
                    Text(Translations.of(context)
                        .text('my_security_list_modify_transfrom_pwd')),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffAAAAAA),
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 56,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xff444C61)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //绑定账号
                  Text(
                      '${Translations.of(context).text('my_security_list_bind_account')}（${Translations.of(context).text('my_security_list_binded')}：$userName）'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/my-security-cert');
              },
              child: Container(
                height: 56,
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide.none)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //身份认证
                    Text(
                        Translations.of(context).text('my_security_list_cert')),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffAAAAAA),
                      size: 18,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
