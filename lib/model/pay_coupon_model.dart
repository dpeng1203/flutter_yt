class ModelPayCoupon {
  num availableCouponNum;
  num availableCouponNum2;
  num selectedCouponCount;
  num selectedCouponCount2;
  num originalAmount;
  num originalAmount2;
  String selectedCouponSumValue;
  String selectedCouponSumValue2;
  String payAmount;
  String payAmount2;
  String payType;
  String payType2;
  List<ModelCouponItem> selectedCoupon;
  List<ModelCouponItem> selectedCoupon2;

  ModelPayCoupon(
      {this.availableCouponNum,
      this.availableCouponNum2,
      this.selectedCouponCount,
      this.selectedCouponCount2,
      this.selectedCouponSumValue,
      this.selectedCouponSumValue2,
      this.payAmount,
      this.payAmount2,
      this.payType,
      this.payType2,
      this.originalAmount,
      this.originalAmount2,
      this.selectedCoupon,
      this.selectedCoupon2});

  ModelPayCoupon.fromJson(Map<String, dynamic> json) {
    availableCouponNum = json['availableCouponNum'];
    availableCouponNum2 = json['availableCouponNum2'];
    selectedCouponCount = json['selectedCouponCount'];
    selectedCouponCount2 = json['selectedCouponCount2'];
    selectedCouponSumValue = json['selectedCouponSumValue'];
    selectedCouponSumValue2 = json['selectedCouponSumValue2'];
    payAmount = json['payAmount'];
    payAmount2 = json['payAmount2'];
    payType = json['payType'];
    payType2 = json['payType2'];
    originalAmount = json['originalAmount'];
    originalAmount2 = json['originalAmount2'];

    if (json['selectedCoupon'] != null) {
      selectedCoupon = new List<ModelCouponItem>();
      json['selectedCoupon'].forEach((v) {
        selectedCoupon.add(new ModelCouponItem.fromJson(v));
      });
    }

    if (json['selectedCoupon2'] != null) {
      selectedCoupon2 = new List<ModelCouponItem>();
      json['selectedCoupon2'].forEach((v) {
        selectedCoupon2.add(new ModelCouponItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableCouponNum'] = this.availableCouponNum;
    data['availableCouponNum2'] = this.availableCouponNum2;
    data['selectedCouponCount'] = this.selectedCouponCount;
    data['selectedCouponCount2'] = this.selectedCouponCount2;
    data['selectedCouponSumValue'] = this.selectedCouponSumValue;
    data['selectedCouponSumValue2'] = this.selectedCouponSumValue2;
    data['payAmount'] = this.payAmount;
    data['payAmount2'] = this.payAmount2;
    data['payType'] = this.payType;
    data['payType2'] = this.payType2;
    data['originalAmount'] = this.originalAmount;
    data['originalAmount2'] = this.originalAmount2;
    if (this.selectedCoupon != null) {
      data['selectedCoupon'] =
          this.selectedCoupon.map((v) => v.toJson()).toList();
    }
    if (this.selectedCoupon2 != null) {
      data['selectedCoupon2'] =
          this.selectedCoupon2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelCouponItem {
  int id;
  String name;
  int type;
  String typeName;
  double value;
  String unit;
  String startTime;
  String endTime;
  String createTime;
  String ruleContent;
  int state;
  int currentState;

  ModelCouponItem(
      {this.id,
      this.name,
      this.type,
      this.typeName,
      this.value,
      this.unit,
      this.startTime,
      this.endTime,
      this.createTime,
      this.ruleContent,
      this.state,
      this.currentState});

  ModelCouponItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    typeName = json['typeName'];
    value = json['value'];
    unit = json['unit'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    createTime = json['createTime'];
    ruleContent = json['ruleContent'];
    state = json['state'];
    currentState = json['currentState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['typeName'] = this.typeName;
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['createTime'] = this.createTime;
    data['ruleContent'] = this.ruleContent;
    data['state'] = this.state;
    data['currentState'] = this.currentState;
    return data;
  }
}

class ModelSelectCoupon {
  int selectedCount;
  int remainingCount;
  String couponAmount;
  ModelSelectCouponPage couponPage;

  ModelSelectCoupon(
      {this.selectedCount,
      this.remainingCount,
      this.couponAmount,
      this.couponPage});

  ModelSelectCoupon.fromJson(Map<String, dynamic> json) {
    selectedCount = json['selectedCount'];
    remainingCount = json['remainingCount'];
    couponAmount = json['couponAmount'];
    couponPage = json['couponPage'] != null
        ? new ModelSelectCouponPage.fromJson(json['couponPage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedCount'] = this.selectedCount;
    data['remainingCount'] = this.remainingCount;
    data['couponAmount'] = this.couponAmount;
    if (this.couponPage != null) {
      data['couponPage'] = this.couponPage.toJson();
    }
    return data;
  }
}

class ModelSelectCouponPage {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<ModelSelectCouponPageRowsItem> rows;

  ModelSelectCouponPage(
      {this.pageIndex,
      this.pageSize,
      this.total,
      this.pageCount,
      this.firstItemIndex,
      this.rows});

  ModelSelectCouponPage.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    total = json['total'];
    pageCount = json['pageCount'];
    firstItemIndex = json['firstItemIndex'];
    if (json['rows'] != null) {
      rows = new List<ModelSelectCouponPageRowsItem>();
      json['rows'].forEach((v) {
        rows.add(new ModelSelectCouponPageRowsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['total'] = this.total;
    data['pageCount'] = this.pageCount;
    data['firstItemIndex'] = this.firstItemIndex;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelSelectCouponPageRowsItem {
  int id;
  String name;
  int type;
  String typeName;
  double value;
  String unit;
  String startTime;
  String endTime;
  int currentState;

  ModelSelectCouponPageRowsItem(
      {this.id,
      this.name,
      this.type,
      this.typeName,
      this.value,
      this.unit,
      this.startTime,
      this.endTime,
      this.currentState});

  ModelSelectCouponPageRowsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    typeName = json['typeName'];
    value = json['value'];
    unit = json['unit'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    currentState = json['currentState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['typeName'] = this.typeName;
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['currentState'] = this.currentState;
    return data;
  }
}

class CouponData {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<CouponDataItem> rows;

  CouponData(
      {this.pageIndex,
      this.pageSize,
      this.total,
      this.pageCount,
      this.firstItemIndex,
      this.rows});

  CouponData.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    total = json['total'];
    pageCount = json['pageCount'];
    firstItemIndex = json['firstItemIndex'];
    if (json['rows'] != null) {
      rows = new List<CouponDataItem>();
      json['rows'].forEach((v) {
        rows.add(new CouponDataItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['total'] = this.total;
    data['pageCount'] = this.pageCount;
    data['firstItemIndex'] = this.firstItemIndex;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponDataItem {
  int id;
  String name;
  num type;
  String typeName;
  num value;
  String unit;
  String startTime;
  String endTime;
  String createTime;
  String ruleContent;
  num state;
  String stateName;
  num tagState;
  bool ischange;

  CouponDataItem(
      {this.id,
      this.name,
      this.type,
      this.typeName,
      this.value,
      this.unit,
      this.startTime,
      this.endTime,
      this.createTime,
      this.ruleContent,
      this.state,
      this.stateName,
      this.ischange = false,
      this.tagState});

  CouponDataItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    typeName = json['typeName'];
    value = json['value'];
    unit = json['unit'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    createTime = json['createTime'];
    ruleContent = json['ruleContent'];
    state = json['state'];
    stateName = json['stateName'];
    ischange = json['ischange'];
    tagState = json['tagState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['typeName'] = this.typeName;
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['createTime'] = this.createTime;
    data['ruleContent'] = this.ruleContent;
    data['state'] = this.state;
    data['stateName'] = this.stateName;
    data['ischange'] = this.ischange;
    data['tagState'] = this.tagState;
    return data;
  }
}
