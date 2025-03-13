import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/admin/data/models/support_message_model.dart';
import '../cubits/support/support_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
import '../widgets/loading_widget.dart';
import 'package:intl/intl.dart';

class SupportChatAdminView extends StatefulWidget {
  final String customerId;
  final String customerName;

  const SupportChatAdminView({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<SupportChatAdminView> createState() => _SupportChatAdminViewState();
}

class _SupportChatAdminViewState extends State<SupportChatAdminView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'محادثة ${widget.customerName}'),
      body: BlocBuilder<SupportAdminCubit, SupportAdminState>(
        builder: (context, state) {
          if (state is SupportLoading) {
            return const LoadingWidget();
          } else if (state is SupportError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is SupportLoaded) {
            final filteredMessages =
                state.messages
                    .where((msg) => msg.id == widget.customerId)
                    .toList();

            return Column(
              children: [
                Expanded(
                  child:
                      filteredMessages.isEmpty
                          ? const Center(
                            child: Text(
                              'لا توجد رسائل',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : ListView.builder(
                            controller: _scrollController,
                            itemCount: filteredMessages.length,
                            itemBuilder: (context, index) {
                              final message = filteredMessages[index];
                              return _buildMessageItem(message);
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

  Widget _buildMessageItem(SupportMessageModel message) {
    final isUserMessage = message.customerName == widget.customerName;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isUserMessage)
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(
                message.customerName.substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUserMessage ? Colors.grey[300] : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.message, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(message.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (!isUserMessage)
            const CircleAvatar(
              backgroundColor: Colors.red,
              child: Text('أنا', style: TextStyle(color: Colors.white)),
            ),
        ],
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.red,
            radius: 24,
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    context.read<SupportAdminCubit>().sendMessage(
      widget.customerId,
      _messageController.text.trim(),
    );

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Today, show time only
      return DateFormat.jm().format(dateTime);
    } else {
      // Not today, show date and time
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    }
  }
}
