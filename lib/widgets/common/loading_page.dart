import 'package:flutter/material.dart';

import '../common/g_loading.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GLoading(),
      ),
    );
  }
}
