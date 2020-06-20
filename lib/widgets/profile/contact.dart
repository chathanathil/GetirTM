import 'package:flutter/material.dart';
import '../../models/contact.dart';
import '../../provider/home.dart';
import '../../widgets/common/common.dart';
import '../../utils/utils.dart';

class ContactPage extends StatelessWidget {
  static const routeName = 'faqs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // S.of(context).faqsPage_title,
          'Contact',
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR_SMALL,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder(
        future: HomeProvider.contact(),
        builder: (BuildContext context, AsyncSnapshot<Contact> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          }

          if (snapshot.hasError) {
            return ErrorPage(S.of(context).checkoutPage_error);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.email == '' &&
                snapshot.data.phone == '' &&
                snapshot.data.address == '') {
              return EmptyPage();
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR_BIG,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      snapshot.data.address,
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    new Divider(
                      color: AppColors.MAIN,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Phone',
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR_BIG,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      snapshot.data.phone,
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    new Divider(
                      color: AppColors.MAIN,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Email',
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR_BIG,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      snapshot.data.email,
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                    ),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
