// TODO:Subtottal check in text widget in this page

import 'package:flutter/material.dart';
import 'package:getirtm/helpers/db_helper.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../provider/cart.dart';
import '../utils/utils.dart';
import '../widgets/common/common.dart';
import '../widgets/product/product_details_page.dart';
import '../widgets/cart/product_cell_widget.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "cart";
  final Key navigatorKey;

  const CartScreen({Key key, this.navigatorKey}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).hasToken();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _isLoading = true;
    });
    Provider.of<CartProvider>(context, listen: false)
        .getCart()
        .then((value) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).cartPage_title,
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Consumer<CartProvider>(builder: (_, cartData, child) {
          if (_isLoading) {
            return LoadingPage();
          }
          if (cartData.cartItems.length == 0) {
            return EmptyPage(
              title: S.of(context).notFound,
              message: S.of(context).cartPage_empty,
            );
          }
          return Stack(
            children: [
              _buildList(cartData),
              ConditionalBuilder(
                condition: cartData.cartItems.length != 0,
                builder: (BuildContext context) {
                  return Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: _buildButton(),
                  );
                },
              ),
            ],
          );
        }));
  }

  Widget _buildList(cartData) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 64.0),
      itemCount: cartData.cartItems.length,
      itemBuilder: (context, index) {
        var product = cartData.cartItems[index];

        return createModalLinkContainer(
          context,
          ProductWidget(product),
          () {
            return ProductDetailsPage(product);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(
              height: 0.3,
              color: AppColors.MAIN_LIGHT,
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (!auth.isAuthenticated) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  S.of(context).login_to_order,
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(height: 5),
                FlatButton(
                  onPressed: () {
                    NavigatorUtils.goLogin(context);
                  },
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    S.of(context).profilePage_login,
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                    style: TextStyle(fontSize: 18),
                  ),
                  color: AppColors.MAIN,
                  textColor: Colors.white,
                ),
              ],
            ),
          );
        }

        return Container(
          color: AppColors.BLUE_GRAY,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 26),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.BORDER_RADIUS),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 45,
                          color: AppColors.MAIN,
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  elevation: 2.0,
                  color: Colors.transparent,
                  shadowColor: Colors.grey[50],
                  child: InkWell(
                    splashColor: Colors.white30,
                    onTap: () {
                      NavigatorUtils.goCheckoutPage(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 45,
                            child: Center(
                              child: Text(
                                S.of(context).cartPage_continue,
                                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Container(
                            height: 45,
                            child: Center(
                              child: Text(
                                'total',
                                // getCurrency(
                                //   bloc.kart.subtotalCost,
                                //   S.of(context).symbol,
                                // ),
                                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                                style: TextStyle(
                                  color: AppColors.MAIN,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
