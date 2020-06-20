import 'package:flutter/material.dart';

import '../../utils/utils.dart';
// import 'package:flutter_getir/bloc/discount_card/discount_card.dart';

class DiscountCardAddPage extends StatefulWidget {
  // final DiscountCardBloc bloc;

  const DiscountCardAddPage({Key key}) : super(key: key);

  @override
  _DiscountCardAddPageState createState() => _DiscountCardAddPageState();
}

class _DiscountCardAddPageState extends State<DiscountCardAddPage> {
  final _cardTextController = TextEditingController();

  @override
  void dispose() {
    _cardTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                S.of(context).discount_card_limit,
                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                style: TextStyle(fontSize: 11),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            new TextField(
              controller: _cardTextController,
              maxLength: 16,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(color: Colors.grey[800]),
                hintText: S.of(context).enter_discount_card_number,
                fillColor: Colors.white70,
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                height: 50,
                width: 200,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    if (_cardTextController.text.length < 16) {
                      showMessageDialog(
                          context, S.of(context).discount_card_number_invalid,
                          title: S.of(context).error,
                          close: S.of(context).close);
                    } else {
                      print("Doooooooooooo here");
                      // widget.bloc.add(
                      //   DiscountCardVerify(int.parse(_cardTextController.text)),
                      // );
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Text(
                    S.of(context).verify,
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  color: AppColors.MAIN,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                child: Text(
                  S.of(context).get_discount_card,
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
                onTap: () {
                  NavigatorUtils.goDiscountCardGetPage(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
