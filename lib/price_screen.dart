import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "AUD";
  String bitcoinPrice = "?";
  String ethPrice = "?";
  String ltcPrice = "?";

  DropdownButton<String> androidDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesList.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem(
            child: Text(value),
            value: value,
          );
        },
      ).toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
        getData();
      },
    );
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getData();
      },
      children: currenciesList.map<Text>(
        (String value) {
          return Text(value);
        },
      ).toList(),
    );
  }

  Widget getCurrencyPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    }

    if (Platform.isAndroid) {
      return androidDropdownButton();
    }

    return SizedBox.shrink();
  }

  bool isWaitinng = false;
  void getData(String selectedCurrency) async {
  void getData() async {
    isWaitinng = true;
    try {
      CoinData coinData = CoinData();
      var priceMap = <String, double>{};
      priceMap = await coinData.getCoinData(selectedCurrency);

      isWaitinng = false;

      setState(() {
        bitcoinPrice = priceMap["BTC"]!.toStringAsFixed(0);
        ethPrice = priceMap["ETH"]!.toStringAsFixed(0);
        ltcPrice = priceMap["LTC"]!.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                crypto: "BTC",
                price: isWaitinng ? "?" : bitcoinPrice,
                currency: selectedCurrency,
              ),
              CryptoCard(
                crypto: "ETH",
                price: isWaitinng ? "?" : ethPrice,
                currency: selectedCurrency,
              ),
              CryptoCard(
                crypto: "LTC",
                price: isWaitinng ? "?" : ltcPrice,
                currency: selectedCurrency,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getCurrencyPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  String crypto;
  String price;
  String currency;

  CryptoCard(
      {required this.crypto, required this.price, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $price $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
