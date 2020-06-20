import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../helpers/db_helper.dart';

class CartProvider with ChangeNotifier {
  List<Product> cartItems = [];
  Future getCart() async {
    cartItems = await DB.instance.getKart();
  }

  Future addToCart(Product product, {num quantity = 1}) async {
    num q = await DB.instance.addProduct(product, quantity: quantity);
    int index = cartItems.indexWhere((p) => p.id == product.id);

    if (index == -1) {
      cartItems.add(product.copyWith(quantity: quantity));
      // notifyListeners();
      // return quantity;
    } else {
      cartItems[index] = cartItems[index]
          .copyWith(quantity: cartItems[index].quantity + quantity);
    }
    notifyListeners();
    // return cartItems[index].quantity;
  }

  Future removeFromCart(Product product, {num quantity: 1}) async {
    num q = await DB.instance.removeProduct(product, quantity: quantity);
    int index = cartItems.indexWhere((p) => p.id == product.id);

    if (index == -1) return 0;

    if (cartItems[index].quantity <= quantity) {
      cartItems.removeAt(index);
      notifyListeners();
      // return 0;
    } else {
      cartItems[index] = cartItems[index]
          .copyWith(quantity: cartItems[index].quantity - quantity);
    }
    notifyListeners();
    // return cartItems[index].quantity;
  }

  num getQuantity(Product product) {
    int index = cartItems.indexWhere((p) => p.id == product.id);
    if (index == -1) return 0;

    return cartItems[index].quantity;
  }
}
