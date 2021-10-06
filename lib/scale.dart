import 'package:flutter/cupertino.dart';

class MaxScaleTextWidget extends StatelessWidget {
  final double max;
  final Widget child;

  const MaxScaleTextWidget({
    Key key,
    this.max = 1.2,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    // var scale = math.min(max, data.textScaleFactor);
    return MediaQuery(
      data: data.copyWith(textScaleFactor: 0.9),
      child: child,
    );
  }
}
