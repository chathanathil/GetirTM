import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getirtm/provider/home.dart';
import 'package:provider/provider.dart';

import '../../utils/dimens.dart';
import '../../utils/colors.dart';
import '../../models/category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  CategoryWidget(this.category, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.BORDER_RADIUS),
            child: new CachedNetworkImage(
              imageUrl: category.image != null ? category.image : '',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
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
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.BORDER_RADIUS),
            ),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: AppColors.CATEGORY_SHADOW,
                blurRadius: 6.0,
              ),
            ],
          ),
          margin: EdgeInsets.all(5.0),
          height: width / 2,
          width: width / 2,
        ),
        Positioned(
          top: 15,
          left: 15,
          child: Container(
            padding: EdgeInsets.all(3.0),
            width: width / 3,
            height: 60,
            child: Consumer<HomeProvider>(
              builder: (ctx, hm, child) => Text(
                category.name[hm.locale] != null
                    ? category.name[hm.locale]
                    : '',
                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
