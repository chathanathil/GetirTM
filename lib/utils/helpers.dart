import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Constants {
  static const TERMS = "terms";
  static const ABOUT = "about";
  static const DISCOUNT_CARD = "discount-card";
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

void showMessageDialog(BuildContext context, String message,
    {String title = "Error", String close = "Close"}) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

String getCurrency(num amount, String symbol) {
  var f = new NumberFormat.currency(
    name: 'TMT',
    decimalDigits: 2,
    symbol: "",
    customPattern: "##.## $symbol",
  );
  return "${f.format(amount)}.";
}

String getDateWithFormat(
  num unix, {
  String toFormat = "dd-MM-yyyy HH:mm",
}) {
  var unixDate = new DateTime.fromMillisecondsSinceEpoch(unix * 1000);
  var date = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(unixDate.toString());
  return new DateFormat(toFormat).format(date);
}
