import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/src/easy_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class WebViewPage extends StatefulWidget {

  final Map router;
  WebViewPage({this.router});
  
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
//  InAppWebViewController webView;
  String _title = "未来矿场";
  List<Widget> _opraters = [];
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
    String url = widget.router['router'];
    if (url.indexOf('/#/news-detail') > -1 || url.indexOf('/#/activity-detail') > -1 ||
      (url.indexOf('/#/year') > -1 &&
          url.indexOf('/#/year-') <= -1)) {
              _opraters = [
                new IconButton(
                    icon: new Icon(Icons.share),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      EasyLoading.showSuccess('链接复制成功');
                    })
              ];
          } else {
            _opraters = [];
          }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff171D2A),
      appBar: AppBar(
        backgroundColor: Color(0xff171D2A),
        leading: CupertinoNavigationBarBackButton(
          color: Color.fromRGBO(255, 255, 255, 1),
          onPressed: () {
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
          _title,
          style: TextStyle(color: Colors.white),
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
//                initialUrl: widget.router['router'],
//                // initialUrl: 'http://192.168.0.111:8080/',
//                initialOptions: InAppWebViewGroupOptions(
//                    crossPlatform: InAppWebViewOptions(
//                  // debuggingEnabled: true,
//                  transparentBackground: true,
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
//                      handlerName: 'showLoading',
//                      callback: (args) async {
//                        EasyLoading.show(status: 'loading...');
//                      }
//                  );
//                  controller.addJavaScriptHandler(
//                      handlerName: 'hideLoading',
//                      callback: (args) async {
//                        EasyLoading.dismiss();
//                      }
//                  );
//                  controller.addJavaScriptHandler(
//                      handlerName: 'getLanuage',
//                      callback: (args) async {
//                        SharedPreferences prefs = await SharedPreferences.getInstance();
//                        var language = prefs.getString('language');
//                        return language ?? 'zh';
//                      }
//                  );
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
//                    String domain = url.split('.')[1] ?? '';
//                    bool isOut = domain != 'fm' && domain != 'futuremine';
//                    if (url.indexOf('/#/news-detail') > -1 || url.indexOf('/#/activity-detail') > -1 ||
//                        (url.indexOf('/#/year') > -1 && url.indexOf('/#/year-') <= -1) || isOut) {
//                      _opraters = [
//                        new IconButton(
//                            icon: new Icon(Icons.share),
//                            onPressed: () {
//                              Clipboard.setData(ClipboardData(text: url));
//                              EasyLoading.showSuccess('链接复制成功');
//                            })
//                      ];
//                    } else {
//                      _opraters = [];
//                    }
//                  });
//                },
//                onTitleChanged:
//                    (InAppWebViewController controller, String title) {
//                  setState(() {
//                    this._title = title;
//                  });
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
