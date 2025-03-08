// file: lib/features/profile/ui/screens/support_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/profile/ui/widgets/content_container.dart';
import 'package:united_formation_app/features/profile/ui/widgets/support_message_input.dart';
import '../../../../core/core.dart';
import '../cubits/support/support_cubit.dart';
import '../cubits/support/support_state.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

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
      backgroundColor:
          context.isDarkMode ? AppColors.darkBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.secondary),
        title: const Text(
          'دعم المتجر',
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<SupportCubit, SupportState>(
        listener: _supportStateListener,
        builder: (context, state) {
          return ContentContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // أيقونة الدعم والعنوان
                _buildSupportHeader(),

                const SizedBox(height: 24),

                // نموذج الدعم
                Expanded(
                  child: SupportMessageInput(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    onChanged: (value) {
                      context.read<SupportCubit>().updateMessage(value);
                    },
                    isLoading: state.isLoading,
                    onSend: () {
                      // إخفاء لوحة المفاتيح
                      FocusScope.of(context).unfocus();
                      // إرسال الرسالة
                      context.read<SupportCubit>().sendMessage();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _supportStateListener(BuildContext context, SupportState state) {
    if (state.isSuccess && state.messageSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رسالتك بنجاح'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
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
          margin: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
    }
  }

  Widget _buildSupportHeader() {
    return Center(
      child: Column(
        children: [
          const Hero(
            tag: 'support_icon',
            child: Icon(
              Icons.headset_mic,
              size: 80,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'كيف يمكننا مساعدتك؟',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك ارسال استفسارك وسنرد عليك في أقرب وقت',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}