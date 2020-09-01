import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../widgets/common/cart_action.dart';
import '../../widgets/common/common.dart';
import '../../models/product.dart';
import '../../provider/product.dart';
import '../../generated/i18n.dart';
import '../../provider/provider.dart';
import '../../utils/utils.dart';
import '../../models/category.dart';
import './section_widget.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = 'products';

  final List<Category> categories;
  final int index;

  ProductsPage({Key key, this.categories, this.index}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  final String locale = RootProvider.locale;
  bool showTab = true;

  @override
  void initState() {
    tabController = TabController(
      length: widget.categories.length,
      initialIndex: widget.index,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  final stream = ProductProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).productsPage_title,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [CartAction()],
      ),
      body: new DefaultTabController(
        length: 3,
        child: new Column(
          children: <Widget>[
            showTab
                ? new Container(
                    constraints: BoxConstraints(maxHeight: 150.0),
                    child: new Material(
                        color: AppColors.MAIN_LIGHT,
                        child: TabBar(
                          controller: tabController,
                          isScrollable: true,
                          indicatorColor: AppColors.TAB_LINE_YELLOW,
                          indicatorWeight: 3,
                          tabs: widget.categories
                              .map((category) =>
                                  new Tab(text: category.name[locale]))
                              .toList(),
                        )),
                  )
                : Container(),
            new Expanded(
              child: TabBarView(
                  controller: tabController,
                  children: widget.categories
                      .map((category) => StreamBuilder(
                            stream: stream.subCategoriesStream(category.id),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: LoadingPage(),
                                );
                              }

                              return StreamProvider<List<Product>>.value(
                                value: stream.productsStream(category.id),
                                child: SectionWidget(
                                  subCategories: snapshot.data,
                                ),
                              );
                            },
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
