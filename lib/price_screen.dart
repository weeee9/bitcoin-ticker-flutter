import 'dart:ffi';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedValue = "AUD";
  String price = "?";

  DropdownButton<String> androidDropdownButton() {
    return DropdownButton<String>(
      value: selectedValue,
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
          selectedValue = value;
        });
        getData(value);
      },
    );
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        String selectedCurrency = currenciesList[selectedIndex];
        setState(() {
          selectedValue = selectedCurrency;
        });
        getData(selectedCurrency);
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

    return null;
  }

  void getData(String selectedCurrency) async {
    try {
      CoinData coinData = CoinData();
      double data = await coinData.getCoinData(selectedCurrency);

      setState(() {
        price = data.toStringAsPrecision(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData(selectedValue);
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
                  '1 BTC = $price $selectedValue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
