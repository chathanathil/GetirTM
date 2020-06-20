// import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './root.dart';
import './provider/provider.dart';

// class SimpleBlocDelegate extends BlocDelegate {
//   @override
//   void onEvent(Bloc bloc, Object event) {
//     super.onEvent(bloc, event);
//     print(event);
//   }

//   @override
//   void onTransition(Bloc bloc, Transition transition) {
//     super.onTransition(bloc, transition);
//     print(transition);
//   }

//   @override
//   void onError(Bloc bloc, Object error, StackTrace stacktrace) {
//     super.onError(bloc, error, stacktrace);
//     print(error);
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RootProvider.init();

  // debug or relase
  // if (!kReleaseMode) {
  //   BlocSupervisor.delegate = SimpleBlocDelegate();
  // }

  runApp(Root());
}
