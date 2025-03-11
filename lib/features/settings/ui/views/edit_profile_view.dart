import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:united_formation_app/core/widgets/custom_form_field.dart';
import 'package:united_formation_app/features/settings/ui/widgets/image_source_option.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubits/edit_profile/edit_profile_state.dart';
import '../../../../core/core.dart';
import '../cubits/edit_profile/edit_profile_cubit.dart';
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

  // Add this variable to store selected image
  File? _selectedImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Create image picker instance
  final ImagePicker _imagePicker = ImagePicker();

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

  // Add this method to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text('حدث خطأ أثناء اختيار الصورة'),
      //     backgroundColor: AppColors.error,
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //     margin: const EdgeInsets.all(16),
      //   ),
      // );

      context.showErrorSnackBar('حدث خطاء اثناء اختيار الصورة');
    }
  }

  // Show image selection dialog

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'اختر صورة الملف الشخصي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageSourceOption(
                      icon: Icons.photo_library,
                      title: 'معرض الصور',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage();
                      },
                    ),
                    ImageSourceOption(
                      icon: Icons.delete,
                      title: 'إزالة الصورة',
                      onTap: () {
                        setState(() {
                          _selectedImage = null;
                        });
                        Navigator.pop(context);
                        // Here you would also notify your cubit to remove the profile image
                        // context.read<EditProfileCubit>().removeProfileImage();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[400],
                    ),
                    child: const Text('إلغاء'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('تم تحديث الملف الشخصي بنجاح'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
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
                margin: const EdgeInsets.all(16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
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
                backgroundColor: AppColors.secondary.withValues(
                  alpha: 51,
                ), // alpha 0.2
              ),
            );
          }

          if (state.isError && state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => context.read<EditProfileCubit>().loadProfile(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => context.read<EditProfileCubit>().loadProfile(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Image
            Center(
              child: ProfileAvatar(
                // If there's a selected image, show it; otherwise use the profile image URL
                profileImageUrl:
                    _selectedImage != null
                        ? null
                        : state.profile?.profileImageUrl,
                fullName: state.profile!.fullName,
                radius: 60,
                isEditing: true,
                backgroundColor: AppColors.darkSecondary,
                textColor: AppColors.primary,
                // Use the selected image file if available
                imageFile: _selectedImage,
                onImageTap: () {
                  _showImagePickerOptions();
                },
              ),
            ),

            const SizedBox(height: 32),

            // Full Name Field
            CustomFormField(
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

            const SizedBox(height: 16),

            // Email Field
            CustomFormField(
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

            const SizedBox(height: 16),

            // Phone Number 1 Field
            CustomFormField(
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

            const SizedBox(height: 16),

            // Phone Number 2 Field
            CustomFormField(
              label: 'رقم الهاتف 2',
              controller: _phoneNumber2Controller,
              prefixIcon: Icons.phone_android,
              keyboardType: TextInputType.phone,
              isOptional: true,
            ),

            const SizedBox(height: 16),

            // Address Field
            CustomFormField(
              label: 'العنوان',
              controller: _addressController,
              prefixIcon: Icons.location_on,
              maxLines: 3,
              isOptional: true,
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.secondary,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 128,
                  ), // alpha 0.5
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    state.isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.secondary,
                          ),
                        )
                        : const Text(
                          'حفظ التغييرات',
                          style: TextStyle(
                            fontSize: 16,
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

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<EditProfileCubit>().updateProfile(
        fullName: _fullNameController.text,
        phoneNumber1: _phoneNumber1Controller.text,
        phoneNumber2: _phoneNumber2Controller.text,
        address: _addressController.text,
        profileImage: _selectedImage, // Pass the selected image file
      );
    }
  }
}
