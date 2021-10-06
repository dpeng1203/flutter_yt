final coinPngs = {
  'btc': 'assets/images/icon_btc.png',
  'fm': 'assets/images/icon_fm.png',
  'usdt': 'assets/images/icon_usdt.png',
  'rent': 'assets/images/index_rent_icon.png',
  'cxc': 'assets/images/icon_cxc.png',
  'eth': 'assets/images/icon_eth.png',
  'etc': 'assets/images/icon_etc.png',
  'ltc': 'assets/images/icon_ltc.png',
  'bch': 'assets/images/icon_bch.png',
  'xrp': 'assets/images/icon_xrp.png',
  'eos': 'assets/images/icon_eos.png',
  'brc': 'assets/images/icon_brc.png',
  'exchange_otc': 'assets/images/icon-assets-change-otc.png'
};

final coinTypes = [
  {
    "value": 'usdt',
    "balance": 0,
    "name": 'USDT (ERC20)',
    "shotName": 'USDT',
    "checked": false,
    "includeCoinTypes": ['btc'],
  },
  {
    "value": 'btc',
    "balance": 0,
    "name": 'BTC',
    "includeCoinTypes": ['btc'],
    "checked": false,
  },
  {
    "value": 'fm',
    "balance": 0,
    "name": 'FM ',
    "checked": false,
    "includeCoinTypes": [
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
    ]
  },
  {
    "value": 'cxc',
    "balance": 0,
    "name": 'CXC ',
    "checked": false,
    "includeCoinTypes": ['cxc']
  },
  {
    "value": 'bch',
    "balance": 0,
    "name": 'BCH ',
    "checked": false,
    "includeCoinTypes": ['bch']
  },
  {
    "value": 'eth',
    "balance": 0,
    "name": 'ETH ',
    "checked": false,
    "includeCoinTypes": ['eth']
  },
  {
    "value": 'etc',
    "balance": 0,
    "name": 'ETC ',
    "checked": false,
    "includeCoinTypes": ['etc']
  },
  {
    "value": 'ltc',
    "balance": 0,
    "name": 'LTC ',
    "checked": false,
    "includeCoinTypes": ['ltc']
  },
  {
    "value": 'eos',
    "balance": 0,
    "name": 'EOS ',
    "checked": false,
    "includeCoinTypes": ['eos']
  },
  {
    "value": 'xrp',
    "balance": 0,
    "name": 'XRP ',
    "checked": false,
    "includeCoinTypes": ['xrp']
  },
  {
    "value": 'brc',
    "balance": 0,
    "name": 'BRC ',
    "checked": false,
    "includeCoinTypes": ['brc']
  },
];
