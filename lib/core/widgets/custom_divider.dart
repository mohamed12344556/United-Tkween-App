import 'package:flutter/material.dart';
import '../core.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  final double? thickness;
  
  const CustomDivider({
    super.key,
    this.text = 'or',
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final dividerColor = isDark 
        ? Colors.grey[700] 
        : Colors.grey[400];
    
    final textColor = isDark 
        ? Colors.grey[300] 
        : Colors.grey[600];
    
    final responsiveThickness = thickness ?? context.screenHeight * 0.001;
    
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: responsiveThickness,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.04),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: context.screenWidth * 0.035,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: responsiveThickness,
          ),
        ),
      ],
    );
  }
}