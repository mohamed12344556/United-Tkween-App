import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
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

  // متغير لتخزين الصورة المختارة
  // File? _selectedImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final ImagePicker _imagePicker = ImagePicker();

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

  // // اختيار صورة من المعرض
  // Future<void> _pickImage() async {
  //   try {
  //     final XFile? pickedImage = await _imagePicker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 80,
  //     );

  //     if (pickedImage != null) {
  //       setState(() {
  //         _selectedImage = File(pickedImage.path);
  //       });
  //     }
  //   } catch (e) {
  //     context.showErrorSnackBar('حدث خطأ أثناء اختيار الصورة');
  //   }
  // }

  // // عرض خيارات اختيار الصورة
  // void _showImagePickerOptions() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: AppColors.darkSurface,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //     ),
  //     builder:
  //         (context) => Padding(
  //           padding: EdgeInsets.all(20.r),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'اختر صورة الملف الشخصي',
  //                 style: TextStyle(
  //                   fontSize: 18.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               SizedBox(height: 20.h),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   _buildImageOption(
  //                     icon: Icons.photo_library,
  //                     title: 'معرض الصور',
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                       _pickImage();
  //                     },
  //                   ),
  //                   _buildImageOption(
  //                     icon: Icons.delete,
  //                     title: 'إزالة الصورة',
  //                     onTap: () {
  //                       setState(() {
  //                         _selectedImage = null;
  //                       });
  //                       Navigator.pop(context);
  //                       context.read<EditProfileCubit>().removeProfileImage();
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 16.h),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   style: TextButton.styleFrom(
  //                     foregroundColor: Colors.grey[400],
  //                   ),
  //                   child: const Text('إلغاء'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //   );
  // }

  // Widget _buildImageOption({
  //   required IconData icon,
  //   required String title,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Container(
  //           width: 60.r,
  //           height: 60.r,
  //           decoration: BoxDecoration(
  //             color: AppColors.darkSecondary,
  //             shape: BoxShape.circle,
  //           ),
  //           child: Icon(icon, color: AppColors.primary, size: 30.r),
  //         ),
  //         SizedBox(height: 8.h),
  //         Text(title, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: Colors.white,
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
                content: const Text('تم تحديث الملف الشخصي بنجاح'),
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

            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
          }

          if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'خطأ في تحديث الملف الشخصي',
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
              ),
            );
          }

          if (state.isError && state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60.r, color: AppColors.error),
                  SizedBox(height: 16.h),
                  Text(
                    state.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: 200.w,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => context.read<EditProfileCubit>().loadProfile(),
                      icon: Icon(Icons.refresh, size: 16.r),
                      label: Text(
                        'إعادة المحاولة',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
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

          if (state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لم يتم العثور على بيانات الملف الشخصي',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 200.w,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => context.read<EditProfileCubit>().loadProfile(),
                      icon: Icon(Icons.refresh, size: 16.r),
                      label: Text(
                        'إعادة المحاولة',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
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

          return _buildProfileForm(state);
        },
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
                backgroundColor: AppColors.darkSecondary,
                textColor: AppColors.primary,
              ),
            ),

            SizedBox(height: 32.h),

            // حقل الاسم الكامل
            _buildTextField(
              label: 'الاسم الكامل',
              controller: _fullNameController,
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الاسم الكامل';
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // حقل البريد الإلكتروني
            _buildTextField(
              label: 'البريد الإلكتروني',
              controller: _emailController,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال البريد الإلكتروني';
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // حقل رقم الهاتف 1
            _buildTextField(
              label: 'رقم الهاتف 1',
              controller: _phoneNumber1Controller,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الهاتف';
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // حقل العنوان
            _buildTextField(
              label: 'العنوان',
              controller: _addressController,
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
                  foregroundColor: AppColors.secondary,
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
                            strokeWidth: 2.r,
                            color: AppColors.secondary,
                          ),
                        )
                        : Text(
                          'حفظ التغييرات',
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
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
          prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: 22.r),
          suffixIcon:
              isOptional
                  ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      '(اختياري)',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12.sp,
                      ),
                    ),
                  )
                  : null,
          suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey[700]!, width: 1.r),
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
          fillColor: AppColors.darkSurface,
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
