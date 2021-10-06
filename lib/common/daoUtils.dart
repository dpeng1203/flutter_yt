import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_app_yt/Global.dart';
import 'package:flutter_app_yt/common/customerDialog.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:otp/otp.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import '../main.dart';
import '../translations.dart';
import 'md5.dart';

class HttpRequest {
  static HttpRequest _instance;
  static Dio dio;
  static String lanuage;
  static AppEnvironment appEnvironment;
  static SharedPreferences prefs;
  static String currentApiCode;

  static HttpRequest getInstance() {
    if (_instance == null) {
      _instance = new HttpRequest();
    }
    return _instance;
  }

  static init() {
    Interceptor dInter =
        InterceptorsWrapper(onRequest: (RequestOptions options) {
      //1. 在进行任何网络请求的时候，可以添加一个loading显示
      if ((prefs.getBool('isPullDown') == null ||
          !prefs.getBool('isPullDown') &&
              options.queryParameters['isNeedLoading'])) {
        EasyLoading.show(status: 'loading...');
      }
      return options;
    }, onResponse: (Response response) {
      if (response.data['code'] == '1999' &&
          response.data['data']['updateType'] != '1') {
        EasyLoading.dismiss();
        // 强制提示更新
        CustomerDialog.showUpdate(response.data['version']);
      } else if (response.data['code'] == '2000' &&
          response.data['version'] != null &&
          response.data['version']['updateType'] == 1) {
        EasyLoading.dismiss();
        // 推荐提示更更新
        CustomerDialog.showUpdate(response.data['version']);
      } else if (response.data["code"] == "2000") {
        EasyLoading.dismiss();
        return response;
      } else if (response.data["code"] == "1007" ||
          response.data["code"] == "1008") {
        print('1007');
        EasyLoading.showToast(response.data["message"]);
        // 登录已过期，跳转回登录页
        prefs.remove('token');
//        Router.navigatorKey.currentState.pushNamed("/login");
        prefs.remove('token');
      } else if (response.data["code"] == "1922" &&
          currentApiCode == 'fm.member.login') {
        // 登录接口针对账号过期，需弹框提示，区分Toast提示，统一设定错误code码：1922
        EasyLoading.dismiss();
//        var context = Router.navigatorKey.currentState.overlay.context;
//        MyDialog.accountTip(
//            context,
//            Translations.of(context).text('login_failure'),
//            response.data["message"],
//            imgUrl: 'assets/images/error.png',
//            button: [Translations.of(context).text('show_tip_button_left')]);
      } else {
        EasyLoading.showToast(response.data["message"]);
        return response.data;
      }
    }, onError: (DioError error) {
      // print("拦截了错误");
      EasyLoading.dismiss();
      return error;
    });

    if (dio.interceptors.length == 0) {
      dio.interceptors.add(dInter);
    }
  }

  HttpRequest() {
    dio = new Dio();

    dio.options.headers = {
      //do something
      'Accept': 'application/json, text/plain, */*',
      'Content-Type': 'application/json',
    };
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 3000;
    init();
  }

  Future request(String apicode,
      {Map<String, dynamic> params, bool isNeedLoading = true}) async {
    currentApiCode = apicode;
    prefs = await SharedPreferences.getInstance();
    var token = prefs?.getString('token') ?? '-1';
    lanuage = prefs?.getString('language') ?? 'zh';
    String appEvn = (prefs?.getString('appEnv') ?? 'pro') == 'pro'
        ? 'appEnvironment'
        : 'appEnvironmentTest';

    appEnvironment = prefs?.getString(appEvn) == null
        ? new AppEnvironment()
        : AppEnvironment.fromJson(jsonDecode(prefs.getString(appEvn)));
    dio.options.baseUrl = appEnvironment.api;
    dio.options.headers.addAll(
        {"Authorization": "token $token", "ver": appEnvironment.versionCode});
    // 抓包 非生产环境 允许抓包  IP需要自定义
    if (appEnvironment.environment != 'pro') {
      // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      //     (client) {
      //   client.badCertificateCallback =
      //       (X509Certificate cert, String host, int port) {
      //     return true;
      //   };
      //   client.findProxy = (Uri) {
      //     return 'PROXY 192.168.0.109:7788';
      //   };
      // };
    }

    var _data = _paramsBase58(apicode, lanuage, params, appEnvironment.jsotpkey,
        appEnvironment.versionCode);
    try {
      Response response = await dio.post('/call',
          data: _data, queryParameters: {"isNeedLoading": isNeedLoading});
      return response.data;
    } on DioError catch (e) {
      formatError(e);
    }
  }

  upLoad(image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(path, filename: name)});
    try {
      var response = await dio.post("/upload",
          data: formData, queryParameters: {"isNeedLoading": true});
      return response.data;
    } on DioError catch (e) {
      formatError(e);
    }
  }

  _paramsBase58(String apicode, String lanugae, Map<String, dynamic> params,
      String otpkey, String versionCode) {
    // 入参排序
    //new一个map按照keys的顺序将原先的map数据取出来就可以了。
    var paramSorted = Map();
    if (params != null && params.isNotEmpty) {
      List<String> keys = params.keys.toList();
      // key排序
      keys.sort((a, b) {
        List<int> al = a.codeUnits;
        List<int> bl = b.codeUnits;
        for (int i = 0; i < al.length; i++) {
          if (bl.length <= i) return 1;
          if (al[i] > bl[i]) {
            return 1;
          } else if (al[i] < bl[i]) return -1;
        }
        return 0;
      });
      keys.forEach((element) {
        paramSorted[element] = params[element];
      });
    }
    //时间戳
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    var paramPublic = {
      "api_code": apicode,
      "api_version": '1.1',
      "biz_content": json.encode(paramSorted),
      "client_id":
          Platform.isAndroid ? 'ANDROID' : Platform.isIOS ? 'IOS' : 'USER',
      "client_version": versionCode,
      "language": lanugae,
      "sign_type": 'MD5',
      "timestamp": timestamp
    };

    var paramPublicStr = '';
    paramPublic.forEach((key, value) {
      paramPublicStr += '$key=$value&';
    });

    paramPublicStr = paramPublicStr.substring(0, paramPublicStr.length - 1);
    // 动态口令Apk  （测试开发用同一个，生产单独）
    // const jsotpkey = 'GAXGU4DQGJTHCMDH';
    var _otpCode = OTP.generateTOTPCodeString(otpkey, timestamp,
        algorithm: Algorithm.SHA1, isGoogle: true); // -> '637305'
//    print(_otpCode);
    var sign = Md5Util.generateMd5(paramPublicStr + _otpCode);

    paramPublic['sign'] = sign;
//    base58加密
    var bytes = utf8.encode(json.encode(paramPublic));
    return Base58Encode(bytes);
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      EasyLoading.showToast("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      EasyLoading.showToast("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      EasyLoading.showToast("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      EasyLoading.showToast("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      EasyLoading.showToast("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      EasyLoading.showToast("未知错误");
    }
  }
}
