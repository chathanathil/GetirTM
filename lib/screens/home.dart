// TODO:Some issue with loading, length was called on null

import 'package:flutter/material.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import '../models/category.dart';
import '../models/slider.dart';
import '../provider/product.dart';

import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/helpers.dart';
import '../utils/link_container.dart';

import '../widgets/common/loading_page.dart';
import '../widgets/home/category.dart';
import '../widgets/product/products_page.dart';
import '../widgets/common/cart_action.dart';
import '../widgets/common/common.dart';

import '../generated/i18n.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "home";
  final Key navigatorKey;

  HomeScreen({Key key, this.navigatorKey}) : super(key: key);

  Widget _buildImageSlider(slides) {
    return ImagesSlider(
      items: map<Widget>(
        slides,
        (index, i) {
          return Container(
            child: new CachedNetworkImage(
              imageUrl: slides[index].image,
              fit: BoxFit.fitHeight,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.fitHeight),
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
          );
        },
      ),
      autoPlay: true,
      viewportFraction: 1.0,
      aspectRatio: 750 / 400,
      distortion: false,
      align: IndicatorAlign.bottom,
      indicatorWidth: 3,
      indicatorColor: AppColors.MAIN,
    );
  }

  final stream = ProductProvider();
  Widget _buildCategoryGrid(categories) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //Column
        mainAxisSpacing: 10.0, //spaceTopBottom
        crossAxisSpacing: 10.0, //spaceLeftRight
        childAspectRatio: 450 / 400,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return createLinkContainer(
            context,
            CategoryWidget(categories[index]),
            () {
              if (categories[0].name == null) {
                return EmptyPage(
                  title: S.of(context).notFound,
                  message: S.of(context).homePage_empty,
                );
              }
              return ProductsPage(
                categories: categories,
                index: index,
              );
            },
          );
        },
        childCount: categories.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context);
    final slides = Provider.of<List<Slide>>(context);
    print(categories);
    print(slides);
    Scaffold scaffold = Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).homePage_title,
            style: TextStyle(fontWeight: FontWeight.w600),
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR_TITLES,
          ),
          actions: <Widget>[CartAction()],
        ),
        body:
            // slides != null || categories != null
            //     ? slides.length > 0 && categories.length > 0
            //         ?
            CustomScrollView(
          slivers: <Widget>[
            ConditionalBuilder(
              condition: slides.length > 0,
              builder: (BuildContext context) {
                return SliverToBoxAdapter(child: _buildImageSlider(slides));
              },
              fallback: (BuildContext context) {
                return SliverToBoxAdapter();
              },
            ),
            ConditionalBuilder(
              condition: categories.length > 0,
              builder: (BuildContext context) {
                return SliverPadding(
                  padding: EdgeInsets.all(10.0),
                  sliver: _buildCategoryGrid(categories),
                );
              },
              fallback: (BuildContext context) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('No categories found')),
                );
              },
            )
          ],
        )
        //     : EmptyPage()
        // : LoadingPage()
        );
    if (slides[0].id == 0 || categories[0].id == 0) {
      return LoadingPage();
    }
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (slides.length == 0 && categories.length == 0) {
              return EmptyPage();
            }
            return scaffold;
          },
        );
      },
    );
  }
}

// @override
// void dispose() {
//   _refreshController.dispose();
//   super.dispose();
// }
// }
