import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:getirtm/provider/discount_card.dart';
import 'package:getirtm/provider/order.dart';
import 'package:getirtm/widgets/profile/discount_card_get_page.dart';
import 'package:provider/provider.dart';
import '../../provider/user.dart';
import '../../utils/utils.dart';
import '../../models/order.dart';
import '../../widgets/common/common.dart';
// import '../../provider/order_provider.dart';
// import '../../bloc/discount_card/discount_card.dart';
import '../../widgets/profile/discount_card_add_page.dart';

class DiscountCardPage extends StatefulWidget {
  static const routeName = 'discount_card';
  final bool forSelect;

  const DiscountCardPage({Key key, this.forSelect = false}) : super(key: key);

  @override
  _DiscountCardPageState createState() => _DiscountCardPageState();
}

class _DiscountCardPageState extends State<DiscountCardPage> {
  // final DiscountCardBloc bloc = DiscountCardBloc();
  bool isBackButtonActivated = true;
  var _loadingCards = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _loadingCards = true;
      });
      Provider.of<DiscountCardProvider>(context, listen: false)
          .fetchDiscountCards()
          .then((_) {
        print('printttttt');
        print(Provider.of<DiscountCardProvider>(context, listen: false)
            .orderHistory[0]
            .id);
        setState(() {
          _loadingCards = false;
        });
      });
      _isInit = false;
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).discount_card,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body:
          //  Consumer<UserProvider>(
          //   builder: (ctx,discountCards,child) {
          //     if (state is DiscountCardVerified) {
          //       bloc.add(FetchDiscountCard());
          //     }

          //     if (state is DiscountCardDeleted) {
          //       Scaffold.of(context).showSnackBar(SnackBar(
          //         content: Text(
          //           'Deleted',
          //           // S.of(context).,
          //           textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          //         ),
          //         duration: Duration(seconds: 3),
          //       ));
          //     }

          //     if (state is DiscountCardError) {
          //       showMessageDialog(
          //         context,
          //         state.error,
          //         title: S.of(context).error,
          //         close: S.of(context).close,
          //       );
          //     }
          //   },
          // child:
          Consumer<DiscountCardProvider>(
        builder: (ctx, cards, child) {
          // if (state is DiscountCardFetching ||
          //     state is DiscountCardVerifying) {
          //   return Center(
          //     child: GLoading(),
          //   );
          // }
          if (_loadingCards) {
            return Center(
              child: GLoading(),
            );
          }

          // if (state is DiscountCardEmpty || bloc.discountCard == null) {
          //   return DiscountCardAddPage(bloc: bloc);
          // }
          // Check weather it is needed or not
          if (cards.discountCard == null) {
            return DiscountCardGetPage();
          }

          return _buildCard(cards);
        },
      ),
      // ),
    );
  }

  Widget _buildCard(cards) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: new BorderRadius.all(const Radius.circular(20.0)),
              child: ClipRRect(
                borderRadius: new BorderRadius.all(const Radius.circular(20.0)),
                child: Container(
                  height: 190,
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [AppColors.MAIN_LIGHT, AppColors.MAIN],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.5, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.2,
                        spreadRadius: 0.3,
                      ),
                    ],
                  ),
                  // width: MediaQuery.of(context).size.width - 40,
                  // padding: EdgeInsets.all(17.0),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        // child: Container(),
                        child: CachedNetworkImage(
                          // imageUrl: cards.discountCard.background,
                          imageUrl: 'http://getir.safedevs.com/images/card.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              height: 20,
                              child: Image.asset(
                                'assets/images/logo_text.png',
                                height: 20,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              child: Text(
                                cards.discountCard.cardNumber
                                    .toString()
                                    .replaceAllMapped(
                                      RegExp(r".{4}"),
                                      (match) => "${match.group(0)}  ",
                                    ),
                                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Helvetica',
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "${cards.discountCard.percentage}%",
                                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Helvetica',
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "${S.of(context).point}: ${getCurrency(cards.discountCard.point, S.of(context).symbol)}",
                                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Helvetica',
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 5,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.1,
                    blurRadius: 6.0,
                    color: Colors.black12,
                  )
                ],
              ),
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: cards.orderHistory.length,
                itemBuilder: (context, index) {
                  var point = cards.orderHistory[index];
                  print(point);
                  return Container(
                    width: 100.0,
                    constraints: BoxConstraints(minHeight: 72),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Order #${point.id.toString()}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                              ),
                              SizedBox(height: 3),
                              AutoSizeText(
                                point.description,
                                // 'data',
                                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/revenue.png',
                                  height: 13,
                                  width: 13,
                                ),
                                Text(
                                  "${getCurrency(point.point, S.of(context).symbol)}",
                                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                                  style: TextStyle(
                                    color: point.point > 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${getDateWithFormat(point.date, toFormat: "dd-MM-yyyy hh:mm")}",
                              // 'data',
                              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
