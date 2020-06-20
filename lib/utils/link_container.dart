import 'package:flutter/material.dart';

Container createLinkContainer(
  BuildContext context,
  Widget item,
  Function handle,
) {
  return Container(
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return handle();
          }),
        );
      },
      child: item,
    ),
  );
}

Container createModalLinkContainer(
  BuildContext context,
  Widget item,
  Function handle,
) {
  return Container(
    child: GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (context) {
              return handle();
            });
      },
      child: item,
    ),
  );
}
