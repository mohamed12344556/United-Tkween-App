import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/admin/ui/views/support_admin_view.dart';
import '../cubits/support/support_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/support_message_item.dart';
import '../../../../core/routes/routes.dart';
import 'support_admin_view.dart';

class SupportAdminView extends StatefulWidget {
  const SupportAdminView({super.key});

  @override
  State<SupportAdminView> createState() => _SupportAdminViewState();
}

class _SupportAdminViewState extends State<SupportAdminView> {
  final _messageController = TextEditingController();
  String? _selectedCustomerId;

  @override
  void initState() {
    super.initState();
    context.read<SupportAdminCubit>().loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'دعم العملاء'),
      drawer: AdminDrawer(currentRoute: Routes.adminSupportView),
      body: BlocBuilder<SupportAdminCubit, SupportAdminState>(
        builder: (context, state) {
          if (state is SupportLoading) {
            return const LoadingWidget();
          } else if (state is SupportError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () => context.read<SupportAdminCubit>().loadMessages(),
            );
          } else if (state is SupportLoaded) {
            return Column(
              children: [
                Expanded(
                  child:
                      state.messages.isEmpty
                          ? const Center(
                            child: Text(
                              'لا توجد رسائل دعم',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              return SupportMessageItem(
                                message: message,
                                onTap: () {
                                  setState(() {
                                    _selectedCustomerId = message.id;
                                  });
                                  if (!message.isRead) {
                                    context
                                        .read<SupportAdminCubit>()
                                        .markMessageAsRead(message.id);
                                  }

                                  // Focus the text field and prepare to reply
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(FocusNode());
                                  _messageController.text =
                                      'رداً على: ${message.message}\n\n';
                                },
                              );
                            },
                          ),
                ),
                _buildMessageInput(),
              ],
            );
          } else {
            return const Center(child: Text('حدث خطأ غير متوقع'));
          }
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selectedCustomerId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'الرد على العميل',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالتك هنا...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                color: Colors.red,
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تحديد عميل للرد عليه'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<SupportAdminCubit>().sendMessage(
      _selectedCustomerId!,
      _messageController.text.trim(),
    );

    _messageController.clear();
    setState(() {
      _selectedCustomerId = null;
    });
  }
}
