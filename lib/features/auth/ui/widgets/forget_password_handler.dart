import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubits/password_reset/password_reset_cubit.dart';

class PasswordResetHandler {
  static void navigateToResetPassword(
    BuildContext context,
    String email,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(
          Routes.resetPasswordView,
          arguments: {'email': email},
        );
      }
    });
  }

  static Widget buildBlocConsumer({
    required BuildContext context,
    required Widget Function(BuildContext context, bool isLoading) buildContent,
  }) {
    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state is PasswordResetError) {
          if (context.mounted) {
            context.showErrorSnackBar(state.message);
          }
        } else if (state is PasswordResetSuccess) {
          if (context.mounted) {
            context.showSuccessSnackBar(
              context.localeS.password_reset_successful,
            );
            Navigator.of(context).pushReplacementNamed(Routes.loginView);
          }
        }
      },
      builder: (context, state) {
        return buildContent(
          context, 
          state is PasswordResetLoading
        );
      },
    );
  }
}