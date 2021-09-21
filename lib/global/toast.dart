import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

FToast showToast(BuildContext context, String msg, {gravity = ToastGravity.BOTTOM, duration = const Duration(seconds: 2)}) {
  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0XFF48515B),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '$msg',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
    gravity: gravity,
    toastDuration: duration,
  );

  return fToast;
}
