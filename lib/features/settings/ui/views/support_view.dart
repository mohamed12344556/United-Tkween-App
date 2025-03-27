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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubits/support/support_cubit.dart';
import '../cubits/support/support_state.dart';
import '../widgets/support_message_input.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<String> _supportOptions = [
    'استفسار عن منتج',
    'مشكلة في الطلب',
    'اقتراح',
    'شكوى',
    'أخرى',
  ];
  String _selectedOption = 'استفسار عن منتج';

  @override
  void initState() {
    super.initState();
    context.read<SupportCubit>().resetState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'دعم المكتبة',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: BlocConsumer<SupportCubit, SupportState>(
        listener: _supportStateListener,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSupportHeader(),
              _buildSupportOptions(),
              Expanded(child: _buildMessageInput(state)),
            ],
          );
        },
      ),
    );
  }

  void _supportStateListener(BuildContext context, SupportState state) {
    if (state.isSuccess && state.messageSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إرسال رسالتك بنجاح'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      _messageController.clear();
    }

    if (state.isError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'خطأ في إرسال الرسالة'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _buildSupportHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Hero(
            tag: 'support_icon',
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary, blurRadius: 4)],
              ),
              child: Icon(
                Icons.headset_mic,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'كيف يمكننا مساعدتك؟',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك ارسال استفسارك وسنرد عليك في أقرب وقت',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOptions() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _supportOptions.length,
        itemBuilder: (context, index) {
          final option = _supportOptions[index];
          final isSelected = option == _selectedOption;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedOption = option;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[700]!,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.text,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput(SupportState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SupportMessageInput(
        controller: _messageController,
        focusNode: _messageFocusNode,
        onChanged: (value) {
          context.read<SupportCubit>().updateMessage(value);
        },
        isLoading: state.isLoading,
        onSend: () {
          FocusScope.of(context).unfocus();
          context.read<SupportCubit>().sendMessage();
        },
        hintText: 'اكتب رسالتك هنا...',
        sendButtonText: 'إرسال الرسالة',
      ),
    );
  }
}
