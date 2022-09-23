import 'package:flutter/material.dart';

import 'constants.dart';

typedef AppRoute<T> = MaterialPageRoute<T>;

void showSnackBar(BuildContext context, {required String data, int durationInSecond = 3}) {
  final style = Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      content: Text(data, style: style),
      backgroundColor: AppColors.secondary,
      behavior: SnackBarBehavior.fixed,
      duration: Duration(seconds: durationInSecond),
    ),
  );
}

Future<T?> showLoader<T>(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () async => false,
      child: const Center(
        child: SizedBox(
          width: 48.0,
          height: 48.0,
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    ),
  );
}