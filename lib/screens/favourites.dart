import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../widgets/common/common.dart';
import '../utils/utils.dart';
import '../widgets/common/empty_page.dart';
import '../widgets/product/product_widget.dart';
import '../widgets/product/product_details_page.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = 'favorites';

  const FavoritesScreen({Key key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductProvider>(context)
        .getFavourites()
        .then((value) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).favoritePage_title,
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Consumer<ProductProvider>(
          builder: (ctx, fav, child) {
            if (_isLoading) {
              return LoadingPage();
            }
            if (fav.favItems.length == 0) {
              return EmptyPage(
                title: S.of(context).notFound,
                message: S.of(context).favoritePage_empty,
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.only(
                left: 10.0,
                top: 10,
                right: 7.0,
                bottom: 10.0,
              ),
              itemCount: fav.favItems.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: Dimens.PRODUCT_MAIN_AXIS_SPACING,
                crossAxisSpacing: Dimens.PRODUCT_MAIN_AXIS_SPACING,
                childAspectRatio: 1 / 1.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                var product = fav.favItems[index];
                return createModalLinkContainer(
                  context,
                  ProductWidget(product),
                  () {
                    return ProductDetailsPage(product);
                  },
                );
              },
            );
          },
        ));
  }
}
