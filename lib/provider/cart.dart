import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:getirtm/helpers/shared_preferences_helper.dart';
import 'package:getirtm/models/address.dart';
import 'package:getirtm/models/checkout.dart';
import 'package:getirtm/models/discount_card.dart';
import 'package:getirtm/models/payment.dart';
import 'package:getirtm/models/user.dart';
import 'package:getirtm/provider/provider.dart';

import '../models/product.dart';
import '../helpers/db_helper.dart';

class CartProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  List<Product> cartItems = [];
  Future getCart() async {
    cartItems = await DB.instance.getKart();
    notifyListeners();
  }

  Future addToCart(Product product, {num quantity = 1}) async {
    num q = await DB.instance.addProduct(product, quantity: quantity);
    int index = cartItems.indexWhere((p) => p.id == product.id);

    if (index == -1) {
      cartItems.add(product.copyWith(quantity: quantity));
    } else {
      cartItems[index] = cartItems[index]
          .copyWith(quantity: cartItems[index].quantity + quantity);
    }
    notifyListeners();
  }

  Future removeFromCart(Product product, {num quantity: 1}) async {
    num q = await DB.instance.removeProduct(product, quantity: quantity);
    int index = cartItems.indexWhere((p) => p.id == product.id);

    if (index == -1) return 0;

    if (cartItems[index].quantity <= quantity) {
      cartItems.removeAt(index);
      notifyListeners();
    } else {
      cartItems[index] = cartItems[index]
          .copyWith(quantity: cartItems[index].quantity - quantity);
    }
    notifyListeners();
  }

  num getQuantity(Product product) {
    int index = cartItems.indexWhere((p) => p.id == product.id);
    if (index == -1) return 0;

    return cartItems[index].quantity;
  }

  Map<String, dynamic> paymentData = Map<String, dynamic>();

  num get subtotalCost => cartItems.map((p) {
        if (p.discountPrice != null && p.discountPrice != 0) {
          return num.parse(p.discountPrice.toStringAsFixed(2)) *
              (p.quantity ?? 0);
        }

        return num.parse(p.price.toStringAsFixed(2)) * (p.quantity ?? 0);
      }).fold(0.0, (sum, e) => sum + e);
  // Total cost to order everything in the cart.
  shippingCost() =>
      subtotalCost - paymentData['balance_points'] < paymentData['minimum']
          ? paymentData['shipping_price']
          : 0.0;
  num get totalWithoutPoint => subtotalCost + shippingCost();
  num get totalWithPoint =>
      ((subtotalCost + shippingCost()) - paymentData['balance_points']) <= 0.0
          ? 0.0
          : (subtotalCost + shippingCost()) - paymentData['balance_points'];

  num get pureProductTotal =>
      ((subtotalCost) - paymentData['balance_points']) <= 0.0
          ? 0.0
          : (subtotalCost) - paymentData['balance_points'];

  // Get payment types
  Future fetchPaymentData() async {
    Shipping shipping;
    Address addr;

    final snapshot = await _db.collection('payment_types').getDocuments();
    List<PaymentType> payments = snapshot.documents
        .map((item) => PaymentType.fromJson(item.data))
        .toList();

    final config =
        await _db.collection('configurations').document('1').get().then((data) {
      shipping = Shipping.fromJson(data);
    });

    User user = await SharedPreferencesHelper.getUserDetails();
    final fetchAddress = await _db
        .collection('users')
        .document(user.id.toString())
        .collection('addresses')
        .where("is_default", isEqualTo: true)
        .getDocuments()
        .then((data) {
      addr = Address.fromJson(data.documents.single.data);
    });

    final percent = _db.collection('users').document(user.id.toString());
    final discountCardData = await percent.get();
    DiscountCard discountDetails =
        DiscountCard.fromJson(discountCardData.data['discount_card']);

    paymentData = {
      'payments': payments,
      'minimum': shipping.minAmount,
      'shipping_price': shipping.shippingPrice,
      'percentage': discountDetails.percentage,
      'balance_points': discountDetails.point,
      'address': addr
    };

    notifyListeners();
  }

  Map<String, dynamic> checkoutData;
  bool checkouted = false;
  String checkoutError = "";
  Future checkout(
    int address,
    int type,
    String description,
    bool usePoint,
  ) async {
    var products = cartItems.map((p) {
      return {
        'id': p.id,
        'quantity': p.quantity,
        'price': num.parse(p.price.toStringAsFixed(2)),
      };
    }).toList();
    try {
      var response = await RootProvider.http.post(
        '/purchase',
        data: {
          'products': products,
          'payment_type_id': type,
          'address_id': address,
          "total_price": usePoint
              ? num.parse(totalWithPoint.toStringAsFixed(2))
              : num.parse(totalWithoutPoint.toStringAsFixed(2)),
          "discount_point": usePoint
              ? paymentData['balance_points'] > totalWithoutPoint
                  ? num.parse(totalWithoutPoint.toStringAsFixed(2))
                  : paymentData['balance_points']
              : 0,
          'description': description,
        },
      );
      checkouted = true;
      await DB.instance.clearKart();
      cartItems = [];
      if (type == 3) {
        checkoutData = {
          "payment": Checkout.fromJson(response.data['data']),
          "message":
              response.data['message'] != null ? response.data['message'] : ""
        };
        notifyListeners();
        return;
      }

      checkoutData = {
        "payment": Checkout(type: 'cash'),
        "message":
            response.data['message'] != null ? response.data['message'] : ""
      };
      notifyListeners();
    } catch (err) {
      checkoutError = err.response.data["message"] != null
          ? err.response.data["message"]
          : "Something went wrong";
      notifyListeners();
    }
  }
}
