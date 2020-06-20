// TODO: filter pdts

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:getirtm/widgets/common/common.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../models/sub_category.dart';
import '../../provider/product.dart';
import '../common/bubble_indicator.dart';
import '../../utils/utils.dart';
import '../../widgets/product/product_details_page.dart';
import '../../widgets/product/product_widget.dart';
import '../../provider/provider.dart';

class SectionWidget extends StatelessWidget {
  final List<SubCategory> subCategories;
  final String locale = RootProvider.locale;
  final int categoryId;
  final scrollController = ScrollController();

  SectionWidget({Key key, @required this.subCategories, this.categoryId})
      : super(key: key);
  final stream = ProductProvider();

  Widget _buildBody(double itemWidth, double itemHeight, products) {
    return SafeArea(
      bottom: false,
      child: ListView.separated(
        controller: scrollController,
        itemCount: subCategories.length,
        separatorBuilder: (context, index) {
          if (index < subCategories.length) {
            SubCategory category = subCategories[index + 1];

            return Container(
              height: 50,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    category.name != null ? category.name : '',
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
        itemBuilder: (context, index) {
          List<Product> _products = products
              .where((pdt) => pdt.subcategoryId == subCategories[index].id)
              .toList();

          return GridView.count(
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 7,
              bottom: 0,
            ),
            crossAxisCount: 3,
            mainAxisSpacing: Dimens.PRODUCT_MAIN_AXIS_SPACING,
            crossAxisSpacing: Dimens.PRODUCT_MAIN_AXIS_SPACING,
            childAspectRatio: itemWidth / itemHeight,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: _products.map((product) {
              return createModalLinkContainer(
                context,
                ProductWidget(product),
                () {
                  return ProductDetailsPage(product);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // _filterCategories(List<SubCategory> categories, List<Product> products) {
  //   print(categories);
  //   print(products);
  //   int count = 0;
  //   List<SubCategory> filteredSubCategories = [];
  //   for (int i = 0; i < categories.length; i++) {
  //     for (int j = 0; j < products.length; j++) {
  //       if (categories[i].id == products[j].categoryId) {
  //         count++;
  //       }
  //     }
  //     if (count > 0) {
  //       filteredSubCategories.add(categories[i]);
  //       count = 0;
  //     }
  //     count = 0;
  //   }
  //   print(filteredSubCategories);
  //   return filteredSubCategories;
  // }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);
    Size size = MediaQuery.of(context).size;
    // print(products[0].image);
    double itemWidth =
        (size.width - Dimens.PRODUCT_MAIN_AXIS_SPACING * 2 - 17) / 3;

    double itemHeight = itemWidth + 66;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child:
            //  subCategories[0].name != null
            // ?
            Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.TABBAR_SHADOW,
                offset: Offset(0.0, 0.0),
                blurRadius: 10,
              ),
            ],
          ),
          child: SubcategoryTabs(
            categories:
                subCategories, ////////// """££££££££" give subcategories if it has pdts
            onItemPressed: (index) {
              print('index');
              print(index);

              double offset = subCategories.getRange(0, index).fold(
                0,
                (prev, category) {
                  List<Product> _products = products
                      .where((pdt) => pdt.subcategoryId == category.id)
                      .toList();
                  print(category.products);
                  int rows = (_products.length / 3).ceil();
                  return prev +=
                      rows * (itemHeight + Dimens.PRODUCT_MAIN_AXIS_SPACING);
                },
              );

              scrollController.animateTo(
                offset + ((index - 1) * 55),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            },
          ),
        ),
        // : Container()
      ),
      body: products != null
          ? products.length == 0
              ? Text('empty')
              : _buildBody(itemWidth, itemHeight, products)
          : Align(
              alignment: Alignment.center, child: Center(child: GLoading())),
    );
  }
}

class SubcategoryTabs extends StatefulWidget {
  final List<SubCategory> categories;
  final Function onItemPressed;
  final String locale = RootProvider.locale;

  SubcategoryTabs({
    Key key,
    this.categories,
    this.onItemPressed,
  }) : super(key: key);

  @override
  _SubcategoryTabsState createState() => _SubcategoryTabsState();
}

class _SubcategoryTabsState extends State<SubcategoryTabs>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.categories.length,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        unselectedLabelColor: AppColors.MAIN,
        indicator: BubbleTabIndicator(
          indicatorRadius: 9,
          indicatorColor: AppColors.MAIN,
          padding: EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: -2.0,
          ),
        ),
        tabs: widget.categories
            .map<Widget>((category) => Tab(text: category.name))
            .toList(),
        onTap: widget.onItemPressed,
      ),
    );
  }
}
