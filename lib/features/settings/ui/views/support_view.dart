// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/core.dart';
// import '../cubits/support/support_cubit.dart';
// import '../cubits/support/support_state.dart';
// import '../widgets/support_message_input.dart';

// class SupportView extends StatefulWidget {
//   const SupportView({super.key});

//   @override
//   State<SupportView> createState() => _SupportViewState();
// }

// class _SupportViewState extends State<SupportView> {
//   final TextEditingController _messageController = TextEditingController();
//   final FocusNode _messageFocusNode = FocusNode();
//   final List<String> _supportOptions = [
//     'استفسار عن منتج',
//     'مشكلة في الطلب',
//     'اقتراح',
//     'شكوى',
//     'أخرى',
//   ];
//   String _selectedOption = 'استفسار عن منتج';

//   @override
//   void initState() {
//     super.initState();
//     context.read<SupportCubit>().resetState();
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _messageFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.darkBackground,
//       appBar: AppBar(
//         backgroundColor: AppColors.darkBackground,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'دعم المتجر',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: BlocConsumer<SupportCubit, SupportState>(
//         listener: _supportStateListener,
//         builder: (context, state) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildSupportHeader(),
//               _buildSupportOptions(),
//               Expanded(child: _buildMessageInput(state)),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _supportStateListener(BuildContext context, SupportState state) {
//     if (state.isSuccess && state.messageSent) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('تم إرسال رسالتك بنجاح'),
//           backgroundColor: AppColors.success,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//       _messageController.clear();
//     }

//     if (state.isError) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(state.errorMessage ?? 'خطأ في إرسال الرسالة'),
//           backgroundColor: AppColors.error,
//           behavior: SnackBarBehavior.floating,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//     }
//   }

//   Widget _buildSupportHeader() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//           Hero(
//             tag: 'support_icon',
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: AppColors.darkSurface,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary,
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.headset_mic,
//                 size: 40,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'كيف يمكننا مساعدتك؟',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'يمكنك ارسال استفسارك وسنرد عليك في أقرب وقت',
//             style: TextStyle(fontSize: 16, color: Colors.grey[400]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSupportOptions() {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _supportOptions.length,
//         itemBuilder: (context, index) {
//           final option = _supportOptions[index];
//           final isSelected = option == _selectedOption;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedOption = option;
//               });
//             },
//             child: Container(
//               margin: const EdgeInsets.only(right: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColors.primary : AppColors.darkSurface,
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(
//                   color: isSelected ? AppColors.primary : Colors.grey[700]!,
//                   width: 1,
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 option,
//                 style: TextStyle(
//                   color: isSelected ? AppColors.secondary : Colors.white,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMessageInput(SupportState state) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SupportMessageInput(
//         controller: _messageController,
//         focusNode: _messageFocusNode,
//         onChanged: (value) {
//           context.read<SupportCubit>().updateMessage(value);
//         },
//         isLoading: state.isLoading,
//         onSend: () {
//           FocusScope.of(context).unfocus();
//           context.read<SupportCubit>().sendMessage();
//         },
//         hintText: 'اكتب رسالتك هنا...',
//         sendButtonText: 'إرسال الرسالة',
//       ),
//     );
//   }
// }
//!
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/core.dart';
// import '../cubits/support/support_cubit.dart';
// import '../cubits/support/support_state.dart';
// import '../widgets/support_message_input.dart';

// class SupportView extends StatefulWidget {
//   const SupportView({super.key});

//   @override
//   State<SupportView> createState() => _SupportViewState();
// }

// class _SupportViewState extends State<SupportView> {
//   final TextEditingController _messageController = TextEditingController();
//   final FocusNode _messageFocusNode = FocusNode();
//   final List<String> _supportOptions = [
//     'استفسار عن منتج',
//     'مشكلة في الطلب',
//     'اقتراح',
//     'شكوى',
//     'أخرى',
//   ];
//   String _selectedOption = 'استفسار عن منتج';

//   @override
//   void initState() {
//     super.initState();
//     context.read<SupportCubit>().resetState();
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _messageFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'دعم المكتبة',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//         ),
//       ),
//       body: BlocConsumer<SupportCubit, SupportState>(
//         listener: _supportStateListener,
//         builder: (context, state) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildSupportHeader(),
//               _buildSupportOptions(),
//               Expanded(child: _buildMessageInput(state)),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _supportStateListener(BuildContext context, SupportState state) {
//     if (state.isSuccess && state.messageSent) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('تم إرسال رسالتك بنجاح'),
//           backgroundColor: AppColors.success,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//       _messageController.clear();
//     }

//     if (state.isError) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(state.errorMessage ?? 'خطأ في إرسال الرسالة'),
//           backgroundColor: AppColors.error,
//           behavior: SnackBarBehavior.floating,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//     }
//   }

//   Widget _buildSupportHeader() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//           Hero(
//             tag: 'support_icon',
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: AppColors.lightGrey,
//                 shape: BoxShape.circle,
//                 boxShadow: [BoxShadow(color: AppColors.primary, blurRadius: 4)],
//               ),
//               child: Icon(
//                 Icons.headset_mic,
//                 size: 40,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'كيف يمكننا مساعدتك؟',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'يمكنك ارسال استفسارك وسنرد عليك في أقرب وقت',
//             style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSupportOptions() {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _supportOptions.length,
//         itemBuilder: (context, index) {
//           final option = _supportOptions[index];
//           final isSelected = option == _selectedOption;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedOption = option;
//               });
//             },
//             child: Container(
//               margin: const EdgeInsets.only(right: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColors.primary : Colors.white,
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(
//                   color: isSelected ? AppColors.primary : Colors.grey[700]!,
//                   width: 1,
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 option,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : AppColors.text,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMessageInput(SupportState state) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SupportMessageInput(
//         controller: _messageController,
//         focusNode: _messageFocusNode,
//         onChanged: (value) {
//           context.read<SupportCubit>().updateMessage(value);
//         },
//         isLoading: state.isLoading,
//         onSend: () {
//           FocusScope.of(context).unfocus();
//           context.read<SupportCubit>().sendMessage();
//         },
//         hintText: 'اكتب رسالتك هنا...',
//         sendButtonText: 'إرسال الرسالة',
//       ),
//     );
//   }
// }
//!

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubits/support/support_cubit.dart';
import '../cubits/support/support_state.dart';
import '../widgets/support_message_input.dart';
import '../../../../generated/l10n.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<Map<String, dynamic>> _supportOptions = [
    {'title': S.current.product_inquiry, 'icon': Icons.help_outline},
    {'title': S.current.order_issue, 'icon': Icons.error_outline},
    {'title': S.current.suggestion, 'icon': Icons.lightbulb_outline},
    {'title': S.current.complaint, 'icon': Icons.report_outlined},
    {'title': S.current.other, 'icon': Icons.more_horiz},
  ];
  String _selectedOption = S.current.product_inquiry;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<SupportCubit>().resetState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isDarkMode),
          SliverToBoxAdapter(
            child: BlocConsumer<SupportCubit, SupportState>(
              listener: _supportStateListener,
              builder: (context, state) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSupportHeader(isDarkMode),
                        _buildQuickActions(isDarkMode),
                        _buildSupportOptions(isDarkMode),
                        _buildMessageInput(state, isDarkMode),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isDarkMode) {
    return SliverAppBar(
      scrolledUnderElevation: 0,
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 18,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          S.of(context).support_center,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDarkMode
                      ? [Colors.grey[850]!, Colors.grey[900]!]
                      : [Colors.white, Colors.grey[50]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  void _supportStateListener(BuildContext context, SupportState state) {
    if (state.isSuccess && state.messageSent) {
      _showSuccessMessage();
      _messageController.clear();
    }

    if (state.isError) {
      _showErrorMessage(state.errorMessage ?? S.of(context).error_send);
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).success_title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      S.of(context).success_desc,
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildSupportHeader(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Hero(
            tag: 'support_icon',
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.headset_mic_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            S.of(context).welcome_support,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            S.of(context).support_desc,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).quick_actions,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.chat_bubble_outline,
                  title: S.of(context).live_chat,
                  subtitle: S.of(context).available_now,
                  onTap: () {
                    // Navigate to live chat
                  },
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.phone,
                  title: S.of(context).direct_call,
                  subtitle: '19999',
                  onTap: () {
                    // Make phone call
                  },
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOptions(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).inquiry_type,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 4),
              itemCount: _supportOptions.length,
              itemBuilder: (context, index) {
                final option = _supportOptions[index];
                final isSelected = option['title'] == _selectedOption;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOption = option['title'];
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.8),
                                ],
                              )
                              : null,
                      color:
                          !isSelected
                              ? (isDarkMode ? Colors.grey[800] : Colors.white)
                              : null,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primary
                                : (isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!),
                        width: 1.5,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                              : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          option['icon'],
                          size: 18,
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600]),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          option['title'],
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : (isDarkMode
                                        ? Colors.white
                                        : Colors.black87),
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(SupportState state, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                S.of(context).write_message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.topic_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _selectedOption,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // نصيحة للمستخدم
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isDarkMode ? Colors.blue.withOpacity(0.1) : Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDarkMode
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.blue[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    S.of(context).tip_message,
                    style: TextStyle(
                      color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // حقل الرسالة
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: SupportMessageInput(
              controller: _messageController,
              focusNode: _messageFocusNode,
              onChanged: (value) {
                context.read<SupportCubit>().updateMessage(value);
              },
              isLoading: state.isLoading,
              onSend: () {
                if (_messageController.text.trim().isEmpty) {
                  _showEmptyMessageWarning(isDarkMode);
                  return;
                }
                FocusScope.of(context).unfocus();
                context.read<SupportCubit>().sendMessage();
              },
              hintText: S.of(context).message_hint,
              sendButtonText: S.of(context).send_message,
            ),
          ),

          // معلومات الرد
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isDarkMode ? Colors.green.withOpacity(0.1) : Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDarkMode
                        ? Colors.green.withOpacity(0.3)
                        : Colors.green[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 20,
                  color: isDarkMode ? Colors.green[300] : Colors.green[700],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    S.of(context).response_time,
                    style: TextStyle(
                      color: isDarkMode ? Colors.green[300] : Colors.green[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEmptyMessageWarning(bool isDarkMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.orange[100],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).empty_message_warning,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
