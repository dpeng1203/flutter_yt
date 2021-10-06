import 'package:flutter/material.dart';
import 'package:flutter_app_yt/pages/bills.dart';
import 'package:flutter_app_yt/pages/coupon_page.dart';
import 'package:flutter_app_yt/pages/find-new-list.dart';
import 'package:flutter_app_yt/pages/goods/paysuccess.dart';
import 'package:flutter_app_yt/pages/index-pic.dart';
import 'package:flutter_app_yt/pages/login/find_password_page.dart';
import 'package:flutter_app_yt/pages/login/register_deal.dart';
import 'package:flutter_app_yt/pages/login/register_page.dart';
import 'package:flutter_app_yt/pages/my/assets/assets.dart';
import 'package:flutter_app_yt/pages/my/assets/assets_coin_in.dart';
import 'package:flutter_app_yt/pages/my/assets/assets_coin_out.dart';
import 'package:flutter_app_yt/pages/my/assets/assets_coin_transfer.dart';
import 'package:flutter_app_yt/pages/my/assets/assets_set.dart';
import 'package:flutter_app_yt/pages/my/assets/assets_success.dart';
import 'package:flutter_app_yt/pages/my/invitte-code/my_invitte_page.dart';
import 'package:flutter_app_yt/pages/my/wallet-address/add_wallet_address.dart';
import 'package:flutter_app_yt/pages/my/wallet-address/my_wallet_address.dart';
import 'package:flutter_app_yt/pages/notice.dart';
import 'package:flutter_app_yt/pages/notice_detial.dart';
import 'package:flutter_app_yt/pages/goods/pay.dart';
import 'package:flutter_app_yt/pages/otcView.dart';
import '../pages/my/change-language/switch-language.dart';
import '../pages/my/security-center/my_security_cert_page.dart';
import '../pages/my/security-center/my_modify_password_page.dart';
import '../pages/my/security-center/my_security_page.dart';
import '../pages/my/question-list/my_work_order_page.dart';
import '../pages/my/question-list/my_work_order_submit_page.dart';
import '../navigator/tab_navigator.dart';
import '../pages/webview.dart';
import '../pages/login/login_page.dart';
import '../pages/my/question-list/my_question_page.dart';
import '../pages/goods/detail.dart';
import '../pages/mining/index.dart';

final routes = {
  '/login': (context) => LoginPage(),
  '/register': (context) => RegisterPage(),
  '/register-deal': (context) => RegisterDealPage(),
  '/find-password': (context) => FindPasswordPage(),
  '/navigator': (context, {arguments}) => TabNavigator(index: arguments),
  '/find': (context, {arguments}) => WebViewPage(router: arguments),
  '/notice': (context) => NoticePage(),
  '/notice-detail': (context, {arguments}) => NoticeDetailPage(id: arguments),
  '/index-pic': (context, {arguments}) => IndexPicPage(id: arguments),
  '/my-question': (context) => MyQuestionPage(),
  '/my-work-order': (context) => MyWorkOrderPage(),
  '/my-work-order-submit': (context) => MyWorkOrderSubmitPage(),
  '/goods-detail': (context, {arguments}) => GoodsDetail(params: arguments),
  '/goods-pay': (context, {arguments}) => GoodsOrderPay(goodsCode: arguments),
  '/paysuccess': (context, {arguments}) => PaySuccess(title: arguments),
  '/otc-view': (context) => OtcView(),
  '/mining': (context) => MiningPage(),
  '/bills': (context) => BillsPage(),
  '/coupon': (context) => CouponPage(),
  '/switch-language': (context) => SwitchLanguage(),
  '/my-security': (context) => MySecurityPage(),
  '/my-security-modify-password': (context, {arguments}) =>
      MyModifyPasswordPage(type: arguments),
  '/my-security-cert': (context) => MySecurityCertPage(),
  '/my-invitte': (context) => MyInvittePage(),
  '/assets': (context) => AssetsPage(),
  '/assets-set': (context) => AssetsSetPage(),
  '/wallet-address': (context) => MyWalletAddressPage(),
  '/add-wallet-address': (context, {arguments}) =>
      MyAddWalletAddressPage(pageTitle: arguments),
  '/assets-coin-out': (context) => AssetsCoinOutPage(),
  '/assets-coin-in': (context) => AssetsCoinInPage(),
  '/assets-coin-transfer': (context) => AssetsCoinTransferPage(),
  '/assets-success': (context, {arguments}) =>
      AssetsSuccessPage(type: arguments),
  '/find-new-list': (context) => FindNewList(), // FindNewList 新闻快讯
};

//固定写法
// ignore: missing_return, top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
