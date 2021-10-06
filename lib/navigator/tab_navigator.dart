import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import './goods_page.dart';
import './home_page.dart';
import './my_page.dart';
import './new_find_page.dart';
import 'package:flutter_app_yt/utils/color.dart';
import 'package:package_info/package_info.dart';

import '../translations.dart';

class TabNavigator extends StatefulWidget {
  final int index;
  TabNavigator({this.index = 0});
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = createMaterialColor(Color(0xffFFA805));
  var _controller = PageController(initialPage: 0);
  int _currentIndex = 0;
  DateTime _lastPressedAt; //上次点击时间

  @override
  void initState() {
    hideScreen();
    getPackageInfo();
    super.initState();

    setState(() {
      _controller = PageController(initialPage: widget.index ?? 0);
      _currentIndex = widget.index ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //隐藏启动屏
  Future<void> hideScreen() async {
    Future.delayed(Duration(milliseconds: 2000), () {
      FlutterSplashScreen.hide();
    });
  }

  //退出app
  // ignore: missing_return
  Future<bool> exitApp() {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
      EasyLoading.showToast('再按一次退出应用', duration: Duration(milliseconds: 1000));

      _lastPressedAt = DateTime.now();
      return Future.value(false);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  //获取packageInfo
  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print(
        'appName:$appName,packageName:$packageName,version:$version,buildNumber:$buildNumber}');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750);
    return Scaffold(
      body: WillPopScope(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: _controller,
            children: <Widget>[
              HomePage(),
              GoodsPage(),
              NewFindPage(),
              MyPage(),
            ],
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          onWillPop: exitApp),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff232836),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              _controller.jumpToPage(index);
              setState(() {
                _currentIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            _bottomItem(
                'assets/images/bottomNav1.png',
                'assets/images/bottomNav1-on.png',
                Translations.of(context).text('tabBar_0'),
                0),
            _bottomItem(
                'assets/images/bottomNav2.png',
                'assets/images/bottomNav2-on.png',
                Translations.of(context).text('tabBar_1'),
                1),
            _bottomItem(
                'assets/images/bottomNav3.png',
                'assets/images/bottomNav3-on.png',
                Translations.of(context).text('tabBar_2'),
                2),
            _bottomItem(
                'assets/images/bottomNav4.png',
                'assets/images/bottomNav4-on.png',
                Translations.of(context).text('tabBar_3'),
                3),
          ]),
    );
  }

  //底部导航item
  BottomNavigationBarItem _bottomItem(
      String img, String imgon, String title, int index) {
    return BottomNavigationBarItem(
        icon: new Image.asset(
          img,
          width: 25,
        ),
        activeIcon: new Image.asset(imgon, width: 25),
        title: Text(
          title,
          style: TextStyle(
              color: _currentIndex != index ? _defaultColor : _activeColor),
        ));
  }
}
