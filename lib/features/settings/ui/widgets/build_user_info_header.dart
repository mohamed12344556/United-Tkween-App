// import 'package:flutter/material.dart';

// import '../../../../core/core.dart';

// class BuildUserInfoHeader extends StatelessWidget {
//   const BuildUserInfoHeader({
//     super.key,
//     required this.context,
//   });

//   final BuildContext context;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.darkSurface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: AppColors.primary,
//             child: const Text(
//               "AC",
//               style: TextStyle(
//                 color: AppColors.secondary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "أحمد المهندس",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "ahmed@example.com",
//                   style: TextStyle(color: Colors.grey[400], fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           TextButton.icon(
//             onPressed: () => context.navigateToNamed(Routes.editProfileView),
//             icon: Icon(Icons.edit, size: 16, color: AppColors.secondary),
//             label: const Text(
//               "تعديل",
//               style: TextStyle(
//                 color: AppColors.secondary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//             style: ButtonStyle(
//               backgroundColor: WidgetStateProperty.all(AppColors.primary),
//               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               padding: WidgetStateProperty.all<EdgeInsets>(
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../ui/cubits/profile/profile_cubit.dart';
import '../../ui/cubits/profile/profile_state.dart';

class BuildUserInfoHeader extends StatefulWidget {
  const BuildUserInfoHeader({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<BuildUserInfoHeader> createState() => _BuildUserInfoHeaderState();
}

class _BuildUserInfoHeaderState extends State<BuildUserInfoHeader> {
  @override
  void initState() {
    super.initState();
    // تحميل بيانات الملف الشخصي عند تهيئة الويدجت
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // تهيئة الأحجام المتجاوبة
    context.initResponsive();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // إذا كانت البيانات قيد التحميل
        if (state.isLoading) {
          return _buildLoadingHeader();
        }

        // إذا كان هناك خطأ في تحميل البيانات
        if (state.isError) {
          return _buildErrorHeader(state.errorMessage);
        }

        // إذا كانت البيانات متوفرة
        if (state.isSuccess && state.profile != null) {
          final profile = state.profile!;
          // استخراج الأحرف الأولى من الاسم
          final initials = _getInitials(profile.fullName);
          
          return _buildProfileHeader(profile.fullName, profile.email, initials);
        }

        // في حالة عدم وجود بيانات (الحالة الافتراضية)
        return _buildDefaultHeader();
      },
    );
  }

  // استخراج الأحرف الأولى من الاسم
  String _getInitials(String fullName) {
    if (fullName.isEmpty) return 'NA';
    
    List<String> names = fullName.trim().split(' ');
    if (names.length == 1) {
      return names[0].isNotEmpty ? names[0][0].toUpperCase() : 'N';
    } else {
      return names.length > 1
          ? (names[0].isNotEmpty ? names[0][0].toUpperCase() : 'N') +
              (names[1].isNotEmpty ? names[1][0].toUpperCase() : 'A')
          : 'NA';
    }
  }

  // واجهة التحميل
  Widget _buildLoadingHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة التحميل
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.darkSecondary,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.darkSecondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppColors.darkSecondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // واجهة الخطأ
  Widget _buildErrorHeader(String? errorMessage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red.withOpacity(0.2),
            child: Icon(Icons.error, color: Colors.red),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "حدث خطأ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  errorMessage ?? "خطأ في تحميل بيانات المستخدم",
                  style: TextStyle(color: Colors.red[300], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              if (mounted) {
                context.read<ProfileCubit>().loadProfile();
              }
            },
            icon: Icon(Icons.refresh, size: 16, color: AppColors.secondary),
            label: const Text(
              "إعادة المحاولة",
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.primary),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // واجهة افتراضية (لا توجد بيانات)
  Widget _buildDefaultHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: const Text(
              "NA",
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "المستخدم",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "user@example.com",
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () =>context.pushNamed(Routes.editProfileView),
            icon: Icon(Icons.edit, size: 16, color: AppColors.secondary),
            label: const Text(
              "تعديل",
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.primary),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // واجهة البيانات
  Widget _buildProfileHeader(String name, String email, String initials) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => widget.context.navigateToNamed(Routes.editProfileView),
            icon: Icon(Icons.edit, size: 16, color: AppColors.secondary),
            label: const Text(
              "تعديل",
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.primary),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}