import 'dart:async';
// import '../models/category.dart';
import 'package:path/path.dart';
import 'dart:io' show Directory;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/product.dart';

class DB {
  static final DB instance = DB._();
  static Database _database;

  DB._();

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
    print(path);

    return await openDatabase(
      path,
      version: 3,
      onOpen: (Database db) {
        print('opening db');
      },
      onCreate: _onCreate,
      // onUpgrade: _onUpgradeAndDowngrade,
      // onDowngrade: _onUpgradeAndDowngrade,
    );
  }

  _onCreate(Database db, int version) async {
    print('creating db $version');
    await _createTableProducts(db);
    await _createTableCart(db);
    await _createTableFavorites(db);
  }

  // _onUpgradeAndDowngrade(Database db, int oldVersion, int newVersion) async {
  //   print('upgrading-downgrading db old: $oldVersion, new: $newVersion');
  //   await SharedPreferencesHelper.removeLastSync();
  //   await _createTableProducts(db);
  //   await _createTableCategories(db);
  // }

  /// Create products table
  Future<void> _createTableProducts(Database db) async {
    await db.execute('DROP TABLE IF EXISTS products;');
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        category_id INTEGER,
        subcategory_id INTEGER,
        name TEXT,
        image TEXT,
        description TEXT,
        price REAL,
        discount_price REAL,
        discount_percentage REAL,
        stock REAL,
        is_package INTEGER,
        'order' INTEGER NOT NULL DEFAULT(0),
        created_at REAL
      );
    ''');
  }

  /// Create cart table
  Future<void> _createTableCart(Database db) async {
    await db.execute('DROP TABLE IF EXISTS cart;');
    await db.execute('''
      CREATE TABLE cart (
        product_id INTEGER,
        quantity REAL,
        FOREIGN KEY (product_id) REFERENCES products (id)
      );
    ''');
  }

  /// Create favorites table
  Future<void> _createTableFavorites(Database db) async {
    await db.execute('DROP TABLE IF EXISTS favorites;');
    await db.execute('''
      CREATE TABLE favorites (
        product_id INTEGER,
        created_at TEXT,
        FOREIGN KEY (product_id) REFERENCES products (id)
      );
    ''');
  }

  // PRODUCTS
  createProduct(Product product) async {
    print(product.toJson());
    final db = await database;
    var batch = db.batch();
    var _products = await db.rawQuery(
      'SELECT * FROM products WHERE id=?',
      [product.id],
    );
    if (_products.isNotEmpty) {
      return;
    }
    batch.execute(
      'INSERT OR REPLACE INTO products VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      product.toJson().values.toList(),
    );
    await batch.commit(noResult: true, continueOnError: false);
  }

  clearProducts() async {
    final db = await database;
    await db.execute('DELETE FROM products; VACUUM');
  }

  Future<bool> isFavorited(int id) async {
    final db = await database;
    var _products = await db.rawQuery(
      'SELECT * FROM favorites WHERE product_id=?',
      [id],
    );
    if (_products.isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> toggleFavorite(Product product) async {
    final db = await database;
    var _products = await db.rawQuery(
      'SELECT * FROM favorites WHERE product_id=?',
      [product.id],
    );

    if (_products.isEmpty) {
      await db.rawInsert(
        'INSERT INTO favorites VALUES (?, ?)',
        [product.id, DateTime.now().toString()],
      );
      return true;
    } else {
      await db.rawDelete(
        'DELETE FROM favorites WHERE product_id=?',
        [product.id],
      );
      // Delete products from product table if the product is not present in cart
      var _cartProducts = await db.rawQuery(
        'SELECT * FROM cart WHERE product_id=?',
        [product.id],
      );
      if (_cartProducts.isNotEmpty) {
        return false;
      }
      await db.rawDelete(
        'DELETE FROM products WHERE id=?',
        [product.id],
      );
      return false;
    }
  }

  Future<List<Product>> getFavorites() async {
    final db = await database;
    var _products = await db.rawQuery('''
      SELECT * FROM products
      JOIN favorites ON favorites.product_id=products.id
    ''');
    // print(_products);
    return List.from(_products).map((product) {
      print(product['title']);
      print(product);
      print(product['image']);
      print(product['price']);
      Product _product = Product.fromSql(product);
      _product.isFavorited = true;

      return _product;
    }).toList();
  }

  // KART
  Future<List<Product>> getKart() async {
    final db = await database;
    var _products = await db.rawQuery('''
      SELECT
        products.*,
        EXISTS(SELECT 1 FROM favorites WHERE product_id=products.id) is_favorited,
        cart.quantity
      FROM cart
      JOIN products ON products.id=cart.product_id
    ''');
    print(_products);
    return List.from(_products)
        .map((product) => Product.fromSql(product))
        .toList();
  }

  addProduct(Product product, {num quantity = 1}) async {
    final db = await database;
    var _products = await db.rawQuery(
      'SELECT * FROM cart WHERE product_id=?',
      [product.id],
    );

    if (_products.isEmpty) {
      await createProduct(product);
      await db.rawInsert(
        'INSERT INTO cart (product_id, quantity) VALUES (?, ?)',
        [product.id, quantity],
      );
      // return quantity;
    } else {
      quantity += _products.first['quantity'];
      await db.rawUpdate(
        'UPDATE cart SET quantity=? WHERE product_id=?',
        [quantity, product.id],
      );
      // return quantity;
    }
  }

  removeProduct(Product product, {num quantity = 1}) async {
    print('in db');
    final db = await database;
    var _products = await db.rawQuery(
      'SELECT * FROM cart WHERE product_id=?',
      [product.id],
    );

    if (_products.isEmpty) return;

    if (_products.first['quantity'] > quantity) {
      quantity = _products.first['quantity'] - quantity;
      await db.rawUpdate(
        'UPDATE cart SET quantity=? WHERE product_id=?',
        [quantity, product.id],
      );
      print('db');
      // print(quantity);
      return quantity;
    } else {
      // Delete products from product table if the product is not favorited
      var _favProducts = await db.rawQuery(
        'SELECT * FROM favorites WHERE product_id=?',
        [product.id],
      );
      if (_favProducts.isEmpty) {
        await db.rawDelete(
          'DELETE FROM products WHERE id=?',
          [product.id],
        );
      }
      await db.rawDelete('DELETE FROM cart WHERE product_id=?', [product.id]);
      // return quantity;
    }
  }

  // getQuantity(Product product) async {
  //   final db = await database;
  //   var products = await db.rawQuery(
  //     'SELECT * FROM cart WHERE product_id=?',
  //     [product.id],
  //   );
  //   if (products.isEmpty) {
  //     return 0;
  //   }
  //   print('£££££££££££££');
  //   print(products.first['quantity']);
  //   return products.first['quantity'];
  // }

  clearKart() async {
    final db = await database;
    await db.execute('DELETE FROM cart; VACUUM;');
  }

  // repeatOrder(Order order) async {
  //   final db = await database;
  //   await db.execute('DELETE FROM cart; VACUUM');

  //   var batch = db.batch();
  //   order.products.forEach((product) {
  //     batch.insert('cart', {
  //       'product_id': product.id,
  //       'quantity': product.quantity
  //     });
  //   });
  //   await batch.commit(noResult: true, continueOnError: true);
  // }
}
