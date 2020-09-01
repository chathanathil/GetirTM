import 'package:flutter/material.dart';
import './root.dart';
import './provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RootProvider.init();

  runApp(Root());
}

class DefaultHttpClientAdapter {}
