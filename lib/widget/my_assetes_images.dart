import 'package:flutter/material.dart';

class MyAssetsImage extends StatelessWidget {
  final String assetsUrl;
  final double width;
  final double height;

  MyAssetsImage({Key key, this.width, this.assetsUrl,this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return assetsUrl.isNotEmpty
        ? Image.asset(assetsUrl, width: width)
        : Container();
  }
}
