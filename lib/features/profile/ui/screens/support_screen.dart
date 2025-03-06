import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        listener: (context, state) {
          if (state.isSuccess && state.messageSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إرسال رسالتك بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
            _messageController.clear();
          }

          if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'خطأ في إرسال الرسالة'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            color: AppColors.primary,
            child: Column(
              children: [
                // Support form in white container
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Support icon and title
                        const Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.headset_mic,
                                size: 80,
                                color: AppColors.secondary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'كيف يمكننا مساعدتك؟',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'يمكنك ارسال استفسارك وسنرد عليك في أقرب وقت',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: _messageController,
                              focusNode: _messageFocusNode,
                              maxLines: 10,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'اكتب رسالتك هنا...',
                                hintTextDirection: TextDirection.rtl,
                              ),
                              onChanged: (value) {
                                context.read<SupportCubit>().updateMessage(
                                  value,
                                );
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.text,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Send button
                        ElevatedButton(
                          onPressed:
                              state.isLoading
                                  ? null
                                  : () {
                                    // Hide keyboard
                                    FocusScope.of(context).unfocus();
                                    // Send message
                                    context.read<SupportCubit>().sendMessage();
                                  },
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
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'إرسال',
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
              ],
            ),
          );
        },
      ),
    );
  }
}
