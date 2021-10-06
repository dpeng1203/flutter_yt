class CoinTypes {
  String value;
  double balance;
  String name;
  String png;
  String shotName;
  bool checked;
  List<String> includeCoinTypes;
  CoinTypes(
      {this.balance,
      this.name,
      this.png,
      this.shotName,
      this.checked,
      this.includeCoinTypes,
      this.value});
}

final List<CoinTypes> cointypelistmodel = [
  CoinTypes(
    value: 'usdt',
    balance: 0,
    name: 'USDT (ERC20)',
    png: '../../static/images/icon_usdt.png',
    shotName: 'USDT',
    checked: false,
    includeCoinTypes: ['btc'],
  ),
  CoinTypes(
    value: 'btc',
    balance: 0,
    name: 'BTC',
    png: '../../static/images/icon_btc.png',
    includeCoinTypes: ['btc'],
    checked: false,
  ),
  CoinTypes(
      value: 'fm',
      balance: 0,
      name: 'FM ',
      png: '../../static/images/icon_fm.png',
      checked: false,
      includeCoinTypes: [
        'btc',
        'cxc',
        'eth',
        'etc',
        'ltc',
        'bch',
        'eos',
        'xrp',
        'brc',
        'fm'
      ]),
  CoinTypes(
      value: 'cxc',
      balance: 0,
      name: 'CXC ',
      png: '../../static/images/icon_cxc.png',
      checked: false,
      includeCoinTypes: ['cxc']),
  CoinTypes(
      value: 'bch',
      balance: 0,
      name: 'BCH ',
      png: '../../static/images/icon_bch.png',
      checked: false,
      includeCoinTypes: ['bch']),
  CoinTypes(
      value: 'eth',
      balance: 0,
      name: 'ETH ',
      png: '../../static/images/icon_eth.png',
      checked: false,
      includeCoinTypes: ['eth']),
  CoinTypes(
      value: 'etc',
      balance: 0,
      name: 'ETC ',
      png: '../../static/images/icon_etc.png',
      checked: false,
      includeCoinTypes: ['etc']),
  CoinTypes(
      value: 'ltc',
      balance: 0,
      name: 'LTC ',
      png: '../../static/images/icon_ltc.png',
      checked: false,
      includeCoinTypes: ['ltc']),
  CoinTypes(
      value: 'eos',
      balance: 0,
      name: 'EOS ',
      png: '../../static/images/icon_eos.png',
      checked: false,
      includeCoinTypes: ['eos']),
  CoinTypes(
      value: 'xrp',
      balance: 0,
      name: 'XRP ',
      png: '../../static/images/icon_xrp.png',
      checked: false,
      includeCoinTypes: ['xrp']),
  CoinTypes(
      value: 'brc',
      balance: 0,
      name: 'BRC ',
      png: '../../static/images/icon_brc.png',
      checked: false,
      includeCoinTypes: ['brc']),
];
