import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_app_yt/common/modal.dart';
import 'package:flutter_app_yt/common/tripleDes.dart';
import 'package:flutter_app_yt/dao/Mining_dao.dart';
import 'package:flutter_app_yt/dao/pay_dao.dart';
import 'package:flutter_app_yt/model/mining_model.dart';
import 'package:flutter_app_yt/model/util_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../translations.dart';

class MiningOrderHandle {
  int id;
  String type;
  MiningOrderHandle({this.id, this.type});
}

class MiningSelectTypeItem<T> {
  String title;
  bool active;
  String img;
  String type;
  int index;
  String imgon;
  MiningData data;
  int page;
  MiningSelectTypeItem(
      {this.title,
      this.img,
      this.imgon,
      this.active = false,
      this.data,
      this.type,
      this.index,
      this.page = 1});
}

class MiningBloc {
  BuildContext context;
  bool isLoadding = false; //加载中
  String selectType = 'goods';
  MiningPages _goodsModel = MiningPages(index: 'goods', page: 1, pagesize: 30);
  MiningData acitem;
  List<MiningSelectTypeItem<MiningData>> miningSelectList = [
    MiningSelectTypeItem<MiningData>(
        data: MiningData(),
        title: '算力包',
        type: 'goods',
        active: true,
        page: 1,
        index: 0,
        img: 'assets/images/mining-tab1.png',
        imgon: 'assets/images/mining-tab1_on.png'),
    MiningSelectTypeItem(
        data: MiningData(),
        title: '算力订单',
        active: false,
        type: 'orders',
        page: 1,
        index: 1,
        img: 'assets/images/mining-tab2.png',
        imgon: 'assets/images/mining-tab2_on.png'),
    MiningSelectTypeItem(
        data: MiningData(),
        title: '支付账单',
        active: false,
        type: 'payBooks',
        page: 1,
        index: 2,
        img: 'assets/images/mining-tab3.png',
        imgon: 'assets/images/mining-tab3_on.png'),
    MiningSelectTypeItem(
        data: MiningData(),
        title: '收益账单',
        type: 'settlementBooks',
        active: false,
        index: 3,
        img: 'assets/images/mining-tab4.png',
        page: 1,
        imgon: 'assets/images/mining-tab4_on.png'),
  ];

  final _handleChangeData = StreamController<MiningData>();
  Stream<MiningData> get handleChangeData => _handleChangeData.stream;

  final _handleChangeType = StreamController<int>();
  StreamSink<int> get handleChangType => _handleChangeType.sink;

  final _handleChangPageSize = StreamController<String>();
  StreamSink<String> get handleChangePageSize => _handleChangPageSize.sink;

  MiningBloc({this.context}) {
    loadData(_goodsModel);
    _handleChangeType.stream.listen(handleListenChangeType);
    _handleChangPageSize.stream.listen(handleListenChangeGetMore);

    miningSelectList[0].title =
        Translations.of(context).text('mining_hashrate');
    miningSelectList[1].title =
        Translations.of(context).text('mining_hashrateOrder');
    miningSelectList[2].title = Translations.of(context).text('mining_payBill');
    miningSelectList[3].title =
        Translations.of(context).text('mining_earningsBill');
  }

  /// 点击切换监听
  void handleListenChangeType(int i) {
    print("handleListenChangeType  $i");

    // MiningData _data = miningSelectList[i].data;
    miningSelectList[1].data.ordersVo = null;
    miningSelectList[2].data.payBooksVo = null;
    miningSelectList[3].data.settlementBooksVo = null;
    miningSelectList.forEach((element) {
      element.active = false;
    });

    _goodsModel.index = miningSelectList[i].type; // 加载类型
    selectType = miningSelectList[i].type; // 加载类型
    _goodsModel.page = 1; // 当前页码
    miningSelectList[i].active = true;
    loadData(_goodsModel);
  }

  /// 加载更多
  void handleListenChangeGetMore(String type) {
    if (selectType == 'goods') {
    } else if (selectType == 'orders') {
      if (acitem.ordersVo.pageCount > _goodsModel.page) {
        _goodsModel.page++;
        loadData(_goodsModel);
      }
    } else if (selectType == 'payBooks') {
      if (acitem.payBooksVo.pageCount > _goodsModel.page) {
        _goodsModel.page++;
        loadData(_goodsModel);
      }
    } else if (selectType == 'settlementBooks') {
      if (acitem.settlementBooksVo.pageCount > _goodsModel.page) {
        _goodsModel.page++;
        loadData(_goodsModel);
      }
    }
  }

  /// 赎回
  Future<void> handleUserRedeem(context, {int index}) async {
    ModelDialogs<String> _asstsdailog = await MyDialog.passwordDialog(context,
        ispwd: false,
        title:
            Translations.of(context).text('mining_modal_title'), //确认终止当前的算力服务
        showWdiget: Text(
          acitem.ordersVo.rows[index].deduct != ''
              ? '${Translations.of(context).text('mining_modal_msgbefore')} ${acitem.ordersVo.rows[index].deduct}'
              : '', // 需要扣除本金的
          style: TextStyle(fontSize: 15, color: Theme.of(context).accentColor),
        ),
        confirmtxt: Translations.of(context).text('goods_o_payBtn')); //确认支付
    if (_asstsdailog.type != 'ok') return;

    /// 检测用户名交易密码
    bool isTransactionPwd = await PayDao.checkUserIsHaveTransactionPwd();
    if (!isTransactionPwd) {
      Future.delayed(Duration(seconds: 1), () {
        EasyLoading.showToast(
            Translations.of(context).text('assets_out_ruleredit'),
            duration: Duration(seconds: 1)); //assets_out_ruleredit
      });
      return;
    }
    ModelDialogs<String> _dailog = await MyDialog.passwordDialog(context,
        title:
            Translations.of(context).text('assets_out_rulerIncode')); //请输入交易密码
    if (_dailog.type != 'ok') return;

    bool isredeem = await PayDao.userRedeemGoods(
        confirmPassword: TripleDesUtil.generateDes(_dailog.message),
        orderCode: acitem.ordersVo.rows[index].orderCode);
    if (isredeem) {
      _goodsModel.page = 1;
      acitem.ordersVo = null;
      miningSelectList[1].data.ordersVo = null;
      loadData(_goodsModel);
    }
  }

  RefreshController refreshcontroller = RefreshController();

  Future<Null> refreshData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPullDown', true);
    _goodsModel.page = 1;
    loadData(_goodsModel);
    // bolc.refreshData();
    prefs.setBool('isPullDown', false);
    refreshcontroller.refreshCompleted();
  }

  loadData(MiningPages pages) async {
    if (!isLoadding) {
      isLoadding = true;
      MiningData data = await MiningDao.fetch(pages: pages);
      if (selectType == 'goods') {
        miningSelectList[0].data = data;
        acitem = miningSelectList[0].data;
      } else if (selectType == 'orders') {
        if (pages.page != 1) {
          miningSelectList[1].data.ordersVo.rows.addAll(data.ordersVo.rows);
        } else {
          miningSelectList[1].data = data;
        }
        acitem = miningSelectList[1].data;
      } else if (selectType == 'payBooks') {
        if (pages.page != 1) {
          miningSelectList[2].data.payBooksVo.rows.addAll(data.payBooksVo.rows);
        } else {
          miningSelectList[2].data = data;
        }
        acitem = miningSelectList[2].data;
      } else if (selectType == 'settlementBooks') {
        if (pages.page != 1) {
          miningSelectList[3]
              .data
              .settlementBooksVo
              .rows
              .addAll(data.settlementBooksVo.rows);
        } else {
          miningSelectList[3].data = data;
        }
        acitem = miningSelectList[3].data;
      }

      _handleChangeData.add(acitem);
      isLoadding = false;
    }
  }

// index: 'orders',
// page: this.pageNums[id - 1],
// pageSize: this.pageSize

  dispose() {
    _handleChangeData.close();
    _handleChangeType.close();
    _handleChangPageSize.close();
  }

  void log() {
    print("MiningBloc log");
  }
}
