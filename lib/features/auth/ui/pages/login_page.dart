// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:united_formation_app/core/core.dart';
// import '../../data/services/guest_mode_manager.dart';
// import '../cubits/login/login_cubit.dart';
// import '../widgets/auth_header.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _isGuestLoginLoading = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     ResponsiveSize.init(context);

//     final args = ModalRoute.of(context)?.settings.arguments;
//     if (args is Map &&
//         args.containsKey('fresh_start') &&
//         args['fresh_start'] == true) {
//       if (mounted) {
//         context.read<LoginCubit>().resetState();
//       }
//     }
//   }

//   // تسجيل الدخول كضيف
//   Future<void> _loginAsGuest() async {
//     if (_isGuestLoginLoading) return;

//     setState(() {
//       _isGuestLoginLoading = true;
//     });

//     try {
//       await GuestModeManager.loginAsGuest();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('تم تسجيل الدخول كضيف'),
//             backgroundColor: AppColors.success,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             margin: EdgeInsets.all(16.r),
//           ),
//         );

//         Navigator.of(
//           context,
//         ).pushNamedAndRemoveUntil(Routes.hostView, (route) => false);
//       }
//     } catch (e) {
//       debugPrint('Error logging in as guest: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('حدث خطأ أثناء تسجيل الدخول كضيف'),
//             backgroundColor: AppColors.error,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             margin: EdgeInsets.all(16.r),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isGuestLoginLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final horizontalPadding = 10.w;
//     final verticalSpacing = 10.h;
//     final isDark = context.isDarkMode;

//     return BlocConsumer<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state is LoginSuccess) {
//           if (mounted) {
//             context.showSuccessSnackBar(context.localeS.login_successful);
//             Future.microtask(() {
//               if (mounted) {
//                 Navigator.of(
//                   context,
//                 ).pushNamedAndRemoveUntil(Routes.hostView, (route) => false);
//               }
//             });
//           }
//         } else if (state is LoginError) {
//           if (mounted) {
//             context.showErrorSnackBar(state.errorMessage);
//           }
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.watch<LoginCubit>();
//         return Scaffold(
//           body: SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: horizontalPadding * 2,
//                   vertical: verticalSpacing * 2,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // رأس صفحة المصادقة
//                     AuthHeader(
//                       title: context.localeS.welcome_back,
//                       subtitle:
//                           context
//                               .localeS
//                               .we_happy_to_see_you_here_again_enter_your_email_address_and_password,
//                     ),

//                     // حقل البريد الإلكتروني
//                     AppTextField(
//                       controller: cubit.emailController,
//                       hintText: context.localeS.email,
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     SizedBox(height: verticalSpacing),

//                     // حقل كلمة المرور
//                     AppTextField(
//                       controller: cubit.passwordController,
//                       hintText: context.localeS.password,
//                       isPassword: true,
//                       passwordVisible: cubit.isPasswordVisible,
//                       onTogglePasswordVisibility:
//                           cubit.togglePasswordVisibility,
//                     ),
//                     SizedBox(height: verticalSpacing * 2),

//                     // زر تسجيل الدخول
//                     AppButton(
//                       text: context.localeS.log_in,
//                       backgroundColor: AppColors.primary,
//                       textColor: Colors.black,
//                       isLoading: state is LoginLoading,
//                       onPressed: () {
//                         FocusScope.of(context).unfocus();
//                         if (mounted) {
//                           cubit.login(
//                             email: cubit.emailController.text.trim(),
//                             password: cubit.passwordController.text,
//                             context: context,
//                           );
//                         }
//                       },
//                     ),

//                     // رابط نسيت كلمة المرور
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           if (mounted) {
//                             // تم تغيير المسار من Routes.requestOtpView إلى Routes.resetPasswordView
//                             Navigator.of(context).pushNamed(
//                               Routes.resetPasswordView,
//                               arguments: {
//                                 'email': cubit.emailController.text.trim(),
//                               },
//                             );
//                           }
//                         },
//                         child: Text(
//                           context.localeS.forgot_password,
//                           style: TextStyle(
//                             color: Colors.grey[300],
//                             fontSize: 12.w,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: verticalSpacing * 0.5),

//                     // فاصل "أو"
//                     CustomDivider(text: context.localeS.or),
//                     SizedBox(height: verticalSpacing),

//                     // إضافة زر تصفح كضيف
//                     AppButton(
//                       text: context.localeS.browse_as_guest,
//                       backgroundColor: Colors.grey[800]!,
//                       textColor: Colors.white,
//                       isLoading: _isGuestLoginLoading,
//                       icon: Icons.person_outline,
//                       onPressed: _loginAsGuest,
//                     ),

//                     SizedBox(height: verticalSpacing),

//                     // زر إنشاء حساب جديد
//                     AppButton(
//                       text: context.localeS.create_account,
//                       backgroundColor:
//                           isDark ? AppColors.darkSecondary : Colors.black,
//                       textColor: Colors.white,
//                       onPressed: () {
//                         if (mounted) {
//                           Navigator.of(context).pushNamed(Routes.registerView);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/home/ui/pages/product_details_page.dart';
import '../../../../core/app_links/deep_link_manager.dart';
import '../../../../united_tkween_group_app.dart';
import '../../../home/ui/pages/host_screen.dart';
import '../../data/services/guest_mode_manager.dart';
import '../cubits/login/login_cubit.dart';
import '../widgets/auth_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isGuestLoginLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ResponsiveSize.init(context);

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map &&
        args.containsKey('fresh_start') &&
        args['fresh_start'] == true) {
      if (mounted) {
        context.read<LoginCubit>().resetState();
      }
    }
  }

  Future<void> _loginAsGuest() async {
    if (_isGuestLoginLoading) return;

    setState(() {
      _isGuestLoginLoading = true;
    });

    try {
      await GuestModeManager.loginAsGuest();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم تسجيل الدخول كضيف'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.r),
          ),
        );

        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.hostView, (route) => false);
      }
    } catch (e) {
      debugPrint('Error logging in as guest: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('حدث خطأ أثناء تسجيل الدخول كضيف'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.r),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGuestLoginLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = 10.w;
    final verticalSpacing = 10.h;
    final isDark = context.isDarkMode;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          print("✅ Login successful, checking pending deep link...");

          final pendingId = DeepLinkManager.consumePendingChallenge();
          print("📦 Consumed pending ID after login: $pendingId");

          if (pendingId != null) {
            print("🚀 Opening product from deep link after login...");
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HostPage()),
              (route) => false,
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailsPage(bookId: pendingId),
              ),
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HostPage()),
              (route) => false,
            );
          }
        }
      },
      builder: (context, state) {
        final cubit = context.watch<LoginCubit>();
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 2,
                  vertical: verticalSpacing * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // رأس صفحة المصادقة
                    AuthHeader(
                      title: context.localeS.welcome_back,
                      subtitle:
                          context
                              .localeS
                              .we_happy_to_see_you_here_again_enter_your_email_address_and_password,
                    ),

                    // حقل البريد الإلكتروني
                    AppTextField(
                      controller: cubit.emailController,
                      hintText: context.localeS.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: verticalSpacing),

                    // حقل كلمة المرور
                    AppTextField(
                      controller: cubit.passwordController,
                      hintText: context.localeS.password,
                      isPassword: true,
                      passwordVisible: cubit.isPasswordVisible,
                      onTogglePasswordVisibility:
                          cubit.togglePasswordVisibility,
                    ),
                    SizedBox(height: verticalSpacing * 2),

                    // زر تسجيل الدخول
                    AppButton(
                      text: context.localeS.log_in,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                      isLoading: state is LoginLoading,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (mounted) {
                          cubit.login(
                            email: cubit.emailController.text.trim(),
                            password: cubit.passwordController.text,
                            context: context,
                          );
                        }
                      },
                    ),

                    // رابط نسيت كلمة المرور
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          if (mounted) {
                            // تم تغيير المسار من Routes.requestOtpView إلى Routes.resetPasswordView
                            Navigator.of(context).pushNamed(
                              Routes.resetPasswordView,
                              arguments: {
                                'email': cubit.emailController.text.trim(),
                              },
                            );
                          }
                        },
                        child: Text(
                          context.localeS.forgot_password,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),

                    // فاصل "أو"
                    CustomDivider(text: context.localeS.or),
                    SizedBox(height: verticalSpacing),

                    // إضافة زر تصفح كضيف
                    AppButton(
                      text: context.localeS.browse_as_guest,
                      backgroundColor: AppColors.darkSecondary,
                      textColor: Colors.white,
                      isLoading: _isGuestLoginLoading,
                      icon: Icons.person_outline,
                      onPressed: _loginAsGuest,
                    ),

                    SizedBox(height: verticalSpacing),

                    // زر إنشاء حساب جديد
                    AppButton(
                      text: context.localeS.create_account,
                      backgroundColor: AppColors.secondary,
                      textColor: Colors.white,
                      onPressed: () {
                        if (mounted) {
                          Navigator.of(context).pushNamed(Routes.registerView);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
