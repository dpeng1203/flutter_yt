import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/Global.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/dao/login_dao.dart';
import 'package:flutter_app_yt/dao/my_dao.dart';
import 'package:flutter_app_yt/model/my_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:flutter_app_yt/translations.dart';
import 'package:flutter_app_yt/widget/image_picker_widget.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  String logoPath;
  String userName = '';
  int memberId;
  num totalAmount = 0;
  num totalAmountLock = 0;
  num totalBalance = 0;
  bool transfer = false;
  bool isShow = true;
  String langKey = 'zh';

  @override
  bool get wantKeepAlive => true;

  final List myNavList = [
    {
      "name": '资产概况',
      "trans_key": 'title_assets',
      "imagePath": 'assets/images/my-nav-1.png',
      "toRoutetrName": '/assets'
    },
    {
      "name": '数字钱包',
      "trans_key": 'my_numWallet',
      "imagePath": 'assets/images/my-nav-2.png',
      "toRoutetrName": '/wallet-address'
    },
    {
      "name": '挖矿记录',
      "trans_key": 'my_mining_record',
      "imagePath": 'assets/images/my-nav-3.png',
      "toRoutetrName": '/mining'
    },
    {
      "name": '矿宝区',
      "trans_key": 'my_mining_coupon',
      "imagePath": 'assets/images/index_coupn_icon.png',
      "toRoutetrName": '/coupon'
    },
  ];
  final List myNav1 = [
    {
      "name": '官方公告',
      "trans_key": 'my_notice_title',
      "imagePath": 'assets/images/arrow.png',
      "isLast": false,
      "toRoutetrName": '/notice'
    },
    {
      "name": '场外兑换',
      "trans_key": 'my_out_exchangge',
      "imagePath": 'assets/images/arrow.png',
      "isLast": false,
      "toRoutetrName": '/otc-view'
    },
    {
      "name": '邀请有奖',
      "trans_key": 'my_invite_prize',
      "imagePath": 'assets/images/arrow.png',
      "isLast": true,
      "toRoutetrName": '/my-invitte'
    },
  ];
  final List myNav2 = [
    {
      "name": '问题清单',
      "trans_key": 'my_qusiton_list',
      "imagePath": 'assets/images/arrow.png',
      "isLast": false,
      "toRoutetrName": '/my-question'
    },
    {
      "name": '安全中心',
      "trans_key": 'my_security_center',
      "imagePath": 'assets/images/arrow.png',
      "isLast": false,
      "toRoutetrName": '/my-security'
    },
    {
      "name": '切换语言',
      "trans_key": 'my_change_language',
      "imagePath": 'assets/images/arrow.png',
      "isLast": true,
      "toRoutetrName": '/switch-language'
    },
  ];
  RefreshController _controller = RefreshController();

  Future<Null> _refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    await getMerInfo();
    await getMerAmount();
    prefs.setBool('isPullDown', false);
    _controller.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    getMerInfo();
  }

  Future<void> getMerAmount() async {
    try {
      MyModel model = await MyDao.fetch();
      SharedPreferences prefs = await SharedPreferences.getInstance();
//      if(model.isNot)
      setState(() {
        totalAmount = model.totalAmount;
        totalAmountLock = model.totalAmountLock;
        totalBalance = model.totalBalance;
        transfer = model.transfer;
        logoPath = model.logoPath;
        userName = model.nickName;
        memberId = model.memberId;
        isShow = prefs.getBool('amountIsShow') ?? true;
        langKey = prefs.getString('language') ?? 'zh';
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getMerInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') != null) {
        getMerAmount();
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      print(e);
    }
  }

  _updateImg(val) async {
    var model = await MyDao.updateImg(memberId, val);
    if (model == true) {
      setState(() {
        logoPath = val;
      });
    }
  }

  _onLoginOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.clear();
    try {
      var model = await LoginDao.loginOut();
      if(model == true) {
            prefs.remove('token');
            Navigator.pushNamed(context, '/login');
          }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: SmartRefresher(
          controller: _controller,
          enablePullUp: false,
          header: GifLoading(),
          onRefresh: _refresh,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      width: 33,
                      height: 33,
                      child: ImagePickerWidget(
                        width: 33,
                        height: 33,
                        imagePath: logoPath,
                        callback: (val) {
                          _updateImg(val); //val  返回图片路劲
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'UID:$memberId',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff808B9C)),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/bills');
                      },
                      child: Text(
                        Translations.of(context)
                            .text('title_assets-change-book'),
                        //账单明细
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                decoration: BoxDecoration(
                  color: Color(0xff232836),
                  image: DecorationImage(
                      image: AssetImage('assets/images/my-asset-bg.png'),
                      fit: BoxFit.fill),
                ),
                child: Column(
                  children: [
                    Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${Translations.of(context).text('my_account_total')}(USDT)', // 账户总资产
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  isShow = !isShow;
                                  prefs.setBool("amountIsShow", isShow);
                                });
                              },
                              child: isShow
                                  ? Icon(const IconData(0xe60a,
                                      fontFamily: "iconfont"))
                                  : Icon(const IconData(0xe609,
                                      fontFamily: "iconfont")),
                            )
                          ],
                        ),
                        padding: EdgeInsets.only(bottom: 20)),
                    isShow
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('≈ '),
                              Text(
                                totalBalance.toString(),
                                style: TextStyle(
                                    fontSize: 28, color: Color(0xffFFA61A)),
                              )
                            ],
                          )
                        : Text(
                            '********',
                            style: TextStyle(
                                fontSize: 28, color: Color(0xffFFA61A)),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                                child: Text(
                                  '${Translations.of(context).text('my_account_lock')}(USDT)', // 冻结资产
                                  style: TextStyle(fontSize: 16),
                                ),
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                            isShow
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('≈ '),
                                      Text(
                                        totalAmountLock.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xffFFA61A)),
                                      )
                                    ],
                                  )
                                : Text('*****',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xffFFA61A))),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                                child: Text(
                                  '${Translations.of(context).text('my_account_usable')}(USDT)', //可用资产
                                  style: TextStyle(fontSize: 16),
                                ),
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                            isShow
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('≈ '),
                                      Text(
                                        totalAmount.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xffFFA61A)),
                                      )
                                    ],
                                  )
                                : Text('*****',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xffFFA61A))),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                    color: Color(0xff232836),
                    border: Border(
                        top: BorderSide(width: 1, color: Color(0xff32394C))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/assets-coin-out');
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              Translations.of(context).text('my_coin_out'), //提币
                              style: TextStyle(color: Color(0xffFFA61A)),
                            ),
                          ),
                        ),
                      ),
                      Text('|', style: TextStyle(color: Color(0xffFFA61A))),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/assets-coin-in');
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                                Translations.of(context)
                                    .text('my_coin_in'), //充币
                                style: TextStyle(color: Color(0xffFFA61A))),
                          ),
                        ),
                      ),
                      transfer
                          ? Text('|',
                              style: TextStyle(color: Color(0xffFFA61A)))
                          : Container(),
                      transfer
                          ? Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/assets-coin-transfer');
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Text(
                                      Translations.of(context)
                                          .text('my_account_transfer'), //转账
                                      style:
                                          TextStyle(color: Color(0xffFFA61A))),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )),
              Container(
                color: Color(0xff232836),
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: myNavList
                      .map((e) => GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, e['toRoutetrName']);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Image.asset(
                                    e['imagePath'],
                                    width: 24,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      // e['name'],
                                      Translations.of(context)
                                          .text(e['trans_key']),
//                                  style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                color: Color(0xff232836),
                child: Column(
                    children: myNav1
                        .map((e) => GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, e['toRoutetrName']);
                              },
                              child: Container(
                                height: 65,
                                decoration: BoxDecoration(
                                    border: !e["isLast"]
                                        ? Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xff32394C)))
                                        : Border(bottom: BorderSide.none)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(Translations.of(context)
                                          .text(e['trans_key'])),
                                    ),
                                    Image.asset(
                                      e['imagePath'],
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList()),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                color: Color(0xff232836),
                child: Column(
                    children: myNav2
                        .map((e) => GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, e['toRoutetrName'])
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      langKey = value;
                                    });
                                  }
                                });
                              },
                              child: Container(
                                height: 65,
                                decoration: BoxDecoration(
                                    border: !e["isLast"]
                                        ? Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xff32394C)))
                                        : Border(bottom: BorderSide.none)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(Translations.of(context)
                                          .text(e['trans_key'])),
                                    ),
                                    if (e['isLast'])
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Text('EN',
                                                style: TextStyle(
                                                  color: langKey == 'en'
                                                      ? Colors.orange
                                                      : Colors.white,
                                                )),
                                          ),
                                          Text('/'),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text('中',
                                                style: TextStyle(
                                                  color: langKey == 'zh'
                                                      ? Colors.orange
                                                      : Colors.white,
                                                )),
                                          ),
                                          Text('/'),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text('한',
                                                style: TextStyle(
                                                  color: langKey == 'ko'
                                                      ? Colors.orange
                                                      : Colors.white,
                                                )),
                                          ),
                                          Text('/'),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5.0, 5, 15, 5),
                                            child: Text('日',
                                                style: TextStyle(
                                                  color: langKey == 'ja'
                                                      ? Colors.orange
                                                      : Colors.white,
                                                )),
                                          ),
                                        ],
                                      ),
                                    Image.asset(
                                      e['imagePath'],
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList()),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                color: Color(0xff232836),
                height: 54,
                child: MaterialButton(
                  child: Text(
                    Translations.of(context).text('my_logout'),
                    style: TextStyle(fontSize: 19),
                  ), //退出登录
                  textColor: Colors.orange,
                  onPressed: () async {
                    Widget showwidget() {
                      return Text(
                        // 确定退出吗？
                        Translations.of(context).text('my_sure_logout'),
                        style: TextStyle(color: Color(0xff999999)),
                      );
                    }

                    ModelDialogs<String> _asstsdailog =
                        await MyDialog.passwordDialog(
                      context,
                      ispwd: false,
                      showWdiget: showwidget(),
                    );
                    if (_asstsdailog.type != 'ok') return;
                    _onLoginOut();
                  },
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  height: 20,
                  margin: EdgeInsets.only(bottom: 10),
                  child: RichText(
                    text: TextSpan(
                        text: '版本号:',
                        style: TextStyle(color: Colors.grey[700], fontSize: 10),
                        children: [
                          TextSpan(text: Global.appEnvironment.versionCode),
                          if (Global.appEnvironment.environment != 'pro')
                            TextSpan(
                                text: ' - ${Global.appEnvironment.environment}')
                        ]),
                  )

                  // Text(
                  //   Global.appEnvironment.environment,
                  //   style: TextStyle(color: Colors.grey[700]),
                  // )

                  )
            ],
          )),
    );
  }
}
