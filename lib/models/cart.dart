import './product.dart';

class CartItem {
  final List<Product> products;

  CartItem({this.products});

  num addProduct(Product product, {num quantity: 1}) {
    int index = products.indexWhere((p) => p.id == product.id);

    if (index == -1) {
      products.add(product.copyWith(quantity: quantity));
      return quantity;
    }

    // TODO: check stock
    // if (products[index].total <= quantity) {
    //   products[index].quantity = products[index].total;
    //   return;
    // }

    products[index] =
        products[index].copyWith(quantity: products[index].quantity + quantity);

    return products[index].quantity;
  }

  num productquantity(Product product) {
    int index = products.indexWhere((p) => p.id == product.id);
    if (index == -1) return 0;
    return products[index].quantity;
  }

  num removeProduct(Product product, {num quantity: 1}) {
    int index = products.indexWhere((p) => p.id == product.id);

    if (index == -1) return 0;

    if (products[index].quantity <= quantity) {
      products.removeAt(index);
      return 0;
    }

    products[index] =
        products[index].copyWith(quantity: products[index].quantity - quantity);

    return products[index].quantity;
  }
}
