import 'package:flutter/material.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:provider/provider.dart';

import '../../provider/cart.dart';

import '../../utils/utils.dart';

class CartAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Consumer<CartProvider>(
        builder: (ctx, cartData, child) => ConditionalBuilder(
          condition: cartData.cartItems.length > 0,
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  S.of(context).checkoutPage_total + ':',
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                ),
                Text(
                  getCurrency(cartData.subtotalCost, "m."),
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
