import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/verify/verify_form.dart';

class VerifyPage extends StatelessWidget {
  static const routeName = 'verify';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).verifyPage_title,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: new IconButton(
          padding: EdgeInsets.only(right: 20),
          icon: new Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: false).pop(null);
          },
        ),
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: VerifyForm()),
    );
  }
}
