// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class MethodsUtils {
//   static void copyToClipboard({
//     required BuildContext context,
//     required String text,
//   }) {
//     Clipboard.setData(ClipboardData(text: text));
//     showMessageAsSnackBar(
//       context: context,
//       infoType: InfoType.success,
//       message: AppLocalizations.of(context)!.copiedSuccessfully,
//     );
//   }
// }

// void showMessageAsSnackBar(
//     {required BuildContext context,
//     required InfoType infoType,
//     required String message}) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       backgroundColor: infoType.backgroundColor,
//       content: InfoDisplay(type: infoType, message: message),
//       duration: const Duration(seconds: 2),
//     ),
//   );
// }