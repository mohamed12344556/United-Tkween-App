// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/core.dart';
// import '../../domain/entities/profile_entity.dart';
// import '../cubits/edit_profile/edit_profile_cubit.dart';
// import '../cubits/edit_profile/edit_profile_state.dart';
// import '../cubits/profile/profile_cubit.dart';
// import '../widgets/profile_avatar.dart';

// class EditProfileView extends StatefulWidget {
//   const EditProfileView({super.key});

//   @override
//   State<EditProfileView> createState() => _EditProfileViewState();
// }

// class _EditProfileViewState extends State<EditProfileView> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneNumber1Controller = TextEditingController();
//   final TextEditingController _phoneNumber2Controller = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();

//   // متغير لتخزين الصورة المختارة
//   // File? _selectedImage;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   // final ImagePicker _imagePicker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     final state = context.read<EditProfileCubit>().state;
//     if (state.isInitial || state.profile == null) {
//       context.read<EditProfileCubit>().loadProfile();
//     } else {
//       _initControllers(state.profile!);
//     }
//   }

//   void _initControllers(ProfileEntity profile) {
//     _fullNameController.text = profile.fullName;
//     _emailController.text = profile.email;
//     _phoneNumber1Controller.text = profile.phoneNumber1 ?? '';
//     _phoneNumber2Controller.text = profile.phoneNumber2 ?? '';
//     _addressController.text = profile.address ?? '';
//   }

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneNumber1Controller.dispose();
//     _phoneNumber2Controller.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.darkBackground,
//       appBar: AppBar(
//         backgroundColor: AppColors.darkBackground,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Text(
//           'تعديل الملف الشخصي',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18.sp,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: BlocConsumer<EditProfileCubit, EditProfileState>(
//         listener: (context, state) {
//           if (state.isSuccess && state.isUpdated) {
//             // إشعار المستخدم بنجاح التحديث
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text('تم تحديث الملف الشخصي بنجاح'),
//                 backgroundColor: AppColors.success,
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 margin: EdgeInsets.all(16.r),
//               ),
//             );

//             // إضافة هذا السطر لإعلام ProfileCubit بالتحديث
//             context.read<ProfileCubit>().setProfileUpdated();

//             Navigator.of(context).pop(true);
//           }
//           if (state.isError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   state.errorMessage ?? 'خطأ في تحديث الملف الشخصي',
//                 ),
//                 backgroundColor: AppColors.error,
//                 behavior: SnackBarBehavior.floating,
//                 margin: EdgeInsets.all(16.r),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8.r)),
//                 ),
//               ),
//             );
//           }

//           if (state.isSuccess && state.profile != null) {
//             _initControllers(state.profile!);
//           }
//         },
//         builder: (context, state) {
//           if (state.isLoading && state.profile == null) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.primary,
//                 backgroundColor: AppColors.secondary.withValues(alpha: 51),
//               ),
//             );
//           }

//           if (state.isError && state.profile == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 60.r, color: AppColors.error),
//                   SizedBox(height: 16.h),
//                   Text(
//                     state.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
//                     style: TextStyle(color: Colors.white, fontSize: 16.sp),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 24.h),
//                   SizedBox(
//                     width: 200.w,
//                     child: ElevatedButton.icon(
//                       onPressed:
//                           () => context.read<EditProfileCubit>().loadProfile(),
//                       icon: Icon(Icons.refresh, size: 16.r),
//                       label: Text(
//                         'إعادة المحاولة',
//                         style: TextStyle(fontSize: 14.sp),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: AppColors.secondary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50.r),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 12.h),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (state.profile == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'لم يتم العثور على بيانات الملف الشخصي',
//                     style: TextStyle(color: Colors.white, fontSize: 16.sp),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 16.h),
//                   SizedBox(
//                     width: 200.w,
//                     child: ElevatedButton.icon(
//                       onPressed:
//                           () => context.read<EditProfileCubit>().loadProfile(),
//                       icon: Icon(Icons.refresh, size: 16.r),
//                       label: Text(
//                         'إعادة المحاولة',
//                         style: TextStyle(fontSize: 14.sp),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: AppColors.secondary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50.r),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 12.h),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return _buildProfileForm(state);
//         },
//       ),
//     );
//   }

//   Widget _buildProfileForm(EditProfileState state) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.r),
//       physics: const BouncingScrollPhysics(),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // صورة البروفايل مع الأحرف الأولى فقط
//             Center(
//               child: ProfileAvatar(
//                 fullName: state.profile!.fullName,
//                 radius: 60.r,
//                 backgroundColor: AppColors.darkSecondary,
//                 textColor: AppColors.primary,
//               ),
//             ),

//             SizedBox(height: 32.h),

//             // حقل الاسم الكامل
//             _buildTextField(
//               label: 'الاسم الكامل',
//               controller: _fullNameController,
//               prefixIcon: Icons.person,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'الرجاء إدخال الاسم الكامل';
//                 }
//                 return null;
//               },
//             ),

//             SizedBox(height: 16.h),

//             // حقل البريد الإلكتروني
//             _buildTextField(
//               label: 'البريد الإلكتروني',
//               controller: _emailController,
//               prefixIcon: Icons.email,
//               keyboardType: TextInputType.emailAddress,
//               readOnly: true,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'الرجاء إدخال البريد الإلكتروني';
//                 }
//                 return null;
//               },
//             ),

//             SizedBox(height: 16.h),

//             // حقل رقم الهاتف 1
//             _buildTextField(
//               label: 'رقم الهاتف 1',
//               controller: _phoneNumber1Controller,
//               prefixIcon: Icons.phone,
//               keyboardType: TextInputType.phone,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'الرجاء إدخال رقم الهاتف';
//                 }
//                 return null;
//               },
//             ),

//             SizedBox(height: 16.h),

//             // حقل العنوان
//             _buildTextField(
//               label: 'العنوان',
//               controller: _addressController,
//               prefixIcon: Icons.location_on,
//               maxLines: 3,
//               isOptional: true,
//             ),

//             SizedBox(height: 32.h),

//             // زر الحفظ
//             SizedBox(
//               height: 56.h,
//               child: ElevatedButton(
//                 onPressed: state.isLoading ? null : _saveProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: AppColors.secondary,
//                   disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50.r),
//                   ),
//                   padding: EdgeInsets.symmetric(vertical: 16.h),
//                 ),
//                 child:
//                     state.isLoading
//                         ? SizedBox(
//                           width: 24.r,
//                           height: 24.r,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.r,
//                             color: AppColors.secondary,
//                           ),
//                         )
//                         : Text(
//                           'حفظ التغييرات',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     required IconData prefixIcon,
//     TextInputType keyboardType = TextInputType.text,
//     bool readOnly = false,
//     bool isOptional = false,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8.h),
//       decoration: BoxDecoration(
//         color: AppColors.darkSurface,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         readOnly: readOnly,
//         maxLines: maxLines,
//         style: TextStyle(color: Colors.white, fontSize: 16.sp),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
//           prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: 22.r),
//           suffixIcon:
//               isOptional
//                   ? Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w),
//                     child: Text(
//                       '(اختياري)',
//                       style: TextStyle(
//                         color: Colors.grey[500],
//                         fontSize: 12.sp,
//                       ),
//                     ),
//                   )
//                   : null,
//           suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(color: Colors.grey[700]!, width: 1.r),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(color: AppColors.primary, width: 2.r),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(color: AppColors.error, width: 1.r),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(color: AppColors.error, width: 2.r),
//           ),
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 16.w,
//             vertical: maxLines > 1 ? 16.h : 0,
//           ),
//           fillColor: AppColors.darkSurface,
//           filled: true,
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   void _saveProfile() {
//     if (_formKey.currentState?.validate() ?? false) {
//       FocusScope.of(context).unfocus();
//       context.read<EditProfileCubit>().updateProfile(
//         fullName: _fullNameController.text,
//         phoneNumber1: _phoneNumber1Controller.text,
//         address: _addressController.text,
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubits/edit_profile/edit_profile_cubit.dart';
import '../cubits/edit_profile/edit_profile_state.dart';
import '../cubits/profile/profile_cubit.dart';
import '../widgets/profile_avatar.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final TextEditingController _phoneNumber2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final state = context.read<EditProfileCubit>().state;
    if (state.isInitial || state.profile == null) {
      context.read<EditProfileCubit>().loadProfile();
    } else {
      _initControllers(state.profile!);
    }
  }

  void _initControllers(ProfileEntity profile) {
    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneNumber1Controller.text = profile.phoneNumber1 ?? '';
    _phoneNumber2Controller.text = profile.phoneNumber2 ?? '';
    _addressController.text = profile.address ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumber1Controller.dispose();
    _phoneNumber2Controller.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.text),
        title: Text(
          S.of(context).editProfileTitle,
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.isSuccess && state.isUpdated) {
            // إشعار المستخدم بنجاح التحديث
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).updateSuccess),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.all(16.r),
              ),
            );

            // إضافة هذا السطر لإعلام ProfileCubit بالتحديث
            context.read<ProfileCubit>().setProfileUpdated();

            Navigator.of(context).pop(true);
          }
          if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? S.of(context).updateError,
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.r),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
              ),
            );
          }

          if (state.isSuccess && state.profile != null) {
            _initControllers(state.profile!);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.secondary.withValues(alpha: 51),
                strokeWidth: context.isTablet ? 3.0 : 2.0,
              ),
            );
          }

          if (state.isError && state.profile == null) {
            return _buildErrorState();
          }

          // إذا كانت البيانات غير متوفرة، نعرض نموذج فارغ
          if (state.profile == null) {
            return _buildEmptyProfileUI();
          }

          return _buildProfileForm(state);
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.r, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(
            S.of(context).loadError,
            style: TextStyle(color: AppColors.text, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 200.w,
            child: ElevatedButton.icon(
              onPressed: () => context.read<EditProfileCubit>().loadProfile(),
              icon: Icon(Icons.refresh, size: 16.r),
              label: Text(S.of(context).retry, style: TextStyle(fontSize: 14.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // نموذج فارغ للملف الشخصي
  Widget _buildEmptyProfileUI() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Center(
            child: ProfileAvatar(
              fullName: S.of(context).defaultUser,
              radius: 60.r,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              textColor: AppColors.primary,
            ),
          ),

          SizedBox(height: 32.h),
          _buildTextField(
            label: S.of(context).fullName,
            controller: TextEditingController(),
            prefixIcon: Icons.person,
          ),

          SizedBox(height: 16.h),
          _buildTextField(
            label: S.of(context).email,
            controller: TextEditingController(),
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
          ),

          // if (!Platform.isIOS) ...[
          //   SizedBox(height: 16.h),
          //   _buildTextField(
          //     label: 'رقم الهاتف 1',
          //     controller: TextEditingController(),
          //     prefixIcon: Icons.phone,
          //     keyboardType: TextInputType.phone,
          //   ),
          // ],
          SizedBox(height: 16.h),
          _buildTextField(
            label: '${S.of(context).phone} 1',
            controller: TextEditingController(),
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),

          // if (!Platform.isIOS) ...[
          //   SizedBox(height: 16.h),
          //   _buildTextField(
          //     label: 'العنوان',
          //     controller: TextEditingController(),
          //     prefixIcon: Icons.location_on,
          //     maxLines: 3,
          //     isOptional: true,
          //   ),
          // ],
          SizedBox(height: 16.h),
          _buildTextField(
            label: S.of(context).address,
            controller: TextEditingController(),
            prefixIcon: Icons.location_on,
            maxLines: 3,
            isOptional: true,
          ),

          SizedBox(height: 32.h),

          // زر الحفظ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 56.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  S.of(context).saveChanges,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(EditProfileState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة البروفايل مع الأحرف الأولى فقط
            Center(
              child: ProfileAvatar(
                fullName: state.profile!.fullName,
                radius: 60.r,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                textColor: AppColors.primary,
              ),
            ),

            SizedBox(height: 32.h),

            // حقل الاسم الكامل
            _buildTextField(
              label:   S.of(context).fullName,
              controller: _fullNameController,
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).enterFullName;
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // حقل البريد الإلكتروني
            _buildTextField(
              label: S.of(context).email,
              controller: _emailController,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).enterEmail;
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // حقل رقم الهاتف 1
            // if (!Platform.isIOS) ...[
            //   _buildTextField(
            //     label: 'رقم الهاتف 1',
            //     controller: _phoneNumber1Controller,
            //     prefixIcon: Icons.phone,
            //     keyboardType: TextInputType.phone,
            //     validator: (value) {
            //       if (value == null || value.isEmpty) {
            //         return 'الرجاء إدخال رقم الهاتف';
            //       }
            //       return null;
            //     },
            //   ),
            //   SizedBox(height: 16.h),
            // ],
            _buildTextField(
              label: 'رقم الهاتف',
              controller:
                  _phoneNumber1Controller.text == "1111111"
                      ? TextEditingController(text: "Not Entered Yet")
                      : _phoneNumber1Controller,
              prefixIcon: Icons.phone,
              isOptional: true,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).enterPhone;
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // حقل العنوان
            // if (!Platform.isIOS) ...[
            //   _buildTextField(
            //     label: 'العنوان',
            //     controller: _addressController,
            //     prefixIcon: Icons.location_on,
            //     maxLines: 3,
            //     isOptional: true,
            //   ),
            //   SizedBox(height: 32.h),
            // ],
            _buildTextField(
              label: S.of(context).address,
              controller:
                  _addressController.text == "Default Address"
                      ? TextEditingController(text: "Not Entered Yet")
                      : _addressController,
              prefixIcon: Icons.location_on,
              maxLines: 3,
              isOptional: true,
            ),
            SizedBox(height: 32.h),
            // زر الحفظ
            SizedBox(
              height: 56.h,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child:
                    state.isLoading
                        ? SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            backgroundColor: AppColors.secondary.withValues(
                              alpha: 51,
                            ),
                            strokeWidth: context.isTablet ? 3.0 : 2.0,
                          ),
                        )
                        : Text(
                          S.of(context).saveChanges,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    bool isOptional = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLines: maxLines,
        style: TextStyle(color: AppColors.text, fontSize: 16.sp),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: 22.r),
          suffixIcon:
              isOptional
                  ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      S.of(context).optional,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  )
                  : null,
          suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.transparent, width: 1.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.primary, width: 2.r),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.error, width: 1.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.error, width: 2.r),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: maxLines > 1 ? 16.h : 0,
          ),
          fillColor: AppColors.lightGrey,
          filled: true,
        ),
        validator: validator,
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<EditProfileCubit>().updateProfile(
        fullName: _fullNameController.text,
        phoneNumber1: _phoneNumber1Controller.text,
        address: _addressController.text,
      );
    }
  }
}
