import 'dart:convert';

import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static SharedPreferences _prefs;
  static String language;
  static String appTitle;
  static bool needDownLoadFile = false;
  static AppEnvironment appEnvironment;
  static PackageInfo packageInfo;

  static Future init() async {
    packageInfo = await PackageInfo.fromPlatform();
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('canceledUpdate', false);

    String la = _prefs.getString("language");
    if (la != null) {
      language = la;
    } else {
      language = 'zh';
    }

    // 生产环境默认数据  'iosfuturemine.io'
    if (['io.fm.www', 'iosfuturemine.io'].contains(packageInfo.packageName)) {
      appEnvironment = new AppEnvironment();
      appEnvironment.versionCode = packageInfo.version; // 每次加载更新版本号
      _prefs.setString('appEnv', 'pro');
      _prefs.setString('appEnvironment', jsonEncode(appEnvironment));
    } else {
      _prefs.setString('appEnv', 'test');
      // 初始化存储环境
      if (_prefs.getString("appEnvironmentTest") == null) {
        appEnvironment = new AppEnvironment(
            api: 'https://fmapptest.futuremine.info',
            h5Home: 'https://newstest.futuremine.info',
            jsotpkey: 'GAXGU4DQGJTHCMDH',
            versionCode: packageInfo.version,
            environment: 'test');
      } else {
        // 获取本地环境
        appEnvironment = AppEnvironment.fromJson(
            jsonDecode(_prefs.getString('appEnvironmentTest')));
        appEnvironment.versionCode = packageInfo.version;
      }
      _prefs.setString('appEnvironmentTest', jsonEncode(appEnvironment));
    }

    if (['io.fm.www', 'io.fm.test'].contains(packageInfo.packageName)) {
      needDownLoadFile = true;
    }
  }

  static void changeEnvironment(String type) async {
    if (type == 'dev') {
      appEnvironment.api = 'https://fmappdev.futuremine.info';
      // appEnvironment.api = 'http://192.168.50.34:10001';
      // appEnvironment.api = 'http://192.168.50.138:10001';
      appEnvironment.environment = 'dev';
      appEnvironment.h5Home = 'https://newsdev1.futuremine.info';
      appEnvironment.jsotpkey = 'GAXGU4DQGJTHCMDH';
    } else {
      appEnvironment.api = 'https://fmapptest.futuremine.info';
      // appEnvironment.api = 'http://54.65.118.211';
      appEnvironment.environment = 'test';
      appEnvironment.h5Home = 'https://newstest.futuremine.info';
      appEnvironment.jsotpkey = 'GAXGU4DQGJTHCMDH';
    }
    appEnvironment.versionCode = packageInfo.version;
    // appEnvironment.versionCode = '1.5.2';
    _prefs.setString('appEnvironmentTest', jsonEncode(appEnvironment.toJson()));
  }
}

class AppEnvironment {
  String environment;
  String api;
  String jsotpkey;
  String h5Home;
  String versionCode;
  AppEnvironment(
      {this.environment = 'pro',
      this.api = 'https://app.fm.io',
      this.h5Home = 'https://news.fm.io',
      this.jsotpkey = 'GAXGKZTZGY3XM2JW',
      this.versionCode});

  AppEnvironment.fromJson(Map<String, dynamic> json) {
    environment = json['environment'];
    api = json['api'];
    h5Home = json['h5Home'];
    jsotpkey = json['jsotpkey'];
    versionCode = json['versionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['environment'] = this.environment;
    data['api'] = this.api;
    data['jsotpkey'] = this.jsotpkey;
    data['h5Home'] = this.h5Home;
    data['versionCode'] = this.versionCode;
    return data;
  }
}
