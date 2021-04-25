import 'package:flutter/material.dart';


Future<void> showSuccess(BuildContext context, String message, {
  Duration duration = const Duration(milliseconds: 1500)
}) {
  return showMessage(context,
    message: message,
    icon: Icon(Icons.check_circle_outline, color: Colors.white,),
    backgroundColor: Colors.green,
    duration: duration
  );
}

Future<void> showError(BuildContext context, String message, {
  Duration duration = const Duration(milliseconds: 1500)
}) {
  return showMessage(context,
    message: message,
    icon: Icon(Icons.error_outline, color: Colors.white,),
    backgroundColor: Colors.red,
    duration: duration
  );
}

Future<void> showInfo(BuildContext context, String message, {
  Duration duration = const Duration(milliseconds: 1500)
}){
  return showMessage(context,
    message: message,
    icon: Icon(Icons.info_outline, color: Colors.white,),
    backgroundColor: Theme.of(context).primaryColor,
    duration: duration
  );
}

Future<void> showMessage(BuildContext context, {
  required String message,
  Icon? icon,
  Color? backgroundColor,
  Duration duration = const Duration(milliseconds: 1500)
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text.rich(TextSpan(
          children: [
            if (icon != null) WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(padding: EdgeInsets.only(right: 8), child: icon,)),
            TextSpan(text: message)
          ],
        ), style: Theme.of(context).primaryTextTheme.bodyText1,),
        backgroundColor: backgroundColor,
        duration: duration,
      )
  ).closed.then((value) {});
}