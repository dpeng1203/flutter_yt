import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/dao/my_security_dao.dart';
import '../translations.dart';

class CountDown extends StatefulWidget {
  final String operateType;
  final String target;

  CountDown({Key key, this.operateType = 'out', this.target = '_self_'})
      : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  //定义变量
  Timer _timer;
  bool flag = true;

  //倒计时数值
  var countdownTime = 0;

  //倒计时方法
  startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    //Timer.periodic 为创造一个重复的倒计时对象
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }


  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  Future<void> getCode() async {
    var model;
    try {
      if (widget.operateType == 'findpwd' || widget.operateType == 'register') {
            RegExp reg = new RegExp(r'^\d{11}$');
            RegExp reg1 = new RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');
            if (!reg.hasMatch(widget.target) && !reg1.hasMatch(widget.target)) {
              //请输入手机号码或者邮箱
              EasyLoading.showToast(
                  Translations.of(context).text('find_p_rulerMobile'));
              return;
            }
            flag = false;
            model = await MySecurityDao.getFindPasswordCode(
                widget.target, widget.operateType);
          } else {
          flag = false;
            model = await MySecurityDao.getCode(widget.target, widget.operateType);
          }
    } catch (e) {
      print(e);
      flag = true;
    }
    flag = true;
    print(model.toString());
    if (model == true) {
      startCountdown();
      //已发送，请在5分钟内使用
      EasyLoading.showSuccess(
          Translations.of(context).text('assets_out_sendedInfo'));
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(flag);
        if (countdownTime == 0 && flag == true) {
          getCode();
        }
      },
      child: Container(
        width: 90,
//        padding: EdgeInsets.fromLTRB(8, 1, 8, 0),
        margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Center(
          child: Text(
            //*秒后重新获取 ： 获取验证码
            countdownTime > 0
                ? "${countdownTime}s${Translations.of(context).text('find_p_resend')}"
                : Translations.of(context).text('find_p_getYzm'),
            style: TextStyle(fontSize: 11, color: Colors.white,),
          ),
        ),
      ),
    );
  }
}
