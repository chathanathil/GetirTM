// TODO: Check commented things

import 'dart:async';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../generated/i18n.dart';
import '../../helpers/db_helper.dart';
import '../../models/cart.dart';
import '../../models/product.dart';
import '../../provider/product.dart';
import '../../provider/provider.dart';
import '../../utils/utils.dart';
import '../../provider/cart.dart';
import '../common/ribbon.dart';

class ProductWidget extends StatefulWidget {
  final Product product;

  const ProductWidget(this.product, {Key key}) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  num quantity = 0;
  double height = 35;
  double borderWidth = 0.2;
  double buttonSize = 35;
  final double leftRightPaddings = 20;
  Timer timer;
  final String locale = RootProvider.locale;
  CartItem ct = CartItem();
  @override
  void initState() {
    super.initState();
    // Check it is needed or not else remove
    quantity = Provider.of<CartProvider>(context, listen: false)
        .getQuantity(widget.product);

    _calcButtonSize();
    DB.instance.isFavorited(widget.product.id).then((value) {
      if (this.mounted) {
        setState(() {
          widget.product.isFavorited = value;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quantity = Provider.of<CartProvider>(context).getQuantity(widget.product);
    _calcButtonSize();
  }

  _calcButtonSize() {
    quantity = Provider.of<CartProvider>(context, listen: false)
        .getQuantity(widget.product);
    if (quantity >= 1) {
      setState(() {
        height = buttonSize * 3;
        borderWidth = 0.6;
      });
    } else {
      setState(() {
        height = buttonSize;
        borderWidth = 0.2;
      });
    }
  }

  Widget _buildButtons(cartData) {
    return Positioned(
      right: -6.0,
      top: -8.0,
      child: AnimatedContainer(
        width: buttonSize,
        height: height,
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: AppColors.CATEGORY_SHADOW,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Wrap(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: buttonSize,
                  height: buttonSize,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Center(
                      child: GestureDetector(
                        onLongPressStart: (details) {
                          timer = Timer.periodic(
                            Duration(milliseconds: 500),
                            (timer) {
                              cartData.addToCart(widget.product);

                              _calcButtonSize();
                            },
                          );
                        },
                        onLongPressEnd: (details) {
                          timer.cancel();
                        },
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            cartData.addToCart(widget.product);

                            _calcButtonSize();
                          },
                          icon: Icon(Icons.add),
                          iconSize: 28,
                          color: AppColors.MAIN,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: AppColors.MAIN,
                  width: buttonSize,
                  height: buttonSize,
                  child: Center(
                    child: Text(
                      "${quantity.toInt()}",
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR_SMALL,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: buttonSize,
                  height: buttonSize,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Center(
                      child: GestureDetector(
                        onLongPressStart: (details) {
                          timer = Timer.periodic(
                            Duration(milliseconds: 500),
                            (timer) {
                              cartData.removeFromCart(widget.product);
                              _calcButtonSize();
                            },
                          );
                        },
                        onLongPressEnd: (details) {
                          timer.cancel();
                        },
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            cartData.removeFromCart(widget.product);
                            _calcButtonSize();
                          },
                          icon: Icon(Icons.remove),
                          iconSize: 28,
                          color: AppColors.MAIN,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = size.width / 3 - leftRightPaddings;

    Widget image = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.BORDER_RADIUS),
        child: new CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: widget.product.image,
          placeholder: (context, url) => Center(
            child: Container(
              height: 30,
              width: 30,
              child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Colors.black12,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return Center(
              child: new Icon(
                Icons.refresh,
                color: Colors.black12,
              ),
            );
          },
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: new Border.all(
          color: AppColors.MAIN,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.BORDER_RADIUS),
        ),
      ),
      height: itemWidth,
      width: itemWidth,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 0, right: 10),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ConditionalBuilder(
                condition: widget.product.discountPercentage != null,
                builder: (BuildContext context) {
                  return Ribbon(
                    nearLength: 30,
                    farLength: 50,
                    title: '${widget.product.discountPercentage.toInt()}%',
                    titleStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    color: Colors.redAccent,
                    location: RibbonLocation.topStart,
                    child: image,
                  );
                },
                fallback: (BuildContext context) {
                  return image;
                },
              ),
              Expanded(
                child: Container(
                  width: itemWidth,
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ConditionalBuilder(
                        condition: widget.product.discountPrice != null,
                        builder: (context) {
                          return Row(
                            children: <Widget>[
                              Text(
                                getCurrency(
                                  widget.product.discountPrice,
                                  S.of(context).symbol,
                                ),
                                textScaleFactor: 0.8,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.MAIN,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              Text(
                                getCurrency(
                                  widget.product.price,
                                  S.of(context).symbol,
                                ),
                                textScaleFactor: Dimens.TEXT_SCALE_FACTOR_SMALL,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          );
                        },
                        fallback: (context) {
                          return Text(
                            getCurrency(
                              widget.product.price,
                              S.of(context).symbol,
                            ),
                            textScaleFactor: Dimens.TEXT_SCALE_FACTOR_SMALL,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.MAIN,
                            ),
                            textAlign: TextAlign.right,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Text(
                          widget.product.name,
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR_SMALL,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Consumer<ProductProvider>(
              builder: (ctx, pdt, child) => widget.product.isFavorited
                  ? Positioned(
                      left: -10,
                      top: -10,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: AppColors.TAB_LINE_YELLOW,
                        ),
                        iconSize: 17,
                        onPressed: null,
                      ),
                    )
                  : Container()),
          Consumer<CartProvider>(
              builder: (ctx, cartData, child) => _buildButtons(cartData)),
        ],
      ),
    );
  }
}
