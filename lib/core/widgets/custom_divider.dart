// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';
import '../core.dart';

class CustomDivider extends StatelessWidget {
  final String? text;
  final Color? dividerColor;
  final double? dividerThickness;
  final TextStyle? textStyle;

  const CustomDivider({
    super.key,
    this.text,
    this.dividerColor,
    this.dividerThickness,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: dividerColor ?? Colors.grey,
            thickness: dividerThickness ?? 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
          ),
          child: Text(
            text ?? LocaleKeys.or.tr(),
            style:
                textStyle ??
                TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor ?? Colors.grey,
            thickness: dividerThickness ?? 0.5,
          ),
        ),
      ],
    );
  }
}
