import 'package:flutter/material.dart';
import '../../utils/dimens.dart';
import '../../widgets/common/caching_future_builder.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../common/loading_page.dart';
import '../../provider/home.dart';

class PrivacyPage extends StatefulWidget {
  final String path;
  final String title;

  PrivacyPage({this.path, this.title});

  static const routeName = 'privacy';

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();
  }

  Future<int> getPageCount(Size size) {
    return Future.value(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxHeight, constraints.maxWidth);
            return CachingFutureBuilder<String>(
              key: ValueKey(size),
              futureFactory: () => HomeProvider.privacy(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return WebviewScaffold(
                    appBar: AppBar(
                      title: Text(
                        widget.title,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    url: "http://getir.safedevs.com/privacy",
                    hidden: true,
                    initialChild: LoadingPage(),
                  );
                }

                return LoadingPage();
              },
            );
          },
        ),
      ),
    );
  }
}
