import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getirtm/provider/cart.dart';
import 'package:getirtm/provider/product.dart';
import 'package:getirtm/provider/provider.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../../models/product.dart';
import '../../utils/helpers.dart';
import '../../widgets/common/common.dart';
import '../../widgets/common/ribbon.dart';

class ProductWidget extends StatefulWidget {
  final Product product;

  ProductWidget(this.product, {Key key}) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final String locale = RootProvider.locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key("${widget.product.id}"),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Row(
          children: <Widget>[
            Consumer<ProductProvider>(
                builder: (_, favData, child) => _buildImage()),
            Consumer<ProductProvider>(
                builder: (_, favData, child) => _buildInfo(context)),
            Consumer<CartProvider>(
                builder: (_, cartData, child) => _buildButtons(cartData)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          Dimens.BORDER_RADIUS,
        ),
        child: ConditionalBuilder(
          condition: widget.product.discountPercentage != null,
          builder: (BuildContext context) {
            return Ribbon(
              nearLength: 20,
              farLength: 40,
              title: '${widget.product.discountPercentage.toInt()}%',
              titleStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              color: Colors.redAccent,
              location: RibbonLocation.topStart,
              child: Image(
                image: new CachedNetworkImageProvider(
                  widget.product.image,
                ),
                fit: BoxFit.cover,
                width: 80.0,
                height: 80.0,
              ),
            );
          },
          fallback: (BuildContext context) {
            return Image(
              image: new CachedNetworkImageProvider(
                widget.product.image,
              ),
              fit: BoxFit.cover,
              width: 80.0,
              height: 80.0,
            );
          },
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: new Border.all(
          color: AppColors.MAIN_LIGHT,
          width: 0.2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.BORDER_RADIUS),
        ),
      ),
      height: 80,
      width: 80,
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              widget.product.name[locale] != null
                  ? widget.product.name[locale]
                  : "",
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 15),
            ConditionalBuilder(
              condition: widget.product.discountPrice != null,
              builder: (BuildContext context) {
                return Row(
                  children: <Widget>[
                    Text(
                      getCurrency(
                        widget.product.discountPrice,
                        S.of(context).symbol,
                      ),
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      style: TextStyle(
                        color: AppColors.MAIN,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      getCurrency(
                        widget.product.price,
                        S.of(context).symbol,
                      ),
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                );
              },
              fallback: (BuildContext context) {
                return Text(
                  getCurrency(
                    widget.product.price,
                    S.of(context).symbol,
                  ),
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  style: TextStyle(
                    color: AppColors.MAIN,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(cartData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.BORDER_RADIUS),
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: AppColors.CATEGORY_SHADOW,
            blurRadius: 3.0,
            spreadRadius: 0.2,
          ),
        ],
      ),
      height: 40,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          Dimens.BORDER_RADIUS,
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 40,
              child: FlatButton(
                onPressed: () {
                  cartData.removeFromCart(widget.product);
                },
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Icon(
                  Icons.remove,
                  color: AppColors.MAIN,
                ),
              ),
            ),
            Container(
              height: 45,
              width: 40,
              color: AppColors.MAIN,
              child: Center(
                child: Text(
                  "${widget.product.quantity.toInt()}",
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: FlatButton(
                onPressed: () {
                  cartData.addToCart(widget.product);
                },
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Icon(
                  Icons.add,
                  color: AppColors.MAIN,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
