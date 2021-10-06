import 'package:flutter/material.dart';
import '../translations.dart';

class PageNoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Image.asset(
            'assets/images/coupon_no_data.png',
            width: 100,
          ),
          Text(
            Translations.of(context).text('nodata'),
            style: TextStyle(color: Color(0xffaaaaaa)),
          ),
        ],
      ),
    );
  }
}
