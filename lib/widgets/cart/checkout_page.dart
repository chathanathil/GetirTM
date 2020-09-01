import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:getirtm/models/address.dart';
import 'package:getirtm/provider/cart.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

import '../../widgets/common/common.dart';
import '../../widgets/cart/payment_page.dart';
import '../../widgets/profile/address_page.dart';

enum CellType {
  textField,
  plain,
  plusButton,
  TaC,
  radioBtn,
  usePointsRadio,
}

enum Identifier {
  textArea,
  subTotal,
  total,
  delivery,
  balance,
  earnPoints,
  address,
  TaC,
  paymentType,
  usePoints,
}

class CheckoutPage extends StatefulWidget {
  static const routeName = "checkout";

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _termsAndConditions = false;
  bool _usePoints = false;
  TextEditingController _descriptionController = TextEditingController();

  List<ListItem> items = [];
  bool isBackButtonActivated = true;
  num balance = 0.0;
  // int discountPerc = 0;
  num skidka = 0.0;
  Address _address;
  bool _isLoading = false;
  bool _checkoutLoading = false;
  var _paymentType;
  CartProvider prv;
  @override
  void initState() {
    super.initState();
    prv = Provider.of<CartProvider>(context, listen: false);
    skidka = 0.0;

    setState(() {
      _isLoading = true;
    });
    Provider.of<CartProvider>(context, listen: false)
        .fetchPaymentData()
        .then((_) {
      setState(() {
        _isLoading = false;

        balance = prv.paymentData['balance_points'];
        _paymentType = prv.paymentData['payments'][0];
      });
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blue, // navigation bar color
      statusBarColor: Colors.pink, // status bar color
    ));

    // final auth = Provider.of<AuthProvider>(context);
    //     auth.user != null &&
    // if (auth.isAuthenticated &&
    //     auth.user.address != null) {
    //   kartBloc.add(SelectAddress(auth.user.address));
    // }
  }

  void _termsAndConditionsChanged(bool value, {BuildContext context}) {
    setState(() {
      _termsAndConditions = value;
      if (value && context != null) {
        NavigatorUtils.goAboutPage(
          context,
          Constants.TERMS,
          S.of(context).termsPage_title,
        );
      }
    });
  }

  void _usePointChanged(bool value, {BuildContext context}) {
    setState(() {
      _usePoints = value;
      if (value) {
        // if total cost less or equal to balance then just add negative sign else show balance with negative sign
        if (prv.totalWithPoint <= balance) {
          skidka = -(prv.totalWithPoint);
        } else {
          skidka = -balance;
        }
        // if use point true then we calculate total cost with balance
        // Checkhere moretimemaybe balance_points+balance
        prv.paymentData['balance_points'] = balance;
      } else {
        prv.paymentData['balance_points'] = 0.0;
        skidka = 0.0;
      }
    });
  }

  void showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        S.of(context).checkoutPage_close,
        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.of(context).popUntil((r) => r.isFirst);
        // kartBloc.add(CompleteCheckout());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        S.of(context).checkoutPage_success,
        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
      ),
      content: Text(
        message,
        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
      ),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  didPopRoute() {
    bool override;
    if (isBackButtonActivated)
      override = false;
    else
      override = true;
    return new Future<bool>.value(override);
  }

  void _awaitReturnValueFromSecondScreen() async {
    // start the SecondScreen and wait for it to finish with a result

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: AddressesPage.routeName),
        builder: (context) => new AddressesPage(forSelect: true),
      ),
    );
    setState(() {
      Provider.of<CartProvider>(context, listen: false).paymentData['address'] =
          result;
    });
  }

  _buildHeadingItem(item) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        height: 45,
        color: AppColors.BLUE_GRAY,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              item.heading,
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black45,
              ),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
        ),
      ),
    );
  }

  _buildPlusButton(item) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: AppColors.CATEGORY_SHADOW,
                    blurRadius: 4.0,
                  ),
                ],
              ),
              width: 45,
              height: 30,
              child: FlatButton(
                onPressed: _awaitReturnValueFromSecondScreen,
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.add,
                  color: AppColors.MAIN,
                ),
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, child) => ConditionalBuilder(
              condition: cart.paymentData['address'] == null,
              builder: (BuildContext context) {
                return Text(
                  item.body,
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  style: TextStyle(
                    color: AppColors.MAIN,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
              fallback: (BuildContext context) {
                _address = cart.paymentData['address'] != null
                    ? cart.paymentData['address']
                    : null;
                return Text(
                  _address != null ? _address.address : "",
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  style: TextStyle(
                    color: AppColors.MAIN,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.blue, width: 2.0),
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.BORDER_RADIUS),
        ),
      ),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration.collapsed(
              hintText: S.of(context).checkoutPage_additionalInfo,
            ),
          ),
        ),
      ),
    );
  }

  _buildPlain(item) {
    // remove listen: false if needed
    String text = '000';
    final _provider = Provider.of<CartProvider>(context, listen: false);

    if (item.id == Identifier.subTotal) {
      text = getCurrency(
        _provider.subtotalCost,
        S.of(context).symbol,
      );
    }
    if (item.id == Identifier.delivery) {
      text = getCurrency(
        _provider.shippingCost(),
        S.of(context).symbol,
      );
    }
    if (item.id == Identifier.balance) {
      text = getCurrency(
        skidka,
        S.of(context).symbol,
      );
    }
    if (item.id == Identifier.earnPoints) {
      text = getCurrency(
        (_provider.subtotalCost * _provider.paymentData['percentage']) / 100,
        S.of(context).symbol,
      );
    }
    if (item.id == Identifier.total) {
      text = _usePoints
          ? getCurrency(
              _provider.totalWithPoint,
              S.of(context).symbol,
            )
          : getCurrency(
              _provider.totalWithoutPoint,
              S.of(context).symbol,
            );
    }
    return Container(
      padding: EdgeInsets.only(
        left: 12.0,
        right: 12,
        top: 8,
        bottom: 8,
      ),
      height: (item.id == Identifier.total) ? 42 : 40,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item.body,
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            style: (item.id == Identifier.total)
                ? TextStyle(
                    color: AppColors.MAIN,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )
                : TextStyle(
                    color: (item.id == Identifier.earnPoints)
                        ? Colors.green
                        : Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
          ),
          Text(
            text,
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            style: (item.id == Identifier.total)
                ? TextStyle(
                    color: AppColors.MAIN,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )
                : TextStyle(
                    color: (item.id == Identifier.earnPoints)
                        ? Colors.green
                        : Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
          ),
        ],
      ),
    );
  }

  _buildRadioBtn(item) {
    return Container(
      color: Colors.white,
      child: // This goes to the build method
          Consumer<CartProvider>(
        builder: (_, cart, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12.0),
              child: Text(
                item.body,
                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            RadioListTile(
              value: cart.paymentData['payments'][0],
              groupValue: _paymentType,
              title: Text(
                // S.of(context).checkoutPage_cash,
                cart.paymentData['payments'][0].name,
                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              ),
              subtitle: Text(
                // S.of(context).checkoutPage_payCash,
                cart.paymentData['payments'][0].description,

                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              ),
              onChanged: (val) {
                setState(() {
                  _paymentType = val;
                });
              },
              activeColor: AppColors.MAIN,
              // selected: kartBloc.kart.type == 'cash',
            ),
            RadioListTile(
              value: cart.paymentData['payments'][1],
              groupValue: _paymentType,
              title: Text(
                // S.of(context).terminal,
                cart.paymentData['payments'][1].name,

                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              ),
              subtitle: Text(
                // S.of(context).pay_with_terminal_text,
                cart.paymentData['payments'][1].description,

                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              ),
              onChanged: (val) {
                setState(() {
                  _paymentType = val;
                });
              },
              activeColor: AppColors.MAIN,
              // selected: kartBloc.kart.type == 'cash',
            ),
            RadioListTile(
              value: cart.paymentData['payments'][2],
              groupValue: _paymentType,
              title: Text(
                // S.of(context).checkoutPage_online,
                cart.paymentData['payments'][2].name,

                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              ),
              subtitle: Text(
                // S.of(context).checkoutPage_payOnline,
                cart.paymentData['payments'][2].description,

                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              ),
              onChanged: (val) {
                // kartBloc.add(SelectType('online'));
                setState(() {
                  _paymentType = val;
                });
              },
              activeColor: AppColors.MAIN,
              // selected: kartBloc.kart.type == 'online',
            ),
          ],
        ),
      ),
    );
  }

  _buildPointsCheckboxBtn(item) {
    return Container(
      color: Colors.white,
      child: // This goes to the build method
          Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12.0),
            child: Text(
              item.body,
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 30,
                  child: new Checkbox(
                    value: _usePoints,
                    onChanged: _usePointChanged,
                    activeColor: AppColors.MAIN,
                  ),
                ),
                Center(
                    child: Container(
                  width: 300,
                  child: ListTile(
                    title: Text(
                      "${(balance > 1) ? "${balance.toStringAsFixed(2)} ${S.of(context).point}" : "${balance.toStringAsFixed(2)} ${S.of(context).point_plural}"}  (${getCurrency(balance, S.of(context).symbol)})",
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      S.of(context).use_points,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTac(item, {BuildContext context}) {
    return Container(
      padding: EdgeInsets.only(
        top: 12.0,
        right: 12.0,
        bottom: 12.0,
      ),
      height: (item.id == Identifier.total) ? 60 : 50,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Checkbox(
            value: _termsAndConditions,
            onChanged: _termsAndConditionsChanged,
            activeColor: AppColors.MAIN,
          ),
          InkWell(
            onTap: () {
              _termsAndConditionsChanged(!_termsAndConditions,
                  context: context);
            },
            child: Center(
              child: Text(
                item.body,
                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                style: (item.id == Identifier.total)
                    ? TextStyle(
                        color: AppColors.MAIN,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )
                    : TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildButton(BuildContext context, CartProvider cart) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        height: 64,
        color: AppColors.BLUE_GRAY,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.BORDER_RADIUS / 2),
            ),
            child: FlatButton(
              onPressed: () async {
                if (_checkoutLoading) return;
                if (!_termsAndConditions) return;
                if (_address == null) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        S.of(context).checkoutPage_addressNotSelected,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                setState(() {
                  _checkoutLoading = true;
                });

                await Provider.of<CartProvider>(context, listen: false)
                    .checkout(
                  _address.id,
                  _paymentType.id,
                  _descriptionController.text,
                  _usePoints,
                );
                if (cart.checkoutData != null) {
                  if (cart.checkoutData['payment'].type != "online") {
                    showAlertDialog(context, cart.checkoutData['message']);
                  } else {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        settings: RouteSettings(name: PaymentPage.routeName),
                        builder: (context) {
                          return PaymentPage(
                              checkout: cart.checkoutData['payment']);
                        },
                      ),
                    );
                  }
                }
                if (cart.checkoutError.length != 0) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        cart.checkoutError,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }

                setState(() {
                  _checkoutLoading = false;
                });
              },
              color: (!_termsAndConditions) ? Colors.grey : AppColors.MAIN,
              splashColor:
                  (!_termsAndConditions) ? Colors.grey : AppColors.MAIN_LIGHT,
              child: ConditionalBuilder(
                condition: _checkoutLoading,
                builder: (BuildContext context) {
                  return GLoading();
                },
                fallback: (BuildContext contex) {
                  return Text(
                    S.of(context).checkoutPage_orderNow,
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CartProvider>(context, listen: false);
    items = [
      HeadingItem(S.of(context).checkoutPage_additionalInfo),
      BodyItem('', CellType.textField, Identifier.textArea),
      HeadingItem(S.of(context).checkoutPage_address),
      BodyItem(
        S.of(context).checkoutPage_addressSelect,
        CellType.plusButton,
        Identifier.address,
      ),
      HeadingItem(S.of(context).checkoutPage_toPay),
      BodyItem(
        S.of(context).checkoutPage_productTotal,
        CellType.plain,
        Identifier.subTotal,
      ),
      BodyItem(
        S.of(context).checkoutPage_deliveryService,
        CellType.plain,
        Identifier.delivery,
      ),
      BodyItem(
        S.of(context).checkoutPage_toPay,
        CellType.plain,
        Identifier.total,
      ),
      BodyItem(
        S.of(context).checkoutPage_payType,
        CellType.radioBtn,
        Identifier.paymentType,
      ),
      BodyItem(
        S.of(context).checkoutPage_TaC,
        CellType.TaC,
        Identifier.TaC,
      ),
    ];

    // Here, very unprofessional code. please, increment or decrement index if you will add or remove item

    if (balance != null) {
      items.insert(
        7,
        BodyItem(
          (skidka > 1) ? S.of(context).used_points : S.of(context).used_points,
          CellType.plain,
          Identifier.balance,
        ),
      );
      items.insert(
        9,
        BodyItem(
          S.of(context).earn_points +
              " (${_provider.paymentData['percentage']}%)",
          CellType.plain,
          Identifier.earnPoints,
        ),
      );
      if (balance != 0) {
        items.insert(
          10,
          BodyItem(
            S.of(context).getir_point,
            CellType.usePointsRadio,
            Identifier.usePoints,
          ),
        );
      }
      if (_usePoints && _provider.totalWithPoint <= 0.0) {
        _paymentType = _provider.paymentData['payments'][0];
        items.removeAt(
            11); // remove payment methods if sum less or equal to zero
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).checkoutPage_title,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
            if (_isLoading) {
              return LoadingPage();
            }

            return Stack(
              children: [
                ListView.builder(
                  itemCount: items.length,
                  padding: EdgeInsets.only(bottom: 72),
                  itemBuilder: (BuildContext context, index) {
                    final item = items[index];
                    if (item is HeadingItem) {
                      return _buildHeadingItem(item);
                    }
                    if (item is BodyItem) {
                      Widget child;
                      if (item.type == CellType.plusButton) {
                        child = _buildPlusButton(item);
                      } else if (item.type == CellType.textField) {
                        child = _buildTextField();
                      } else if (item.type == CellType.plain) {
                        child = _buildPlain(item);
                      } else if (item.type == CellType.radioBtn) {
                        child = _buildRadioBtn(item);
                      } else if (item.type == CellType.usePointsRadio) {
                        child = _buildPointsCheckboxBtn(item);
                      } else if (item.type == CellType.TaC) {
                        child = _buildTac(item, context: context);
                      }
                      return child;
                    }
                    return Container();
                  },
                ),
                _buildButton(context, cart),
              ],
            );
          },
        ),
      ),
    );
  }
}

abstract class ListItem {}

// A ListItem that contains data to display a heading
class HeadingItem extends ListItem {
  final String heading;

  HeadingItem(this.heading);
}

class BodyItem extends ListItem {
  final String body;
  final CellType type;
  final Identifier id;

  BodyItem(this.body, this.type, this.id);
}
