import 'package:flutter/material.dart';
import 'package:flutter_app_yt/model/goods_models.dart';
import 'package:flutter_app_yt/model/mining_model.dart';
import 'package:flutter_app_yt/pages/mining/bloc.dart';
import 'package:flutter_app_yt/common/NumberFormat.dart';
import 'package:flutter_app_yt/widget/list_no_data.dart';
import 'package:flutter_app_yt/widget/my_assetes_images.dart';
import 'package:flutter_app_yt/widget/refreshHeader.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../translations.dart';

class MiningProvider extends InheritedWidget {
  final Widget child;
  final MiningBloc bloc;

  MiningProvider({
    this.child,
    this.bloc,
  }) : super(child: child);

  static MiningProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MiningProvider>();

  @override
  bool updateShouldNotify(MiningProvider oldWidget) {
    return true;
  }
}

class MiningPage extends StatefulWidget {
  @override
  _MiningPageState createState() => _MiningPageState();
}

class _MiningPageState extends State<MiningPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.popAndPushNamed(context, '/navigator', arguments: 3);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TopBackIcon(
            tap: () {
              Navigator.popAndPushNamed(context, '/navigator', arguments: 3);
            },
          ),
          title: Text(Translations.of(context).text('title_mining')),
          elevation: 0.0,
        ),
        body: MiningProvider(
          bloc: MiningBloc(context: context),
          child: MinintListView(),
        ),
      ),
    );
  }
}

// class MinintListView extends StatelessWidget {

// }

class MinintListView extends StatefulWidget {
  @override
  _MinintListViewState createState() => _MinintListViewState();
}

class _MinintListViewState extends State<MinintListView> {
  /// 算力包列表
  Widget _miningGoodsItem(BuildContext context, int index, MiningData data) {
    return Container(
      height: 130,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
          color: Color(0xff232836),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    MyAssetsImage(
                      assetsUrl:
                          Translations.of(context).text('goods_icon_rent'),
                      width: 18,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${data.goods[index].goodsName}',
                      style: TextStyle(fontSize: 13, color: Color(0xffFFA61A)),
                    )
                  ],
                ),
              ),
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    // 累计挖得
                    Text(
                      Translations.of(context)
                          .text('mining_hashrateOrder_totalObtain'),
                      style: TextStyle(fontSize: 12, color: Color(0xffaaaaaa)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '${data.goods[index].totalMiningAmount} ${data.goods[index].coinType.toUpperCase()}',
                      style: TextStyle(
                        color: Color(0xffFFA61A),
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    // 累计激励
                    Text(
                      Translations.of(context)
                          .text('mining_hashrateOrder_totalStimulate'),
                      style: TextStyle(fontSize: 12, color: Color(0xffaaaaaa)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '${data.goods[index].totalRewardAmount} FM',
                      style: TextStyle(
                        color: Color(0xffFFA61A),
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 25,
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1.0, color: Color(0xff444C61)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          // 我拥有

                          Text(
                            '${Translations.of(context).text('mining_hashrate_have')}：',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xffaaaaaa)),
                          ),
                          // 共   份
                          Text(
                              '${Translations.of(context).text('mining_hashrate_total')} ${data.goods[index].totalCount} ${Translations.of(context).text('mining_hashrate_totalUnit')}',
                              style: TextStyle(
                                fontSize: 12,
                              )),
                          (data.goods[index].totalHashrate != null &&
                                  data.goods[index].totalHashrate != 0)
                              ? Text('，${data.goods[index].totalHashrate}T',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ))
                              : SizedBox(),
                        ],
                      ),
                    ),
                    if (data.goods[index].judge)
                      Container(
                        child: Row(
                          children: <Widget>[
                            // 单份合约算力
                            Text(
                              '${Translations.of(context).text('mining_hashrate_singleContractCounts')}：',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xffaaaaaa)),
                            ),
                            Text('${data.goods[index].unit}',
                                style: TextStyle(
                                  fontSize: 12,
                                ))
                          ],
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
          if (data.goods[index].orderState == 3)
            Positioned(
                right: 20,
                top: 25,
                child: MyAssetsImage(
                  assetsUrl: Translations.of(context).text('mining_icon_going'),
                  width: 66,
                  height: 57,
                ))
        ],
      ),
    );
  }

  /// 收益账单
  Widget _miningSettlementBooksItem(
      BuildContext context, int index, MiningData data) {
    return Container(
      height: 70,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          color: Color(0xff232836),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Text(IconList.get('btc')),
          Image.asset(
            '${IconList.get(data.settlementBooksVo.rows[index].coinType)}',
            width: 25,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // '挖矿激励' : '挖矿结算'

                    Text(
                      '${data.settlementBooksVo.rows[index].coinType == 'fm' ? Translations.of(context).text('mining_earningsBill_stimulate') : Translations.of(context).text('mining_earningsBill_settleAccounts')}',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    // 审核中

                    data.settlementBooksVo.rows[index].state == 0
                        ? Text(
                            '(${Translations.of(context).text('mining_earningsBill_checking')})',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xffFFA61A)),
                          )
                        : SizedBox()
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  data.settlementBooksVo.rows[index].settlementTime,
                  style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '+ ${data.settlementBooksVo.rows[index].amount}  ${data.settlementBooksVo.rows[index].coinType.toUpperCase()}',
            style: TextStyle(color: Color(0xffFFA61A), fontSize: 16),
          )
        ],
      ),
    );
  }

  /// 支付账单
  Widget _miningPayBooksItem(BuildContext context, int index, MiningData data) {
    return Container(
      height: data.payBooksVo.rows[index].actualAmount2 == 0 ? 150 : 185,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
      decoration: BoxDecoration(
          color: Color(0xff232836),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 35,
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1.0, color: Color(0xff373737)))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MyAssetsImage(
                  assetsUrl: Translations.of(context).text('goods_icon_rent'),
                  width: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  data.payBooksVo.rows[index].goodsName,
                  style: TextStyle(
                      fontSize: 13, color: Theme.of(context).accentColor),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // 支付数量
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 3),
                // 支付数量：
                child: Text(
                  '${Translations.of(context).text('mining_payBill_payCount')}：',
                  style: TextStyle(fontSize: 12, color: Color(0xffaaaaaa)),
                ),
              ),
              Text(
                '${NumberFormat.formatDoubel(data.payBooksVo.rows[index].actualAmount)}',
                style: TextStyle(
                    fontSize: 26, color: Theme.of(context).accentColor),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 3),
                child: Text(
                  '${data.payBooksVo.rows[index].payType.toUpperCase()}',
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).accentColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          // 支付数量2
          if (data.payBooksVo.rows[index].actualAmount2 != 0)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 3),
                  // 支付数量：
                  child: Text(
                    '${Translations.of(context).text('mining_payBill_payCount')}：',
                    style: TextStyle(fontSize: 12, color: Color(0xffaaaaaa)),
                  ),
                ),
                Text(
                  '${NumberFormat.formatDoubel(data.payBooksVo.rows[index].actualAmount2)}',
                  style: TextStyle(
                      fontSize: 26, color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 3),
                  child: Text(
                    '${data.payBooksVo.rows[index].payType2.toUpperCase()}',
                    style: TextStyle(
                        fontSize: 12, color: Theme.of(context).accentColor),
                  ),
                ),
              ],
            ),
          if (data.payBooksVo.rows[index].actualAmount2 != 0)
            SizedBox(
              height: 4,
            ),
          // 订单编号
          Text(
            '${Translations.of(context).text('mining_payBill_id')}：${data.payBooksVo.rows[index].orderCode}',
            style: TextStyle(fontSize: 12, color: Color(0xffaaaaaa)),
          ),
          SizedBox(
            height: 4,
          ),
          // 订单方式   支付
          Text(
            '${Translations.of(context).text('mining_payBill_type')}：${data.payBooksVo.rows[index].payType.toUpperCase()} ${data.payBooksVo.rows[index].payType2 != '' ? '+ ${data.payBooksVo.rows[index].payType2.toUpperCase()}' : ''}${Translations.of(context).text('goods_o_pay')}',
            style: TextStyle(fontSize: 12, color: Color(0xffaaaaaa)),
          ),

          SizedBox(
            height: 4,
          ),
          // 订单时间
          Text(
            '${Translations.of(context).text('mining_payBill_time')}：${data.payBooksVo.rows[index].payTime}',
            style: TextStyle(fontSize: 12, color: Color(0xffaaaaaa)),
          )
        ],
      ),
    );
  }

  /// 算力订单
  Widget _miningOrdersItem(
      BuildContext context, int index, MiningData data, MiningBloc bloc) {
    TextStyle _listitem = TextStyle(fontSize: 12, color: Color(0xffaaaaaa));
    MiningOrdersRow _data = data.ordersVo.rows[index];
    return Container(
      height: 240,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(20, 2, 20, 10),
      decoration: BoxDecoration(
          color: Color(0xff232836),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: <Widget>[
          Container(
            height: 35,
            decoration: BoxDecoration(
                // color: Colors.red,
                border: Border(
                    bottom: BorderSide(width: 1.0, color: Color(0xff373737)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      MyAssetsImage(
                        assetsUrl:
                            Translations.of(context).text('goods_icon_rent'),
                        width: 18,
                      ),
                      SizedBox(width: 10),
                      Text('${data.ordersVo.rows[index].goodsName}',
                          style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).accentColor))
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (_data.orderLevelUpFlag == 1)
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/goods-detail',
                                arguments: GoodsDetailsParams(
                                    orderCode: _data.orderCode,
                                    goodsCode: _data.goodsCode,
                                    totalcount: _data.num));
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Theme.of(context).accentColor),
                              padding: EdgeInsets.only(
                                  left: 12, right: 12, bottom: 1, top: 1),
                              // 升级订单
                              child: Text(
                                Translations.of(context)
                                    .text('mining_hashrateOrder_upgrade_order'),
                                style: TextStyle(fontSize: 12),
                              )),
                        ),
                      if (_data.locking == 1)
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color(0xffaaaaaa)),
                            padding: EdgeInsets.only(
                                left: 12, right: 12, bottom: 1, top: 1),
                            // 锁定
                            child: Text(
                              Translations.of(context)
                                  .text('mining_lock_cycle_time2'),
                              style: TextStyle(fontSize: 12),
                            ))
                      else if (_data.ransomLimitFlag == 1)
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Theme.of(context).accentColor),
                            padding: EdgeInsets.only(
                                left: 12, right: 12, bottom: 1, top: 1),
                            // 锁定期
                            child: Text(
                              Translations.of(context)
                                  .text('mining_lock_cycle_time'),
                              style: TextStyle(fontSize: 12),
                            ))
                      else if (_data.state == 3 && _data.goodsType == 'rent')
                        GestureDetector(
                          onTap: () {
                            // bloc.handleOrderItemChange.add(MiningOrderHandle(
                            //     type: 'redeem',
                            //     id: data.ordersVo.rows[index].id));
                            bloc.handleUserRedeem(context, index: index);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Theme.of(context).accentColor),
                              padding: EdgeInsets.only(
                                  left: 12, right: 12, bottom: 1, top: 1),
                              // 赎回
                              child: Text(
                                Translations.of(context)
                                    .text('mining_hashrateOrder_redeem'),
                                style: TextStyle(fontSize: 12),
                              )),
                        )
                      else if (_data.state == 5 && _data.goodsType == 'rent')
                        GestureDetector(
                          onTap: () {
                            // bloc.handleOrderItemChange.add(MiningOrderHandle(
                            //     type: 'redeem',
                            //     id: data.ordersVo.rows[index].id));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xffaaaaaa)),
                              padding: EdgeInsets.only(
                                  left: 12, right: 12, bottom: 1, top: 1),
                              // 已赎回
                              child: Text(
                                Translations.of(context)
                                    .text('mining_hashrateOrder_retired'),
                                style: TextStyle(fontSize: 12),
                              )),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 4,
                      ),
                      // 订单编号：
                      Text(
                        '${Translations.of(context).text('mining_hashrateOrder_id')}：${_data.orderCode}',
                        style: _listitem,
                      ),
                      // 下单时间
                      Text(
                        '${Translations.of(context).text('mining_hashrateOrder_time')}：${_data.orderTime}',
                        style: _listitem,
                      ),
                      // 下单份数
                      Text(
                        '${Translations.of(context).text('mining_hashrateOrder_stock')}：${_data.num}',
                        style: _listitem,
                      ),
                      // 算力合计

                      if (_data.judge)
                        Text(
                          '${Translations.of(context).text('mining_hashrateOrder_total')}：${_data.totalHashrate} TH/s',
                          style: _listitem,
                        ),
                      // 订单总额
                      Text(
                        '${Translations.of(context).text('mining_hashrateOrder_totalPrice')}：${NumberFormat.formatDoubel(_data.amount)} ${_data.amountUnit}',
                        style: _listitem,
                      ),
                      if ((_data.amountUnit != null &&
                              _data.amountUnit.toLowerCase() == 'fm') ||
                          _data.profitCoinAmount != null)
                        RichText(
                          // 当时价值
                          text: TextSpan(
                              text:
                                  '${Translations.of(context).text('mining_hashrateOrder_nowtotalPrice')}：',
                              style: _listitem,
                              children: [
                                if (_data.amountUnit.toLowerCase() == 'fm')
                                  TextSpan(
                                      text:
                                          '≈ ${NumberFormat.formatDoubel(_data.price)} USDT',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor))
                                else if (_data.profitCoinAmount != null)
                                  TextSpan(
                                      text:
                                          '≈ ${NumberFormat.formatDoubel(_data.profitCoinAmount)} ${_data.coinName != null ? _data.coinName.toUpperCase() : ''}',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor))
                              ]),
                        ),
                      if (_data.couponAmountValue != null)
                        // 优惠金额
                        RichText(
                          text: TextSpan(
                              text:
                                  '${Translations.of(context).text('mining_discounts_price')}：',
                              style: _listitem,
                              children: [
                                TextSpan(
                                    text: '${_data.couponAmountValue}',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor))
                              ]),
                        ),
                      RichText(
                        // 实付金额
                        text: TextSpan(
                            text:
                                '${Translations.of(context).text('mining_actually_pay_price')}${_data.payType != null ? _data.payType.toUpperCase() : ''}：',
                            style: _listitem,
                            children: [
                              TextSpan(
                                  text:
                                      '${_data.beforePayAmount != null ? '${_data.beforePayAmount} ' : ''}${NumberFormat.formatDoubel(_data.payAmount)} ${_data.payType2 != null ? _data.payType.toUpperCase() : ''}',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor))
                            ]),
                      ),
                      if (_data.payAmount2 != 0)
                        RichText(
                          // 实付金额
                          text: TextSpan(
                              text:
                                  '${Translations.of(context).text('mining_actually_pay_price')}${_data.payType2 != null ? _data.payType2.toUpperCase() : ''}：',
                              style: _listitem,
                              children: [
                                TextSpan(
                                    text:
                                        '≈ ${NumberFormat.formatDoubel(_data.payAmount2)} ${_data.payType2 != null ? _data.payType2.toUpperCase() : ''}',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor))
                              ]),
                        ),
                      if (_data.state > 1 && _data.startTime != null)
                        // 开挖时间
                        Text(
                          '${Translations.of(context).text('mining_hashrateOrder_starttime')}：${_data.startTime}',
                          style: _listitem,
                        ),
                      if (_data.couponAmount != 0 &&
                          _data.ransomLimitDate != null &&
                          _data.state != 5)
                        // 锁定截止
                        Text(
                          '${Translations.of(context).text('mining_lock_endtime')}：${_data.ransomLimitDate}',
                          style: _listitem,
                        ),
                      if (_data.state == 5)
                        // 锁定截止
                        Text(
                          '${Translations.of(context).text('mining_lock_endtime')}：${_data.endTime}',
                          style: _listitem,
                        ),
                      // 订单状态
                      Text(
                        '${Translations.of(context).text('mining_hashrateOrder_status')}：${_data.stateStr}',
                        style: _listitem,
                      ),
                    ],
                  ),
                ),
                if (_data.state > 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      // 累计挖得
                      Text(
                        Translations.of(context)
                            .text('mining_accumulativeTotalObtain'),
                        style:
                            TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
                      ),
                      Text(
                        '${(_data.totalMiningAmount).toStringAsFixed(8)} ${_data.coinName.toUpperCase()}',
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // 累计激励
                      Text(
                        "${Translations.of(context).text('mining_accumulativeTotalStimulate')} ",
                        style:
                            TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
                      ),
                      Text(
                        '${(_data.totalRewardAmount).toStringAsFixed(8)} FM',
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // 月化收益约
                      if (_data.rentIncomeRate != null)
                        Text(
                          Translations.of(context)
                              .text('mining_hashrateOrder_onTheEarnings'),
                          style:
                              TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
                        ),
                      if (_data.rentIncomeRate != null)
                        Text(
                          '${_data.rentIncomeRate != null ? _data.rentIncomeRate : 0}%',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 13),
                        ),
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MiningBloc _miningBloc = MiningProvider.of(context).bloc;

    /// 滚动监听
    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _miningBloc.handleChangePageSize.add('a');
      }
    });

    return StreamBuilder(
      stream: _miningBloc.handleChangeData,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: Text(''),
          );
        }
        String selected = _miningBloc.selectType;
        MiningData _data = snapshot.data;
        int _itemCount = 0;

        if (selected == 'goods' && _data.goods != null) {
          _itemCount = _data.goods.length;
        } else if (selected == 'settlementBooks' &&
            _data.settlementBooksVo != null) {
          _itemCount = _data.settlementBooksVo.rows == null
              ? 0
              : _data.settlementBooksVo.rows.length;
        } else if (selected == 'payBooks' && _data.payBooksVo != null) {
          _itemCount =
              _data.payBooksVo.rows == null ? 0 : _data.payBooksVo.rows.length;
        } else if (selected == 'orders' && _data.ordersVo != null) {
          _itemCount =
              _data.ordersVo.rows == null ? 0 : _data.ordersVo.rows.length;
        }

        bool isnodata = false;
        if (_itemCount == 0) {
          isnodata = true;
        }
        _itemCount += 2;

        return SmartRefresher(
            controller: _miningBloc.refreshcontroller,
            enablePullUp: false,
            header: GifLoading(),
            onRefresh: _miningBloc.refreshData,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return MiningHeader();
                }
                if (isnodata && index == 1) {
                  return PageNoData();
                } else if (!isnodata && index == 1) {
                  return Container(
                    child: null,
                  );
                }
                if (selected == 'goods') {
                  return _miningGoodsItem(context, index - 2, _data);
                } else if (selected == 'settlementBooks') {
                  return _miningSettlementBooksItem(context, index - 2, _data);
                } else if (selected == 'payBooks') {
                  return _miningPayBooksItem(context, index - 2, _data);
                } else if (selected == 'orders') {
                  return _miningOrdersItem(
                      context, index - 2, _data, _miningBloc);
                } else {
                  return Container();
                }
              },
              itemCount: _itemCount,
            )

//          CustomScrollView(
//            controller: _scrollController,
//            slivers: <Widget>[
//              SliverToBoxAdapter(
//                child: MiningHeader(),
//              ),
//              SliverFixedExtentList(
//                delegate: SliverChildBuilderDelegate(
//                    (BuildContext context, int index) {
//                  if (isnodata) {
//                    return PageNoData();
//                  }
//                  if (selected == 'goods') {
//                    return _miningGoodsItem(context, index, _data);
//                  } else if (selected == 'settlementBooks') {
//                    return _miningSettlementBooksItem(context, index, _data);
//                  } else if (selected == 'payBooks') {
//                    return _miningPayBooksItem(context, index, _data);
//                  } else if (selected == 'orders') {
//                    return _miningOrdersItem(
//                        context, index, _data, _miningBloc);
//                  } else {
//                    return Container();
//                  }
//                }, childCount: isnodata ? 1 : _itemCount),
//                itemExtent: _height,
//              )
//            ],
//          ),
            );
      },
    );
  }
}

/// 头部信息
class MiningHeader extends StatefulWidget {
  @override
  _MiningHeaderState createState() => _MiningHeaderState();
}

class _MiningHeaderState extends State<MiningHeader> {
  bool showtip = false;

  @override
  Widget build(BuildContext context) {
    MiningBloc _miningBlog = MiningProvider.of(context).bloc;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Color(0xff171D2A),
          // color: Colors.red,
          image: DecorationImage(
              alignment: Alignment.center,
              image: AssetImage('assets/images/mining_header_bg.png'),
              fit: BoxFit.contain)),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  height: 110,
                  child: Stack(children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: <Widget>[
                              // 我的算力估值
                              Text(
                                  '${Translations.of(context).text('mining_title_h1')}(USDT)'),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showtip = true;
                                  });
                                  Future.delayed(Duration(seconds: 2), () {
                                    setState(() {
                                      showtip = false;
                                    });
                                  });
                                },
                                child: Icon(
                                  Icons.error_outline,
                                  size: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          '${_miningBlog.acitem != null ? _miningBlog.acitem.hashRateValuation : ''}',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 30),
                        )
                      ],
                    ),
                    if (showtip)
                      Positioned(
                        top: 5,
                        left: 0,
                        right: 0,
                        height: 20,
                        child: Container(
                          alignment: Alignment.center,
                          // 在挖矿订单价值≈我的算力估值
                          child: Text(
                              Translations.of(context)
                                  .text('mining_title_desc'),
                              style: TextStyle(
                                  color: Color(0xffaaaaaa), fontSize: 12)),
                        ),
                      )
                  ]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/navigator', (route) => false,
                      arguments: 1);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 120,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                          colors: [
                            Color(0xFFffbb42),
                            Color(0xFFec7223),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  // 扩容算力
                  child: Text(
                    Translations.of(context).text('mining_addMyBtc'),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 90,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
            // alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // 累计激励：
                        Text(
                          '${Translations.of(context).text('mining_accumulativeTotalStimulate')}：',
                          style: TextStyle(color: Color(0xffaaaaaa)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '${_miningBlog.acitem != null ? _miningBlog.acitem.totalRewardAmount : ''}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text('FM'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 35),
                  color: Color(0xff535A70),
                  width: 1.0,
                  height: 50.0,
                  child: null,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // 累计挖得
                        Text(
                          '${Translations.of(context).text('mining_accumulativeTotalObtain')}：',
                          style: TextStyle(color: Color(0xffaaaaaa)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '${_miningBlog.acitem != null ? _miningBlog.acitem.totalMiningAmount : ''}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text('BTC'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            color: Color(0xff232836),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _miningBlog.miningSelectList
                  .map((item) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _miningBlog.handleChangType.add(item.index);
                          },
                          child: Container(
                            color: Color(0xff232836),
                            child: Column(
                              children: <Widget>[
                                if (item.active)
                                  Image.asset(
                                    '${item.imgon}',
                                    width: 25,
                                  )
                                else
                                  Image.asset(
                                    '${item.img}',
                                    width: 25,
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${item.title}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: item.active
                                          ? Color(0xFFffbb42)
                                          : Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

/// 算力包
class MiningGoodsItem extends StatelessWidget {
  final int index;

  MiningGoodsItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
