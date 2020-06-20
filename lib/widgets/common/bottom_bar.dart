import 'package:flutter/material.dart';
import 'package:getirtm/provider/cart.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_getir/bloc/kart/kart.dart';
import '../../utils/colors.dart';
import '../../utils/dimens.dart';

class BottomBarItem {
  BottomBarItem({@required this.icon});

  IconData icon;
}

class BottomBar extends StatelessWidget {
  final List<BottomBarItem> children;
  final Function onPressed;
  final Function onMainPressed;
  final selectedIndex;

  BottomBar({
    this.children = const [],
    this.onPressed,
    this.onMainPressed,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    //ignore: close_sinks
    // final KartBloc kartBloc = BlocProvider.of<KartBloc>(context);

    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[100],
      child: SafeArea(
        bottom: true,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 8.0,
                offset: Offset(
                  0.0, // horizontal, move right 10
                  -6.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Stack(
            overflow: Overflow.visible,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: children.map<Widget>(
                  (item) {
                    int index = children.indexOf(item);
                    bool isSelected = selectedIndex == index;
                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            onPressed(index);
                          },
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              item.icon,
                              size: 29,
                              color: isSelected ? AppColors.MAIN : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList()
                  ..insert(2, SizedBox(width: 80)),
              ),
              Positioned(
                top: -14,
                width: size.width,
                child: Center(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Stack(children: [
                      ClipOval(
                        child: Material(
                          color: selectedIndex == 4
                              ? AppColors.MAIN
                              : AppColors.MAIN_LIGHT, //Colors.grey[100],
                          child: InkWell(
                            onTap: () {
                              onMainPressed();
                            },
                            child: Center(
                              child: Image.asset('assets/images/logo.png',
                                  height: 26,
                                  color: selectedIndex == 4
                                      ? Colors.white
                                      : Colors.white //AppColors.MAIN,
                                  // color: Colors.grey,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child:
                                // BlocBuilder(
                                //     bloc: kartBloc,
                                //     builder: (BuildContext context, KartState state) {
                                //       return (kartBloc.kart.products.length > 0)
                                //           ?
                                Consumer<CartProvider>(
                                    builder: (_, cartData, child) =>
                                        cartData.cartItems.length > 0
                                            ? Container(
                                                height: 25.0,
                                                width: 25.0,
                                                color: Colors.red,
                                                child: Center(
                                                  child: new Text(
                                                    "${cartData.cartItems.length}",
                                                    textScaleFactor: Dimens
                                                        .TEXT_SCALE_FACTOR,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            : Container())
                            // : Container();
                            // }),
                            ),
                      )
                    ]),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
