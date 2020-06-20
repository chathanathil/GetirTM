//TODO:Fav Togling is not working properly

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:photo_view/photo_view.dart';

import '../../provider/cart.dart';
import '../../generated/i18n.dart';
import '../common/ribbon.dart';
import '../../models/product.dart';
import '../../provider/product.dart';
import '../../provider/provider.dart';
import '../../utils/utils.dart';
import '../common/sliver_appbar_delegate.dart';

// class ProductDetailsPage extends StatefulWidget {

//   ProductDetailsPage(this.product, {Key key}) : super(key: key);

//   @override
//   _ProductDetailsPageState createState() => _ProductDetailsPageState();
// }

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  ProductDetailsPage(this.product, {Key key}) : super(key: key);

  final String locale = RootProvider.locale;

  @override
  Widget build(BuildContext context) {
    print(product.name);
    print(product.isFavorited);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Container(
            color: AppColors.MAIN,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: CupertinoNavigationBar(
                backgroundColor: AppColors.MAIN,
                leading: IconButton(
                  padding: EdgeInsets.only(right: 20),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: false).pop(null);
                  },
                ),
                trailing: Consumer<ProductProvider>(
                  builder: (ctx, pdt, _) => IconButton(
                    padding: EdgeInsets.only(left: 20),
                    icon: Icon(
                      Icons.favorite,
                      color: product.isFavorited
                          ? AppColors.TAB_LINE_YELLOW
                          : AppColors.MAIN_DARK,
                    ),
                    onPressed: () {
                      pdt.toggleFavoriteStatus(product);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Consumer<CartProvider>(
              builder: (ctx, cartData, _) {
                return Stack(
                  children: [
                    CustomScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      slivers: <Widget>[
                        _buildHeader(),
                        _buildHeaderText(),
                        _buildHeaderDivider(50.0),
                      ],
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        color: Colors.white,
                        height: 64,
                        alignment: Alignment.center,
                        child: ConditionalBuilder(
                          condition: cartData.getQuantity(product) > 0,
                          builder: (BuildContext context) {
                            return _MinusPlusButton(product);
                          },
                          fallback: (BuildContext context) {
                            return _AddToBasketButton(product);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader _buildHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 100.0,
        maxHeight: 190.0,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ConditionalBuilder(
                    condition: product.discountPercentage != null,
                    builder: (BuildContext context) {
                      return Ribbon(
                        nearLength: 30,
                        farLength: 50,
                        title: '${product.discountPercentage.toInt()}%',
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        color: Colors.redAccent,
                        location: RibbonLocation.topStart,
                        child: Container(
                          height: 200,
                          width: 200,
                          color: Colors.white,
                          child: _photoWidget(product.image, context),
                        ),
                      );
                    },
                    fallback: (BuildContext context) {
                      return _photoWidget(product.image, context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoWidget(String image, context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
            appBar: AppBar(title: Text('')),
            body: Container(
              color: Colors.white,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(
                  color: Colors.white,
                ),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained,
                imageProvider: CachedNetworkImageProvider(image),
                heroAttributes: PhotoViewHeroAttributes(
                  tag: image,
                ),
              ),
            ),
          ),
        ),
      ),
      child: Hero(
        tag: image,
        child: Image(
          image: CachedNetworkImageProvider(
            image,
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader _buildHeaderText() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 120.0,
        child: IgnorePointer(
          ignoring: false, //!product.isPackage,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3.0,
                  spreadRadius: 0.1,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                ConditionalBuilder(
                  condition: product.discountPrice != null,
                  builder: (context) {
                    return Column(
                      children: [
                        Text(
                          getCurrency(
                            product.price,
                            S.of(context).symbol,
                          ),
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          getCurrency(
                            product.discountPrice,
                            S.of(context).symbol,
                          ),
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.MAIN,
                          ),
                        ),
                      ],
                    );
                  },
                  fallback: (context) {
                    return Text(
                      getCurrency(
                        product.price,
                        S.of(context).symbol,
                      ),
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.MAIN,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          product.name != null ? product.name : '',
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderDivider(double height) {
    return SliverToBoxAdapter(
      child: ConditionalBuilder(
        condition: product.description.length > 0,
        builder: (BuildContext context) {
          return IgnorePointer(
            ignoring: !product.isPackage,
            child: Column(
              children: <Widget>[
                _buildSectionText(
                    S.of(context).productDetailsPage_details, height),
                Container(
                  color: Colors.white,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: 30.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: AutoSizeText(
                        product.description != null ? product.description : '',
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR_BIG,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        maxFontSize: 16,
                        minFontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionText(String text, double height) {
    return Container(
      height: height,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Text(
            text,
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _MinusPlusButton extends StatelessWidget {
  final Product product;
  final double _btnHeight = 45.0;

  _MinusPlusButton(this.product);

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.BORDER_RADIUS / 2),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.CATEGORY_SHADOW,
            blurRadius: 3.0,
            spreadRadius: 0.2,
          ),
        ],
      ),
      height: _btnHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          Dimens.BORDER_RADIUS / 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Material(
              type: MaterialType.transparency,
              child: IconButton(
                padding: EdgeInsets.symmetric(horizontal: 12),
                onPressed: () {
                  cartData.removeFromCart(product);
                },
                icon: Icon(Icons.remove),
                iconSize: 28,
                color: AppColors.MAIN,
              ),
            ),
            Container(
              width: 60,
              color: AppColors.MAIN,
              child: Center(
                child: Text(
                  cartData.getQuantity(product).toInt().toString(),
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: IconButton(
                padding: EdgeInsets.symmetric(horizontal: 12),
                onPressed: () {
                  cartData.addToCart(product);
                },
                icon: Icon(Icons.add),
                iconSize: 28,
                color: AppColors.MAIN,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddToBasketButton extends StatelessWidget {
  final Product product;
  final double _btnHeight = 45.0;

  _AddToBasketButton(this.product);

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    return Container(
      height: _btnHeight,
      width: MediaQuery.of(context).size.width - 20,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.BORDER_RADIUS / 2),
        ),
        onPressed: () {
          cartData.addToCart(product);
        },
        child: Text(
          S.of(context).productDetailsPage_addToBasket,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        color: AppColors.MAIN,
      ),
    );
  }
}
