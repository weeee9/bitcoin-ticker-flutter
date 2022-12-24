import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinapiHost = "rest.coinapi.io";

class CoinData {
  CoinData();

  Future getCoinData(String selectedCurrency) async {
    var priceMap = <String, double>{};

    for (String crypto in cryptoList) {
      String bitcoinExchangeRate = "v1/exchangerate/$crypto/$selectedCurrency";

    var uri = Uri.https(coinapiHost, bitcoinExchangeRate, {});

    http.Response resp = await http.get(
      uri,
      headers: {
        "X-CoinAPI-Key": "{your_api_key}",
      },
    );

    if (resp.statusCode != 200) {
      print(resp.body);
      throw "failed to do request $resp.body";
    }

    var decodedData = jsonDecode(resp.body);
    double price = decodedData["rate"];

      priceMap[crypto] = price;
    }

    return priceMap;
  }
}
