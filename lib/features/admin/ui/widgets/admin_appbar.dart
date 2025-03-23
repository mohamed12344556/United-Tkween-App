import 'package:flutter/material.dart';
import 'package:united_formation_app/core/themes/app_colors.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool isHasBackButtonOnAction ;

  const AdminAppBar({super.key, required this.title, this.actions ,this.isHasBackButtonOnAction =true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkBackground,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textColorWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        if(isHasBackButtonOnAction)
        Transform.rotate(
          angle:3.14159 ,
          child: BackButton(),),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
