import 'package:flutter/widgets.dart';
import 'package:flutter_app_yt/widget/refresh_gifimage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;

class GifLoading extends RefreshIndicator {
  GifLoading() : super(height: 80.0, refreshStyle: RefreshStyle.UnFollow);
  @override
  _GifLoadingState createState() => _GifLoadingState();
}

class _GifLoadingState extends RefreshIndicatorState<GifLoading>
    with SingleTickerProviderStateMixin {
  GifController _gifController;

  @override
  void initState() {
    _gifController = GifController(
      vsync: this,
      value: 10,
    );
    super.initState();
  }

  @override
  void onModeChange(RefreshStatus mode) {
    if (mode == RefreshStatus.refreshing || mode == RefreshStatus.canRefresh) {
      _gifController.repeat(
          min: 10, max: 49, period: Duration(milliseconds: 1000));
    }
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    _gifController.value = 10;
    return _gifController.animateTo(49, duration: Duration(milliseconds: 1000));
  }

  @override
  void resetValue() {
    // reset not ok , the plugin need to update lowwer
    _gifController.value = 10;
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return GifImage(
      image: AssetImage("assets/images/loading.gif"),
      controller: _gifController,
      height: 80.0,
      width: 80.0,
    );
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }
}

// class GifHeader1 extends RefreshIndicator {
//   GifHeader1() : super(height: 80.0, refreshStyle: RefreshStyle.UnFollow);
//   @override
//   State<StatefulWidget> createState() {
//     return GifHeader1State();
//   }
// }

// class GifHeader1State extends RefreshIndicatorState<GifHeader1>
//     with SingleTickerProviderStateMixin {
//   GifController _gifController;

//   @override
//   void initState() {
//     _gifController = GifController(
//       vsync: this,
//       value: 10,
//     );
//     super.initState();
//   }

//   @override
//   void onModeChange(RefreshStatus mode) {
//     if (mode == RefreshStatus.refreshing || mode == RefreshStatus.canRefresh) {
//       _gifController.repeat(
//           min: 10, max: 30, period: Duration(milliseconds: 1000));
//     }
//     super.onModeChange(mode);
//   }

//   @override
//   Future<void> endRefresh() {
//     _gifController.value = 30;
//     return _gifController.animateTo(30, duration: Duration(milliseconds: 500));
//   }

//   @override
//   void resetValue() {
//     // reset not ok , the plugin need to update lowwer
//     _gifController.value = 10;
//     super.resetValue();
//   }

//   @override
//   Widget buildContent(BuildContext context, RefreshStatus mode) {
//     return GifImage(
//       image: AssetImage("assets/images/loading.gif"),
//       controller: _gifController,
//       height: 80.0,
//       width: 80.0,
//     );
//   }

//   @override
//   void dispose() {
//     _gifController.dispose();
//     super.dispose();
//   }
// }
