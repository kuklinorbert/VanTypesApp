import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Center buildnoItems(BuildContext context) {
  return Center(
      child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(
        'assets/images/sad.png',
        color: Theme.of(context).colorScheme.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        height: MediaQuery.of(context).size.height * 0.13,
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'no_items'.tr(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
      )
    ],
  ));
}
