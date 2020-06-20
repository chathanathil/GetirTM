import 'package:flutter/material.dart';
import '../../utils/dimens.dart';
import '../../widgets/common/caching_future_builder.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../common/loading_page.dart';
import '../../provider/home.dart';

class AboutPage extends StatelessWidget {
  final String path;
  final String title;

  AboutPage({this.path, this.title});

  static const routeName = 'about';

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

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
              futureFactory: () => HomeProvider.about(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return WebviewScaffold(
                    appBar: AppBar(
                      title: Text(
                        title,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    url: snapshot.data,
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
