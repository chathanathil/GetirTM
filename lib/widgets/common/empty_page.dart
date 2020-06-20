import 'package:flutter/material.dart';
import '../../utils/dimens.dart';

class EmptyPage extends StatelessWidget {
  final String title;
  final String message;
  final bool show;
  final VoidCallback onTap;

  EmptyPage(
      {Key key,
      this.title: "Tapylmady",
      this.message,
      this.show: false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/empty.png'),
              height: 100,
              width: 100,
            ),
            Text(
              title,
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              message,
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              textAlign: TextAlign.center,
            ),
            (show)
                ? RaisedButton(
                    child: Text("Retry"),
                    onPressed: this.onTap,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
