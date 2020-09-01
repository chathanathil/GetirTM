import 'package:flutter/material.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getirtm/models/contact.dart';
import 'package:getirtm/provider/auth.dart';
import 'package:getirtm/provider/home.dart';
import 'package:getirtm/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:url_launcher/url_launcher.dart';
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

class HomeScreen extends StatefulWidget {
  static const routeName = "home";
  final Key navigatorKey;

  HomeScreen({Key key, this.navigatorKey}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Contact contact;
  var _contentLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _contentLoading = true;
    });
    HomeProvider.contact().then((value) => contact = value);
    Provider.of<AuthProvider>(context, listen: false)
        .appContents()
        .then((value) => setState(() {
              _contentLoading = false;
            }));
    HomeProvider.contact().then((value) => contact = value);
    AuthProvider.storeFcmToken().then((value) async {
      final response =
          await RootProvider.http.post('/auth/fcm', data: {'fcm_token': value});
    });
  }

  final String locale = RootProvider.locale;

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

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onCall() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              // "Do you want to call customer service?",
              AuthProvider.appContent.callCustomerService[RootProvider.locale],
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            ),
            actions: [
              FlatButton(
                child: Text(
                  AuthProvider.appContent.no[RootProvider.locale],
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
              FlatButton(
                  child: Text(
                    AuthProvider.appContent.yes[RootProvider.locale],
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  onPressed: () => _makePhoneCall(
                      contact.phone != null ? 'tel:${contact.phone}' : 'tel:'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context);
    final slides = Provider.of<List<Slide>>(context);

    Scaffold scaffold = Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).homePage_title,
            style: TextStyle(fontWeight: FontWeight.w600),
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR_TITLES,
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.phone), onPressed: _onCall),
            CartAction()
          ],
        ),
        body: CustomScrollView(
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
              condition: categories[0].name != null,
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
        //     : EmptyPage()s
        // : LoadingPage()
        );
    if ((categories[0].id == 0 && slides[0].id == 0) || _contentLoading) {
      return LoadingPage();
    }
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (categories.length == 0) {
              return EmptyPage();
            }
            return scaffold;
          },
        );
      },
    );
  }
}
