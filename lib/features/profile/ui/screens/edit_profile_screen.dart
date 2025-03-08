// file: lib/features/profile/ui/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/profile/ui/widgets/content_container.dart';
import 'package:united_formation_app/features/profile/ui/widgets/error_retry_widget.dart';
import 'package:united_formation_app/features/profile/ui/widgets/profile_avatar.dart';
import '../../../../core/core.dart';
import '../cubits/profile/profile_cubit.dart';
import '../cubits/profile/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final TextEditingController _phoneNumber2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final profile = context.read<ProfileCubit>().state.profile;
    if (profile != null) {
      _fullNameController.text = profile.fullName;
      _emailController.text = profile.email;
      _phoneNumber1Controller.text = profile.phoneNumber1 ?? '';
      _phoneNumber2Controller.text = profile.phoneNumber2 ?? '';
      _addressController.text = profile.address ?? '';
    }
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
      backgroundColor:
          context.isDarkMode ? AppColors.darkBackground : Colors.white,
      appBar: _buildAppBar(),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: _profileStateListener,
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state.isError && state.profile == null) {
            return ErrorRetryWidget(
              message: state.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            );
          }

          if (state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لم يتم العثور على بيانات الملف الشخصي',
                    style: TextStyle(
                      color: context.isDarkMode ? Colors.white : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().loadProfile(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return ContentContainer(child: _buildProfileForm(state));
        },
      ),
    );
  }

  // دالة حفظ الملف الشخصي
  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // إخفاء لوحة المفاتيح
      FocusScope.of(context).unfocus();

      // تنفيذ تحديث الملف الشخصي
      context.read<ProfileCubit>().updateProfile(
        fullName: _fullNameController.text,
        phoneNumber1: _phoneNumber1Controller.text,
        phoneNumber2: _phoneNumber2Controller.text,
        address: _addressController.text,
      );
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: AppColors.secondary),
      title: const Text(
        'الملف الشخصي',
        style: TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        // زر التحرير
        BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen:
              (previous, current) => previous.isEditing != current.isEditing,
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.isEditing ? Icons.close : Icons.edit,
                color: AppColors.secondary,
              ),
              onPressed: () {
                if (state.isEditing) {
                  context.read<ProfileCubit>().cancelEdit();
                  _initControllers();
                } else {
                  context.read<ProfileCubit>().toggleEditMode();
                }
              },
            );
          },
        ),
      ],
    );
  }

  void _profileStateListener(BuildContext context, ProfileState state) {
    if (state.isEditing && !_isEditing) {
      setState(() {
        _isEditing = true;
      });
    } else if (!state.isEditing && _isEditing) {
      setState(() {
        _isEditing = false;
      });
    }

    if (state.isSuccess && !state.isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث الملف الشخصي بنجاح'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
    }

    if (state.isError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'خطأ في تحديث الملف الشخصي'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
    }
  }

  Widget _buildProfileForm(ProfileState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الصورة الشخصية
            Center(
              child: ProfileAvatar(
                profileImageUrl: state.profile?.profileImageUrl,
                fullName: state.profile!.fullName,
                isEditing: state.isEditing,
                onImageTap:
                    state.isEditing
                        ? () {
                          // TODO: تنفيذ اختيار الصورة
                        }
                        : null,
              ),
            ),

            const SizedBox(height: 24),

            // حقل الاسم الكامل
            _buildFormField(
              label: 'الاسم الكامل',
              controller: _fullNameController,
              readOnly: !state.isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الاسم الكامل';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // حقل البريد الإلكتروني
            _buildFormField(
              label: 'البريد الإلكتروني',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              readOnly: true, // لا يمكن تغيير البريد
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال البريد الإلكتروني';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // حقل رقم الهاتف 1
            _buildFormField(
              label: 'رقم الهاتف 1',
              controller: _phoneNumber1Controller,
              keyboardType: TextInputType.phone,
              readOnly: !state.isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الهاتف';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // حقل رقم الهاتف 2
            _buildFormField(
              label: 'رقم الهاتف 2',
              controller: _phoneNumber2Controller,
              keyboardType: TextInputType.phone,
              readOnly: !state.isEditing,
              isOptional: true,
            ),

            const SizedBox(height: 16),

            // حقل العنوان
            _buildFormField(
              label: 'العنوان',
              controller: _addressController,
              maxLines: 3,
              readOnly: !state.isEditing,
              isOptional: true,
            ),

            const SizedBox(height: 24),

            // زر الحفظ (يظهر فقط في وضع التحرير)
            if (state.isEditing)
              ElevatedButton(
                onPressed: state.isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child:
                    state.isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
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
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    FormFieldValidator<String>? validator,
    int? maxLines = 1,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            if (isOptional)
              const Text(
                ' (اختياري)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          validator: validator,
          style: TextStyle(color: readOnly ? Colors.grey[700] : AppColors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? Colors.grey[100] : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
