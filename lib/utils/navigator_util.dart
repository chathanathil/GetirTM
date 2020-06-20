import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getirtm/widgets/profile/contact.dart';
import 'package:getirtm/widgets/profile/feedback_page.dart';
import 'package:getirtm/widgets/profile/privacy.dart';
import 'package:getirtm/widgets/profile/terms.dart';

import '../models/order.dart';
// import 'package:flutter_getir/widgets/cart_page.dart';
import '../widgets/product/products_page.dart';
import '../widgets/profile/address_page.dart';
import '../widgets/cart/checkout_page.dart';
// import 'package:flutter_getir/widgets/cart/payment_page.dart';
import '../widgets/profile/order_details_page.dart';
import '../widgets/profile/order_history_page.dart';
import '../widgets/profile/discount_card_page.dart';
import '../widgets/profile/discount_card_get_page.dart';
import '../screens/favourites.dart';
import '../widgets/profile/faqs_page.dart';
import '../widgets/profile/about_page.dart';
import '../widgets/verify/verify_page.dart';

class NavigatorUtils {
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static pop(BuildContext context) {
    Navigator.pop(context, false);
  }

  static goHome(BuildContext context) {
    Navigator.pop(context, "/");
  }

  static goProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: ProductsPage.routeName),
        builder: (context) => new ProductsPage(),
      ),
    );
  }

  static goAddresses(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: RouteSettings(name: AddressesPage.routeName),
        builder: (context) => new AddressesPage(forSelect: false),
      ),
    );
  }

  // static goOrders(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     new MaterialPageRoute(
  //       settings: RouteSettings(name: OrderHistoryPage.routeName),
  //       builder: (context) => new OrderHistoryPage(),
  //     ),
  //   );
  // }

  // static goOrderDetails(BuildContext context, Order order) {
  //   Navigator.push(
  //     context,
  //     new MaterialPageRoute(
  //       settings: RouteSettings(name: OrderDetailsPage.routeName),
  //       builder: (context) => new OrderDetailsPage(order: order),
  //     ),
  //   );
  // }

  static goLogin(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      new MaterialPageRoute(
        fullscreenDialog: true,
        settings: RouteSettings(name: VerifyPage.routeName),
        builder: (context) => new VerifyPage(),
      ),
    );
  }

  // static goCartPage(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     new MaterialPageRoute(
  //       settings: RouteSettings(name: CartPage.routeName),
  //       builder: (context) => new CartPage(),
  //     ),
  //   );
  // }

  static goCheckoutPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: CheckoutPage.routeName),
        builder: (context) => CheckoutPage(),
      ),
    );
  }

  // static goPaymentPage(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     new MaterialPageRoute(
  //       settings: RouteSettings(name: PaymentPage.routeName),
  //       builder: (context) => new PaymentPage(),
  //     ),
  //   );
  // }

  static goDiscountCardPage(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: RouteSettings(name: DiscountCardPage.routeName),
        builder: (context) => new DiscountCardPage(),
      ),
    );
  }

  static goDiscountCardGetPage(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: RouteSettings(name: DiscountCardGetPage.routeName),
        builder: (context) => new DiscountCardGetPage(),
      ),
    );
  }

  static goFavoritesPage(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: RouteSettings(name: FavoritesScreen.routeName),
        builder: (context) => new FavoritesScreen(),
      ),
    );
  }

  static goFaqsPage(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: RouteSettings(name: FaqsPage.routeName),
        builder: (context) => new FaqsPage(),
      ),
    );
  }

  static goAboutPage(BuildContext context, String path, String title) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: RouteSettings(name: AboutPage.routeName),
        builder: (context) => new AboutPage(
          path: path,
          title: title,
        ),
      ),
    );
  }

  static goWebViewPageAsRoot(BuildContext context, String path, String title) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          return AboutPage(
            path: path,
            title: title,
          );
        },
      ),
    );
  }

  static goPrivacyPageAsRoot(BuildContext context, String path, String title) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          return PrivacyPage(
            path: path,
            title: title,
          );
        },
      ),
    );
  }

  static goTermsPageAsRoot(BuildContext context, String path, String title) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          return TermsPage(
            path: path,
            title: title,
          );
        },
      ),
    );
  }

  static goContactPageAsRoot(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          return ContactPage();
        },
      ),
    );
  }

  static goFeedbackPageAsRoot(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          return FeedbackPage();
        },
      ),
    );
  }
}
