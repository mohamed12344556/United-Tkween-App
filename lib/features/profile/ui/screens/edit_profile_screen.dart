import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(
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
          // Edit toggle button
          BlocBuilder<ProfileCubit, ProfileState>(
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
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
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
              ),
            );
          }

          if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'خطأ في تحديث الملف الشخصي',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
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

          return Container(
            color: AppColors.primary,
            child: Column(
              children: [
                // Profile form in white container
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Profile avatar
                            Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage:
                                        state.profile?.profileImageUrl != null
                                            ? NetworkImage(
                                              state.profile!.profileImageUrl!,
                                            )
                                            : null,
                                    child:
                                        state.profile?.profileImageUrl == null
                                            ? Text(
                                              _getAvatarText(
                                                state.profile!.fullName,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textSecondary,
                                              ),
                                            )
                                            : null,
                                  ),
                                  if (state.isEditing)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            color: AppColors.secondary,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            // TODO: Implement image picker
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Full name field
                            const Text(
                              'الاسم الكامل',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppTextField(
                              controller: _fullNameController,
                              hintText: 'أدخل الاسم الكامل',
                              readOnly: !state.isEditing,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال الاسم الكامل';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Email field
                            const Text(
                              'البريد الإلكتروني',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppTextField(
                              controller: _emailController,
                              hintText: 'أدخل البريد الإلكتروني',
                              keyboardType: TextInputType.emailAddress,
                              readOnly:
                                  !state.isEditing, // Email can't be changed
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال البريد الإلكتروني';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Phone number 1 field
                            const Text(
                              'رقم الهاتف 1',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppTextField(
                              controller: _phoneNumber1Controller,
                              hintText: 'أدخل رقم الهاتف الأساسي',
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

                            // Phone number 2 field
                            const Text(
                              'رقم الهاتف 2',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppTextField(
                              controller: _phoneNumber2Controller,
                              hintText: 'أدخل رقم الهاتف الإضافي (اختياري)',
                              keyboardType: TextInputType.phone,
                              readOnly: !state.isEditing,
                            ),

                            const SizedBox(height: 16),

                            // Address field
                            const Text(
                              'العنوان',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppTextField(
                              controller: _addressController,
                              hintText: 'أدخل العنوان',
                              maxLines: 3,
                              readOnly: !state.isEditing,
                            ),

                            const SizedBox(height: 24),

                            // Save button (only shown when editing)
                            if (state.isEditing)
                              ElevatedButton(
                                onPressed:
                                    state.isLoading ? null : _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
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
                                          child:
                                              CircularProgressIndicator.adaptive(
                                                // color: AppColors.primary,
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
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileCubit>().updateProfile(
        fullName: _fullNameController.text,
        phoneNumber1: _phoneNumber1Controller.text,
        phoneNumber2: _phoneNumber2Controller.text,
        address: _addressController.text,
      );
    }
  }

  String _getAvatarText(String fullName) {
    if (fullName.isEmpty) return '';

    final nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0];
    }

    return fullName.substring(0, fullName.length > 2 ? 2 : fullName.length);
  }
}
