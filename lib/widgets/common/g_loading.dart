import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class GLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: FlareActor(
        'assets/images/g.flr',
        fit: BoxFit.contain,
        animation: 'g_logo',
      ),
    );
  }
}
