import 'package:flutter/material.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../translations.dart';

class PaySuccess extends StatelessWidget {
  final String title;
  PaySuccess({this.title = '支付成功'});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)..pop()..pop();
        return;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: TopBackIcon(
              tap: () {
                Navigator.of(context)..pop()..pop();
              },
            ),
            title: Text(Translations.of(context).text('goods_o_order_paid')),
            elevation: 0.0,
          ),
          body: Container(
            margin: EdgeInsets.only(top: 100),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/pay_success.png',
                  width: 120,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/mining');
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 40),
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.white, width: 1.0)),
                      // 查看订单
                      child: Text(
                        Translations.of(context).text('goods_o_check_order'),
                        style: TextStyle(fontSize: 16),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
