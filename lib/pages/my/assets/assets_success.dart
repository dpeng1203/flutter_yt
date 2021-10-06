import 'package:flutter/material.dart';
import 'package:flutter_app_yt/widget/top_back_icon.dart';

import '../../../translations.dart';

class AssetsSuccessPage extends StatelessWidget {
  final String type;

  AssetsSuccessPage({this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //type == 'transfer'? '转账':'提币'
        title: Text(type == 'transfer'
            ? Translations.of(context).text('title_transfer-accounts')
            : Translations.of(context).text('title_assets-coin-out')),
        centerTitle: true,
        leading: TopBackIcon(),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon-payment-result.png',
              width: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              Translations.of(context).text('assets_out_succeedInfo'),
              style: TextStyle(fontSize: 18, color: Color(0xffAAAAAA)),
            ),
            SizedBox(
              height: 50,
            ),
            type == 'transfer'
                ? Text('')
                : Text(
                    Translations.of(context)
                        .text('component_paymentresult_coinOut'),
                    textAlign: TextAlign.center,
                  ),
            SizedBox(
              height: 100,
            ),
            Container(
              height: 50,
//              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              width: 200,
              child: OutlineButton(
                child:
                    Text(Translations.of(context).text('assets_out_iviewBill')),
                textColor: Colors.white,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                borderSide: BorderSide(color: Colors.white, width: 1),
                onPressed: () {
//                  _onLogin();
                  Navigator.pushNamed(context, '/bills');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
