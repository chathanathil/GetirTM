import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:getirtm/models/category.dart';
import 'package:getirtm/models/slider.dart';
import 'package:getirtm/provider/address.dart';
import 'package:getirtm/provider/discount_card.dart';
import 'package:getirtm/provider/search.dart';
import 'package:provider/provider.dart';

import './provider/home.dart';
import './provider/cart.dart';
import './provider/provider.dart';
import './provider/auth.dart';
import './provider/user.dart';
import "./provider/order.dart";
import './models/product.dart';
import './provider/product.dart';

import './generated/i18n.dart';

import "./utils/colors.dart";

import './screens/home.dart';
import './screens/cart.dart';
import './screens/profile.dart';
import './screens/search.dart';
import './screens/favourites.dart';

import "./widgets/common/bottom_bar.dart";
import './widgets/common/cupertino_localisation.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();

  static void setLocale(BuildContext context, Locale locale) async {
    _RootState state = context.findAncestorStateOfType<State<Root>>();

    await HomeProvider.setLocale(locale.languageCode);
    await RootProvider.setRequestHeaders();
    // BlocProvider.of<CategoryBloc>(context).add(FetchCategories(resync: true));

    state.setState(() {
      state._locale = locale;
    });
  }
}

class _RootState extends State<Root> {
  static const routeName = "root";

  final GlobalKey<NavigatorState> homeNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> profileNavKey = GlobalKey<NavigatorState>();
  List<GlobalKey<NavigatorState>> _navigatorKeys;
  List<Widget> _screens;
  // KartBloc kartBloc;
  int currentIndex = 0;
  Locale _locale;

  @override
  void initState() {
    super.initState();

    HomeProvider.getLocale().then((locale) async {
      if (locale == null) {
        await HomeProvider.setLocale('ru');
        return;
      }

      setState(() {
        _locale = Locale(locale, '');
      });
    });

    // kartBloc = KartBloc();
    _navigatorKeys = [homeNavKey, profileNavKey];
    _screens = [
      HomeScreen(navigatorKey: homeNavKey),
      SearchPage(),
      FavoritesScreen(),
      ProfileScreen(navigatorKey: profileNavKey),
      CartScreen(),
    ];
  }

  @override
  void dispose() {
    // kartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DiscountCardProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        StreamProvider.value(
          initialData: [Category(id: 0, image: '', name: '')],
          value: ProductProvider().categoriesStream,
          // catchError: (_, err) => 'error',
        ),
        StreamProvider(
          create: (_) => ProductProvider().slideStream,
          initialData: [Slide(id: 0, image: '', title: '')],
        ),
        // StreamProvider.value(value: ProductProvider().subCategoriesStream),
        // StreamProvider.value(
        //   value: ProductProvider().productsStream,
        //   // catchError: (context, err) => null,
        // ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        locale: _locale,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const <LocalizationsDelegate>[
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          const FallbackCupertinoLocalisationsDelegate(),
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback: S.delegate.resolution(
          fallback: Locale('ru', ''),
        ),
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: AppColors.MAIN,
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
        ),
        home: Container(
          color: AppColors.MAIN,
          child: SplashScreen(
            'assets/images/logo.flr',
            (context) => WillPopScope(
              onWillPop: () async {
                final NavigatorState navigator =
                    _navigatorKeys[currentIndex].currentState;
                if (!navigator.canPop()) return true;
                navigator.pop();
                return false;
              },
              child: Scaffold(
                body: IndexedStack(
                  index: currentIndex,
                  children: _screens,
                ),
                bottomNavigationBar: BottomBar(
                  selectedIndex: currentIndex,
                  children: [
                    BottomBarItem(icon: Icons.home),
                    BottomBarItem(icon: Icons.search),
                    BottomBarItem(icon: Icons.favorite),
                    BottomBarItem(icon: Icons.person),
                  ],
                  onMainPressed: () {
                    // kartBloc.add(LoadKart());
                    setState(() {
                      currentIndex = 4;
                    });
                    print("mainPressed");
                  },
                  onPressed: (index) {
                    if (currentIndex == index) {
                      switch (index) {
                        case 0:
                          homeNavKey.currentState.popUntil((r) => r.isFirst);
                          break;
                        case 3:
                          profileNavKey.currentState.popUntil((r) => r.isFirst);
                          break;
                      }
                    }
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            until: () => Future.delayed(Duration(seconds: 3)),
            startAnimation: 'logo',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
