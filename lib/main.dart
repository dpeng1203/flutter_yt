import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  // 单独改变状态栏颜色
  SystemChrome.setSystemUIOverlayStyle(uiStyle);
  runApp(MyApp());
}

SystemUiOverlayStyle uiStyle = SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark);


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //定义一个通道
  static const platform = const MethodChannel('com.qubian.mob');
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  //调取原生的方法
  @override
  void initState() {
    super.initState();
    platform.invokeMethod('init', '1428258727198212110');
     loadSplash();
  }

  //调取原生的方法
  Future<Null> loadSplash() async {
    String result = await platform.invokeMethod('loadSplash', '1433978663107313689');
    setState(() {});
  }

  //调取原生的方法
//  Future<Null> loadInteraction() async {
//    String result = await platform.invokeMethod('loadInteraction', '1433978807190044702');
//    setState(() {});
//  }

  //调取原生的方法
//参数 VERTICAL 为竖屏播放
//参数 HORIZONTAL 为横屏播放
//  Future<Null> loadRewardVideo() async {
//    String result = await platform.invokeMethod('loadRewardVideo', ['1433978736562159696', 'VERTICAL']);
//    setState(() {});
//  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '数联宝',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WebviewPage(),
//      home: Column(
//        children: [
//          ElevatedButton(
//            child: Text('开屏广告'),
//            onPressed: () async {
//              await loadSplash();
//            },
//          ),
//          ElevatedButton(
//            child: Text('插屏广告'),
//            onPressed: () async {
//              await loadInteraction();
//            },
//          ),
//          ElevatedButton(
//            child: Text('激励视频广告'),
//            onPressed: () async {
//              await loadRewardVideo();
//            },
//          ),
//
//        ],
//      ),

    );
  }
}


//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: '数联宝',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      home: WebviewPage(),
//    );
//  }
//}

class WebviewPage extends StatefulWidget {
  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  DateTime _lastPressedAt; //上次点击时间
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  //定义一个通道
  static const platform = const MethodChannel('com.qubian.mob');
  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;


  //调取原生的方法 ，插屏
  Future<Null> loadInteraction({String id='1433978807190044702'}) async {
//    showToast("111");
    String result = await platform.invokeMethod('loadInteraction', id);
    if(result == "1") {
      final future =flutterWebViewPlugin.evalJavascript("adCb('"+id+"')");
      future.then((dynamic result) {
//        showToast('观看完成！');
      });
    }
//    showToast(result);
    setState(() {});
  }

  //调取原生的方法
//参数 VERTICAL 为竖屏播放
//参数 HORIZONTAL 为横屏播放
  Future<Null> loadRewardVideo({String id='1433978736562159696'}) async {
//    showToast("22");

    String result = await platform.invokeMethod('loadRewardVideo', [id, 'VERTICAL']);
    if(result == "1") {
      final future =flutterWebViewPlugin.evalJavascript("adCb('"+id+"')");
      future.then((dynamic result) {
//        showToast('观看完成！');
      });
    }
    setState(() {});
  }

  //退出app
  // ignore: missing_return
  Future<bool> exitApp() {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
      showToast("再按一次退出应用！");
      _lastPressedAt = DateTime.now();
      return Future.value(false);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  void showToast(
    String text, {
    gravity: ToastGravity.CENTER,
    toastLength: Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[900],
      // 灰色背景
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
//    flutterWebViewPlugin.close();

    // Add a listener to on url changed
    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      if (url.contains('taobao:') ||
          url.contains('jd:') ||
          url.contains('imeituan:') ||
          url.contains('pinduoduo:') ||
          url.contains('weixin:') ||
          url.contains('alipays:') ||
          url.contains('alipay:') ||
          url.contains('openapp.jdmobile:') ||
          url.contains('vipshop:')) {
        await flutterWebViewPlugin.stopLoading();
        await flutterWebViewPlugin.goBack();
        print(url);
        if (await canLaunch(url)) {
          showToast("打开应用！");
          await launch(url);
        } else {
          showToast("未安装此应用！");
//          throw 'Could not launch $url';
        }
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }


  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'handleAd',
        onMessageReceived: (JavascriptMessage message) {
//          showToast(message.message);
          var arr = message.message.split('-');
          var id = arr[1];
//          showToast(id);
          if(arr[0] == '1') {
            loadInteraction(id: id);
          }else if(arr[0] == '2') {
            loadRewardVideo(id: id);
          }

        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Center(
          child: WebviewScaffold(
//            url: "http://192.168.0.156:8092",
            url: "http://mg.2qzs.com/slbApp/index.html#/",
            javascriptChannels: <JavascriptChannel>[
              _alertJavascriptChannel(context),
            ].toSet(),
//            withZoom: false,
//            withLocalStorage: true,
//            withJavascript: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                  MediaQueryData.fromWindow(window).padding.top),
              child: SafeArea(
                top: true,
                child: Offstage(),
              ),
            ),
//            javascriptChannels: jsChannels,
//            mediaPlaybackRequiresUserGesture: false,
//            withZoom: true,
//            withLocalStorage: true,
//            hidden: true,
            //JS执行模式 是否允许JS执行
//            javascriptMode: JavascriptMode.unrestricted,
//            onWebViewCreated: (controller) {
//              _controller = controller;
//            },
//            onPageFinished: (url) {
//              _controller.evaluateJavascript("document.title").then((result){
//                setState(() {
//                  _title = result;
//                });
//              }
//              );
//            },
          ),
        ),
      ),
      onWillPop: () {
        Future<bool> canGoBack = flutterWebViewPlugin.canGoBack();
        canGoBack.then((str) {
          if (str) {
            flutterWebViewPlugin.goBack();
          } else {
//              Navigator.of(context).pop();
            this.exitApp();
          }
        });
      },
    );
  }
}
