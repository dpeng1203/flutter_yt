import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
//import 'package:install_plugin/install_plugin.dart';
import 'package:package_info/package_info.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

bool showed = false;
bool isDownLoading = false;
String appLocalPath;

class CustomerDialog {
  static void showUpdate(versionInfo) {
    if (Platform.isIOS) return;
//    BuildContext con = Router.navigatorKey.currentState.overlay.context;
    String text = versionInfo['updateContext'];
    String downloadUrl = versionInfo['appDownloadUrl'];
    String pkgUrl = versionInfo['clientDownloadUrl'];
    bool isForce = versionInfo['updateType'] != 1;
    AlertDialog alert = AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(0),
        title: Text(
          '更新提示',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: DownloadView(
            isForce: isForce,
            text: text,
            pkgUrl: pkgUrl,
            downloadUrl: downloadUrl)
//      actions: isForce ? [continueButton] : [cancelButton, continueButton],
        );
    if (!showed) {
      showed = true;
//      showDialog(
//        context: con,
//        barrierDismissible: false,
//        builder: (BuildContext context) {
//          return WillPopScope(
//            // 禁止物理返回建返回
//            child: alert,
//            onWillPop: () async {
//              return Future.value(false);
//            },
//          );
//        },
//      );
    }
  }
}

class DownloadView extends StatefulWidget {
  final String text;
  final String downloadUrl;
  final String pkgUrl;
  final bool isForce;
  DownloadView({this.text, this.downloadUrl, this.pkgUrl, this.isForce});
  @override
  _DownloadViewState createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  bool isdownloadding = false;
  num _progress = 0;
  _launchURL() async {
    if (await canLaunch(widget.downloadUrl)) {
      await launch(widget.downloadUrl);
    } else {
      throw 'Could not launch ${widget.downloadUrl}';
    }
  }

  // 申请权限
  Future<bool> _checkPermission() async {
    // 先对所在平台进行判断
//    PermissionStatus permission = await Permission.storage.status;
//    if (permission != PermissionStatus.granted) {
//      Map<Permission, PermissionStatus> permissions =
//          await [Permission.storage].request();
//      if (permissions[Permission.storage] == PermissionStatus.granted) {
//        return true;
//      }
//    } else {
//      return true;
//    }

    return false;
  }

  // 获取存储路径
  Future<String> _findLocalPath() async {
//    final directory = await getExternalStorageDirectory();
//    return directory.path;
  }

  downloadPkg() async {
    if (!isDownLoading) {
      isDownLoading = true;
      await _checkPermission();

      var _localPath = (await _findLocalPath()) + '/Download';
      appLocalPath = '$_localPath/fmapp.apk';
      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      // 不存在就新建路径
      if (!hasExisted) {
        savedDir.create();
      }
      installApk(widget.pkgUrl);
    }
  }

// ignore: missing_return
  Future<File> downloadAndroid(String url) async {
    /// 创建存储文件
//    Directory storageDir = await getExternalStorageDirectory();
//    String storagePath = storageDir.path;
    // String filepath = 'asf';
//    File file = new File('$storagePath/fmapp.apk');

//    if (!file.existsSync()) {
//      file.createSync();
//    }

    try {
      /// 发起下载请求
      Response response =
          await Dio().get(url, onReceiveProgress: (count, total) async {
        num progress = ((count / total) * 100).toInt();

        if (progress != 0)
          setState(() {
            _progress = progress;
          });
      },
              options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
              ));
//      file.writeAsBytesSync(response.data);
//      return file;
    } catch (e) {
      print(e);
    }
  }

  Future<Null> installApk(String url) async {
    File _apkFile = await downloadAndroid(url);
    String _apkFilePath = _apkFile.path;

    if (_apkFilePath.isEmpty) {
      print('make sure the apk file is set');
      return;
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
//    InstallPlugin.installApk(_apkFilePath, packageInfo.packageName)
//        .then((result) {
//      print('install apk $result');
//    }).catchError((error) {
//      print('install apk error: $error');
//    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
            child: Text(' ${widget.text}',
                style: TextStyle(height: 1.2, color: Colors.black)),
          ),
          Container(
            height: 12,
            alignment: Alignment.center,
            child: Text(
              _progress <= 1 ? '' : '下载 $_progress %',
              style: TextStyle(fontSize: 9, color: Colors.black),
            ),
          ),
          Container(
            height: 2,
            child: new LinearProgressIndicator(
              value: (_progress / 100).toDouble(),
              backgroundColor: Colors.white,
            ),
          ),
          widget.isForce
              ? GestureDetector(
                  onTap: () {
                    if (Platform.isIOS) {
                      _launchURL();
                    } else if (Platform.isAndroid) {
                      if (!isdownloadding) {
                        isdownloadding = true;
                        downloadPkg();
                      } else {
                        EasyLoading.showToast('下载中请勿重复操作...');
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    height: 50,
                    alignment: Alignment.center,
                    child: Text("确定", style: TextStyle(color: Colors.white)),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xffF1F1F1), width: 1.0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!isdownloadding) {
                              Navigator.of(context, rootNavigator: true).pop();
                            } else {
                              EasyLoading.showToast('下载中....');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5)),
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text("取消",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (Platform.isIOS) {
                              _launchURL();
                            } else if (Platform.isAndroid) {
                              if (!isdownloadding) {
                                isdownloadding = true;
                                downloadPkg();
                              } else {
                                EasyLoading.showToast('下载中请勿重复操作...');
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5))),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text("确定",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
