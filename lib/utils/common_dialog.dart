import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> appAdaptiveDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'OK',
  String Select = 'Select Potos',
  VoidCallback? onConfirm,
  String? cancelText,
  VoidCallback? onCancel,
  Color? confirmTextColor,
}) async {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoTheme(
        data: const CupertinoThemeData(brightness: Brightness.light),
        child: CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            content,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: <Widget>[
            if (cancelText != null)
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (onCancel != null) onCancel();
                },
                child: Text(
                  cancelText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (onConfirm != null) onConfirm();
              },
              isDefaultAction: true,
              child: Text(
                confirmText,
                style: TextStyle(
                  fontSize: 16,
                  color: confirmTextColor ?? Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (ctx) => Theme(
      data: ThemeData.light().copyWith(
        // dialogBackgroundColor: Theme.of(context).colorScheme.onSecondary,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
        ),
      ),
      child: AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: <Widget>[
          if (cancelText != null)
            TextButton(
              style: TextButton.styleFrom(
                alignment: Alignment.center,
                foregroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                if (onCancel != null) onCancel();
              },
              child: Text(
                cancelText,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.center,
              foregroundColor: confirmTextColor ?? Colors.blue,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onConfirm != null) onConfirm();
            },
            child: Text(
              confirmText,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> appLoadingDialog({
  required BuildContext context,
  String message = 'Please wait...',
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 15),
              Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
