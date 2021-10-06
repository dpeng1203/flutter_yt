import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/src/easy_loading.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_yt/Global.dart';
import 'dart:io';

class OtcView extends StatefulWidget {
  @override
  _OtcViewState createState() => _OtcViewState();
}

class _OtcViewState extends State<OtcView> {
//  InAppWebViewController webView;
  // String _title = "场外兑换";
  String h5Home = Global.appEnvironment.h5Home;
  List<Widget> _opraters;
  double progress = 0;

  String _js = '''
  if (!window.flutter_inappwebview.callHandler) {
      window.flutter_inappwebview.callHandler = function () {
          var _callHandlerID = setTimeout(function () { });
          window.flutter_inappwebview._callHandler(arguments[0], _callHandlerID, JSON.stringify(Array.prototype.slice.call(arguments, 1)));
          return new Promise(function (resolve, reject) {
              window.flutter_inappwebview[_callHandlerID] = resolve;
          });
      };
  }
  ''';

  @override
  void initState() {
    super.initState();
//    _opraters = [
//      new IconButton(
//          icon: new Icon(Icons.view_list),
//          color: Colors.black,
//          onPressed: () {
//            webView.loadUrl(
//                url:
//                    '$h5Home/#/otc-list'); //$h5Home/#/otc-list http://192.168.0.111:8080/#/otc-list
//          })
//    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        centerTitle: true,
        leading: GestureDetector(
          child: Container(
            color: Colors.transparent,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          onTap: () {
//            Future<bool> canBack = webView.canGoBack();
//            if (webView != null) {
//              canBack.then((value) => {
//                    if (value)
//                      {webView.goBack()}
//                    else
//                      {Navigator.of(context).pop()}
//                  });
//            }
          },
        ),
        actions: _opraters,
        title: Text(
          Translations.of(context).text('my_out_exchangge'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: 1.5,
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
            Expanded(
//              child: InAppWebView(
//                initialUrl:
//                    "$h5Home/#/otc", // "$h5Home/#/otc",http://192.168.0.111:8080/#/otc
//                initialOptions: InAppWebViewGroupOptions(
//                    crossPlatform: InAppWebViewOptions(
//                  debuggingEnabled: true,
//                  userAgent: 'FUTUREM-MINE-APP',
//                  javaScriptCanOpenWindowsAutomatically: true,
//                )),
//                onWebViewCreated: (controller) {
//                  webView = controller;
//                  controller.addJavaScriptHandler(
//                      handlerName: 'getSysInfo',
//                      callback: (args) async {
//                        try {
//                          SharedPreferences prefs =
//                              await SharedPreferences.getInstance();
//                          if (prefs.getString('token') != null) {
//                            return {
//                              'platform': Platform.isIOS ? 'ios' : 'android',
//                              'token': prefs.getString('token')
//                            };
//                          } else {
//                            return {
//                              'platform': Platform.isIOS ? 'ios' : 'android',
//                              'token': -1
//                            };
//                          }
//                        } catch (e) {
//                          print(e);
//                          return e;
//                        }
//                      });
//                  controller.addJavaScriptHandler(
//                      handlerName: 'goLogin',
//                      callback: (args) async {
//                        Navigator.of(context).pushNamed('/login');
//                      });
//                  controller.addJavaScriptHandler(
//                      handlerName: 'goToConfirmPwd',
//                      callback: (args) async {
//                        Navigator.of(context)
//                            .pushNamed('/my-security-modify-password');
//                      });
//                  controller.addJavaScriptHandler(
//                      handlerName: 'showPasswordModal',
//                      callback: (args) async {
//                        ModelDialogs<String> _asstsdailog =
//                            await MyDialog.passwordDialog(context,
//                                title: Translations.of(context)
//                                    .text('transaction_title')); //'请输入交易密码'
//                        if (_asstsdailog.type != 'ok')
//                          return {'submit': false, 'pwd': null};
//                        var pwd = _asstsdailog.message;
//                        return {'submit': true, 'pwd': pwd};
//                      });
//                  controller.addJavaScriptHandler(
//                      handlerName: 'showLoading',
//                      callback: (args) async {
//                        EasyLoading.show(status: 'loading...');
//                      });
//                  controller.addJavaScriptHandler(
//                      handlerName: 'hideLoading',
//                      callback: (args) async {
//                        EasyLoading.dismiss();
//                      });
//                  controller.addJavaScriptHandler(
//                      handlerName: 'getLanuage',
//                      callback: (args) async {
//                        SharedPreferences prefs =
//                            await SharedPreferences.getInstance();
//                        var language = prefs.getString('language');
//                        return language ?? 'zh';
//                      });
//                },
//                onConsoleMessage: (InAppWebViewController controller,
//                    ConsoleMessage consoleMessage) {
//                  print(consoleMessage);
//                },
//                onLoadStop: (InAppWebViewController controller, String url) {
//                  controller.evaluateJavascript(source: _js);
//                },
//                onUpdateVisitedHistory: (InAppWebViewController controller,
//                    String url, bool androidIsReload) {
//                  setState(() {
//                    if (url.indexOf('/#/otc-list') <= -1) {
//                      _opraters = [
//                        new IconButton(
//                            icon: new Icon(Icons.view_list),
//                            color: Colors.black,
//                            onPressed: () {
//                              webView.loadUrl(url: '$h5Home/#/otc-list');
//                            })
//                      ];
//                    } else {
//                      _opraters = [];
//                    }
//                  });
//                },
//                onTitleChanged:
//                    (InAppWebViewController controller, String title) {
//                  // setState(() {
//                  //   this._title = title;
//                  // });
//                },
//                onProgressChanged:
//                    (InAppWebViewController controller, int progress) {
//                  setState(() {
//                    this.progress = progress / 100;
//                  });
//                },
//              ),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
