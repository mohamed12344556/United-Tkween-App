import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:united_formation_app/core/widgets/connection_wrapper.dart';
import 'package:united_formation_app/features/admin/ui/cubits/add_product/add_product_admin_cubit.dart';
import 'package:united_formation_app/features/admin/ui/cubits/edit_product/edit_product_admin_cubit.dart';
import 'package:united_formation_app/features/admin/ui/cubits/orders/orders_admin_cubit.dart';
import 'package:united_formation_app/features/admin/ui/cubits/products/products_admin_cubit.dart';
import 'package:united_formation_app/features/admin/ui/cubits/support/support_admin_cubit.dart';
import 'package:united_formation_app/features/admin/ui/views/add_product_admin_view.dart';
import 'package:united_formation_app/features/admin/ui/views/edit_product_admin_view.dart';
import 'package:united_formation_app/features/admin/ui/views/order_details_admin_view.dart';
import 'package:united_formation_app/features/admin/ui/views/products_admin_view.dart';
import 'package:united_formation_app/features/admin/ui/views/support_chat_admin_view.dart';
import 'package:united_formation_app/features/cart/presentation/logic/purchase_cubit.dart';
import 'package:united_formation_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';
import 'package:united_formation_app/features/settings/ui/cubits/library/library_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/orders/orders_cubit.dart';
import 'package:united_formation_app/features/settings/ui/views/library_view.dart';
import 'package:united_formation_app/features/settings/ui/views/orders_view.dart';
import 'package:united_formation_app/features/settings/ui/views/profile_view.dart';
import 'package:united_formation_app/features/settings/ui/views/settings_view.dart';

import '../../features/admin/data/models/product_model.dart';
import '../../features/admin/ui/views/orders_admin_view.dart';
import '../../features/admin/ui/views/support_admin_view.dart';
import '../../features/auth/ui/cubits/learning_options/learning_options_cubit.dart';
import '../../features/auth/ui/cubits/login/login_cubit.dart';
import '../../features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
import '../../features/auth/ui/cubits/register/register_cubit.dart';
import '../../features/auth/ui/pages/learning_options_page.dart';
import '../../features/auth/ui/pages/login_page.dart';
import '../../features/auth/ui/pages/register_page.dart';
import '../../features/auth/ui/pages/reset_password_page.dart';
import '../../features/cart/data/models/cart_model.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/cart/presentation/pages/order_summary_page.dart';
import '../../features/home/ui/pages/host_screen.dart';
import '../../features/home/ui/pages/product_details_page.dart';
import '../../features/settings/ui/cubits/edit_profile/edit_profile_cubit.dart';
import '../../features/settings/ui/cubits/profile/profile_cubit.dart';
import '../../features/settings/ui/cubits/support/support_cubit.dart';
import '../../features/settings/ui/views/edit_profile_view.dart';
import '../../features/settings/ui/views/support_view.dart';
import 'routes.dart';

final sl = GetIt.instance;

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loginView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) {
                  final cubit = sl<LoginCubit>();

                  if (arguments is Map &&
                      arguments.containsKey('fresh_start')) {
                    cubit.resetState();
                  }

                  return cubit;
                },
                child: ConnectionWrapper(child: const LoginPage()),
              ),
        );

      case Routes.registerView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<RegisterCubit>(),
                child: ConnectionWrapper(child: const RegisterPage()),
              ),
        );

      case Routes.learningOptionsView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<LearningOptionsCubit>(),
                child: ConnectionWrapper(child: const LearningOptionsPage()),
              ),
        );

      case Routes.resetPasswordView:
        String email = "";
        if (arguments is Map) {
          email = (arguments['email'] ?? "") as String;
        }
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) {
                  final cubit = sl<PasswordResetCubit>();
                  cubit.setEmail(email);
                  return cubit;
                },
                child: ConnectionWrapper(
                  child: ResetPasswordPage(email: email),
                ),
              ),
        );

      // Settings Routes
      case Routes.settingsView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ConnectionWrapper(child: const SettingsView()),
        );

      case Routes.profileView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<ProfileCubit>(),
                child: ConnectionWrapper(child: const ProfileView()),
              ),
        );

      case Routes.editProfileView:
        final profileCubit = arguments is ProfileCubit ? arguments : null;

        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => sl<EditProfileCubit>()),
                  if (profileCubit != null)
                    BlocProvider.value(value: profileCubit)
                  else
                    BlocProvider(create: (_) => sl<ProfileCubit>()),
                ],
                child: ConnectionWrapper(child: const EditProfileView()),
              ),
        );

      case Routes.ordersView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<OrdersCubit>(),
                child: ConnectionWrapper(child: const OrdersView()),
              ),
        );

      case Routes.libraryView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<LibraryCubit>(),
                child: ConnectionWrapper(child: const LibraryView()),
              ),
        );

      case Routes.supportView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<SupportCubit>(),
                child: ConnectionWrapper(child: const SupportView()),
              ),
        );

      case Routes.hostView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ConnectionWrapper(child: const HostPage()),
        );

      case Routes.productDetailsView:
        BookModel bookModel = arguments as BookModel;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) =>
                  ConnectionWrapper(child: ProductDetailsPage(book: bookModel)),
        );

      case Routes.cartView:
        ProductModel product = arguments as ProductModel;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ConnectionWrapper(child: CartPage()),
        );

      case Routes.orderSummaryView:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: sl<ProfileCubit>()),
                  BlocProvider.value(value: sl<OrdersCubit>()),
                  BlocProvider(
                    create: (_) => sl<CreatePurchaseCubit>(),
                  ), // Add this
                ],
                child: ConnectionWrapper(
                  child: OrderSummaryPage(
                    cartItems: args['cartItems'] as List<CartItemModel>,
                    subtotal: args['subtotal'] as int,
                    shippingCost: args['shippingCost'] as int,
                    totalAmount: args['totalAmount'] as int,
                    // Remove the hardcoded tapPaymentUrl - it will be handled dynamically
                  ),
                ),
              ),
        );

      case Routes.adminOrdersView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<OrdersAdminCubit>(),
                child: ConnectionWrapper(child: const OrdersAdminView()),
              ),
        );

      case Routes.adminOrderDetailsView:
        final args = settings.arguments as Map<String, dynamic>;
        final orderId = args['orderId'] as String;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<OrdersAdminCubit>(),
                child: ConnectionWrapper(
                  child: OrderDetailsAdminView(orderId: orderId),
                ),
              ),
        );

      case Routes.adminProductsView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<ProductsAdminCubit>(),
                child: ConnectionWrapper(child: const ProductsAdminView()),
              ),
        );

      case Routes.adminAddProductView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<AddProductAdminCubit>(),
                child: ConnectionWrapper(child: const AddProductAdminView()),
              ),
        );

      case Routes.adminEditProductView:
        if (settings.arguments == null) {
          // الانتقال إلى صفحة إضافة منتج جديد
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) => BlocProvider(
                  create: (context) => sl<AddProductAdminCubit>(),
                  child: ConnectionWrapper(child: const AddProductAdminView()),
                ),
          );
        }

        // في حالة وجود منتج، انتقل إلى صفحة التعديل
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<EditProductAdminCubit>(),
                child: ConnectionWrapper(
                  child: EditProductAdminView(product: product),
                ),
              ),
        );

      case Routes.adminSupportView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<SupportAdminCubit>(),
                child: ConnectionWrapper(child: const SupportAdminView()),
              ),
        );

      case Routes.adminSupportChatView:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<SupportAdminCubit>(),
                child: ConnectionWrapper(
                  child: SupportChatAdminView(
                    customerId: args['customerId']!,
                    customerName: args['customerName']!,
                  ),
                ),
              ),
        );

      case Routes.favoritesView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<SupportAdminCubit>(),
                child: ConnectionWrapper(child: FavoritesView()),
              ),
        );

      // default:
      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder:
      //         (_) => Scaffold(
      //           body: Center(
      //             child: Text('No route defined for ${settings.name}'),
      //           ),
      //         ),
      //   );
    }
    return null;
  }
}
