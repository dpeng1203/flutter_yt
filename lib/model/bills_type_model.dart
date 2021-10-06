class BillsTypeModel {
  List<CoinType> coinType;
  List<CoinState> coinState;
  List<ChangeType> changeType;

  BillsTypeModel({this.coinType, this.coinState, this.changeType});

  BillsTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['coinType'] != null) {
      coinType = new List<CoinType>();
      json['coinType'].forEach((v) {
        coinType.add(new CoinType.fromJson(v));
      });
    }
    if (json['coinState'] != null) {
      coinState = new List<CoinState>();
      json['coinState'].forEach((v) {
        coinState.add(new CoinState.fromJson(v));
      });
    }
    if (json['changeType'] != null) {
      changeType = new List<ChangeType>();
      json['changeType'].forEach((v) {
        changeType.add(new ChangeType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coinType != null) {
      data['coinType'] = this.coinType.map((v) => v.toJson()).toList();
    }
    if (this.coinState != null) {
      data['coinState'] = this.coinState.map((v) => v.toJson()).toList();
    }
    if (this.changeType != null) {
      data['changeType'] = this.changeType.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoinType {
  String lable;
  String value;

  CoinType({this.lable, this.value});

  CoinType.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lable'] = this.lable;
    data['value'] = this.value;
    return data;
  }
}

class CoinState {
  String lable;
  String value;

  CoinState({this.lable, this.value});

  CoinState.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lable'] = this.lable;
    data['value'] = this.value;
    return data;
  }
}

class ChangeType {
  String lable;
  String value;

  ChangeType({this.lable, this.value});

  ChangeType.fromJson(Map<String, dynamic> json) {
    lable = json['lable'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lable'] = this.lable;
    data['value'] = this.value;
    return data;
  }
}
