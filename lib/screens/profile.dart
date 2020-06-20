import 'dart:io' show Platform;
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:getirtm/models/appContent.dart';
import 'package:getirtm/provider/discount_card.dart';
import 'package:getirtm/provider/provider.dart';
import '../widgets/profile/discount_card_page.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';
import '../widgets/common/common.dart';
import '../provider/auth.dart';
import '../provider/user.dart';
import '../root.dart';

enum UserActions {
  initial,
  editing,
  updating,
}

class ProfileScreen extends StatefulWidget {
  final Key navigatorKey;

  const ProfileScreen({Key key, this.navigatorKey}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('ullinnull');
    // print(Provider.of<AuthProvider>(context, listen: false).isAuthenticated);

    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Consumer<AuthProvider>(
                builder: (ctx, auth, _) => ProfilePageContent(auth));
          },
        );
      },
    );
  }
}

class ProfilePageContent extends StatefulWidget {
  final auth;
  ProfilePageContent(this.auth);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageContent> {
  static const routeName = "profile";

  // AuthBloc authBloc;
  double _sectionPadding = 8;
  UserActions status = UserActions.initial;
  TextEditingController _usernameController = TextEditingController();
  var _contentLoading = false;
  // bool authenticated = false;

  // @override
  // void initState() async {
  //   super.initState();

  //   // authBloc = BlocProvider.of<AuthBloc>(context);
  // }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    final _provider = Provider.of<AuthProvider>(context, listen: false);
    _provider.hasToken();
    setState(() {
      _contentLoading = true;
    });
    _provider.appContents().then((value) => setState(() {
          _contentLoading = false;
          // print(_provider.appContent);
        }));
  }

// FOR EDITING NAME

  _saveUser() async {
    setState(() {
      status = UserActions.updating;
    });

    await Provider.of<AuthProvider>(context, listen: false).updateUser({
      'name': _usernameController.text,
    });

    setState(() {
      status = UserActions.initial;
    });
  }

  String locale = RootProvider.locale;
  _localeSelected(BuildContext context, Locale locale) async {
    // setState(() {
    locale = locale;
    // });
    Root.setLocale(context, locale);
    Navigator.of(context).pop();
    print('localing');
    print(locale);
    print(RootProvider.locale);
  }

  Widget buildMainSection(BuildContext context) {
    print('ullil');
    print(widget.auth);
    print(widget.auth.isAuthenticated);
    List<Widget> children = [];

    if (widget.auth.isAuthenticated) {
      children.add(
        ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new Icon(
                  Icons.account_circle,
                  size: constraint.biggest.height,
                  color: AppColors.MAIN,
                );
              },
            ),
          ),
          title: ConditionalBuilder(
            condition: status == UserActions.editing,
            builder: (BuildContext context) {
              return CupertinoTextField(
                controller: _usernameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onEditingComplete:
                    _saveUser, ///////############## EDIT HERE #################//////
              );
            },
            fallback: (BuildContext context) {
              return Text(
                _usernameController.text.isNotEmpty
                    ? _usernameController.text
                    : S.of(context).profilePage_unknown,
                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              );
            },
          ),
          trailing: ConditionalBuilder(
            condition: status == UserActions.editing,
            builder: (BuildContext context) {
              return IconButton(
                  icon: Icon(
                    Icons.save,
                    color: AppColors.MAIN,
                  ),
                  onPressed:
                      _saveUser ///////############## EDIT HERE #################//////
                  );
            },
            fallback: (BuildContext context) {
              return ConditionalBuilder(
                condition: status == UserActions.updating,
                builder: (BuildContext context) {
                  return CupertinoActivityIndicator();
                },
                fallback: (BuildContext context) {
                  return IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.MAIN,
                    ),
                    onPressed: () {
                      print('edit user');
                      setState(() {
                        status = UserActions.editing;
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      );

      if (widget.auth.user.phone.toString() != '') {
        children.add(ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.phone_android,
              color: AppColors.MAIN,
            ),
          ),
          title: Text(
            widget.auth.user.phone.toString(),
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          ),
          enabled: false,
        ));
      }
    } else {
      children.add(ListTile(
        leading: Icon(
          Icons.person,
          color: AppColors.MAIN,
        ),
        title: Text(
          S.of(context).profilePage_login,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: AppColors.MAIN,
        ),
        onTap: () {
          NavigatorUtils.goLogin(context);
        },
      ));
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.all(_sectionPadding),
      color: Colors.white,
      child: Column(
        children: children,
      ),
    );
  }

  Widget buildPageSection(BuildContext context) {
    if (!widget.auth.isAuthenticated) return Container();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(_sectionPadding),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.credit_card,
              color: AppColors.MAIN,
            ),
            title: Text(
              S.of(context).discount_card,
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.MAIN,
            ),
            onTap: () {
              NavigatorUtils.goDiscountCardPage(context);
            },
          ),
          SizedBox(height: 6),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: AppColors.MAIN,
            ),
            title: Text(
              S.of(context).profilePage_favorites,
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.MAIN,
            ),
            onTap: () {
              NavigatorUtils.goFavoritesPage(context);
            },
          ),
          SizedBox(height: 6),
          ListTile(
            leading: Icon(
              Icons.location_city,
              color: AppColors.MAIN,
            ),
            title: Text(
              S.of(context).profilePage_address,
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.MAIN,
            ),
            onTap: () {
              NavigatorUtils.goAddresses(context);
              // print("address");
            },
          ),
          SizedBox(height: 6),
          ListTile(
            leading: Icon(
              Icons.shopping_basket,
              color: AppColors.MAIN,
            ),
            title: Text(
              S.of(context).profilePage_orders,
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.MAIN,
            ),
            onTap: () {
              // NavigatorUtils.goOrders(context);
              print('goto order page');
            },
          ),
        ],
      ),
    );
  }

  _onTapLocale() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            // title: Text('Title'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  S.of(context).langTm,
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                ),
                onPressed: () {
                  _localeSelected(context, Locale('en', ''));
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  S.of(context).langRu,
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                ),
                onPressed: () {
                  _localeSelected(context, Locale('ru', ''));
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: Text(
                S.of(context).close,
                textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return Container(
                height: 186,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Center(
                        child: Text(
                          S.of(context).langTm,
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        ),
                      ),
                      onTap: () {
                        _localeSelected(context, Locale('en', ''));
                      },
                    ),
                    Divider(height: 8),
                    ListTile(
                      title: Center(
                        child: Text(
                          S.of(context).langRu,
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        ),
                      ),
                      onTap: () {
                        _localeSelected(context, Locale('ru', ''));
                      },
                    ),
                    Divider(height: 8),
                    ListTile(
                      title: Center(
                        child: Text(
                          S.of(context).close,
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('content loading');
    print(locale);
    // print(widget.auth.appContent.myProfile[RootProvider.locale]);
    print(RootProvider.locale);
    if (widget.auth.isAuthenticated) {
      _usernameController.text = widget.auth.user.name;
    }
    if (_contentLoading) {
      return LoadingPage();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // widget.auth.appContent.myProfile[RootProvider.locale] == null
          // ?
          S.of(context).profilePage_title,
          // : widget.auth.appContent.myProfile[RootProvider.locale],
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body:

          //  BlocListener(
          //   bloc: authBloc,
          //   listener: (BuildContext context, AuthState state) {
          // if (state is AuthAuthenticated) {
          //   _usernameController.text = state.user.name;
          // }

          //     // if (state is AuthError) {
          //     //   showMessageDialog(context, state.error);
          //     // }
          //   },
          //   child: BlocBuilder(
          //     bloc: authBloc,
          //     builder: (BuildContext context) {
          // return
          ListView(
        shrinkWrap: true,
        children: <Widget>[
          buildMainSection(context),
          buildPageSection(context),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(_sectionPadding),
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    S.of(context).profilePage_version,
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  trailing: FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (BuildContext context,
                        AsyncSnapshot<PackageInfo> snapshot) {
                      return Text(
                        snapshot.data?.version ?? '0.0',
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      );
                    },
                  ),
                ),
                Divider(height: 12),
                ListTile(
                  title: Text(
                    S.of(context).profilePage_lang,
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  trailing: ConditionalBuilder(
                    condition:
                        Localizations.localeOf(context).languageCode == 'en',
                    builder: (BuildContext context) {
                      return Text(
                        S.of(context).langTm,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      );
                    },
                    fallback: (BuildContext context) {
                      return Text(
                        S.of(context).langRu,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      );
                    },
                  ),
                  onTap: _onTapLocale,
                ),
                Divider(height: 12),
                ListTile(
                  title: Text(
                    S.of(context).profilePage_help,
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.MAIN,
                  ),
                  onTap: () {
                    NavigatorUtils.goFaqsPage(context);
                  },
                ),
                Divider(height: 12),
                ListTile(
                  title: Text(
                    S.of(context).profilePage_about,
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.MAIN,
                  ),
                  onTap: () {
                    NavigatorUtils.goWebViewPageAsRoot(
                      context,
                      Constants.ABOUT,
                      S.of(context).aboutPage_title,
                    );
                  },
                ),
                Divider(height: 12),
                ListTile(
                  title: Text(
                    // S.of(context).profilePage_about,
                    'Privacy',
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.MAIN,
                  ),
                  onTap: () {
                    NavigatorUtils.goPrivacyPageAsRoot(
                      context,
                      Constants.ABOUT,
                      S.of(context).aboutPage_title,
                    );
                  },
                ),
                Divider(height: 12),
                ListTile(
                  title: Text(
                    // S.of(context).profilePage_about,
                    'Terms',
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.MAIN,
                  ),
                  onTap: () {
                    NavigatorUtils.goTermsPageAsRoot(
                      context,
                      Constants.ABOUT,
                      S.of(context).aboutPage_title,
                    );
                  },
                ),
                Divider(height: 12),
                ListTile(
                  title: Text(
                    // S.of(context).profilePage_about,
                    'Contact',
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.MAIN,
                  ),
                  onTap: () {
                    NavigatorUtils.goContactPageAsRoot(
                      context,
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    // S.of(context).profilePage_about,
                    'Feedback',
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.MAIN,
                  ),
                  onTap: () {
                    NavigatorUtils.goFeedbackPageAsRoot(
                      context,
                    );
                  },
                ),
                ConditionalBuilder(
                  condition: widget.auth.isAuthenticated,
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        Divider(height: 12),
                        ListTile(
                            title: Text(
                              S.of(context).profilePage_logout,
                              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: AppColors.MAIN,
                            ),
                            onTap: widget.auth.logout),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ListTile(
          //     title: Text(
          //       'Powered by Asman Oky',
          //       style: TextStyle(color: Colors.grey[500]),
          //     ),
          //   ),
          // ),
        ],
        //     );
        //   },
        // ),
      ),
    );
  }
}
