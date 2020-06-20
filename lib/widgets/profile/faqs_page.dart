import 'package:flutter/material.dart';

import '../../models/faq.dart';
import '../../provider/home.dart';
import '../../widgets/common/common.dart';
import '../../utils/utils.dart';

class FaqsPage extends StatelessWidget {
  static const routeName = 'faqs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).faqsPage_title,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR_SMALL,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder(
        future: HomeProvider.faqs(),
        builder: (BuildContext context, AsyncSnapshot<List<Faq>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          }

          if (snapshot.hasError) {
            return ErrorPage(S.of(context).checkoutPage_error);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.isEmpty) {
              return EmptyPage();
            }

            return ListView(
              children: snapshot.data.map((faq) {
                return ExpansionTile(
                  title: Text(faq.question,
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR),
                  initiallyExpanded: false,
                  children: <Widget>[
                    ListTile(
                      title: Text(faq.answer,
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR),
                    )
                  ],
                );
              }).toList(),
            );
          }

          return Container();
        },
      ),
    );
  }
}
