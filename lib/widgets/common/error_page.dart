import 'package:flutter/material.dart';
import '../../utils/dimens.dart';

class ErrorPage extends StatelessWidget {
  final String error;

  ErrorPage(this.error, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          error,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
        ),
      ),
    );
  }
}
